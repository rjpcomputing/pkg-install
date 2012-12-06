-- ----------------------------------------------------------------------------
-- Tweaks to install and setup a TeamCity Build Agent for http://zeusci.gentex.com.
-- Author:	Ryan Pusztai	<ryan.pusztai@gentex.com>
-- Date:	11/05/2012
-- Notes:	Built against Ubuntu 12.10 (Quantal).
--
-- Changes:
--	11/05/2012 (1.0)	- Initial Release
--	11/13/2012 (1.1)	- Added unixodbc
--						- Added ADTF
--	11/14/2012 (1.2)	- Added environment variable setup
--						- Updated orgainization of task functions
--						- Create the directories for the work and temp for
--						  the agent
--						- Moved setting the HOME environment variable to the
--						  buildagent.properties file
--	11/20/2012 (1.3)	- Added unattended autoupdates
--	11/30/2012 (1.4)	- Added opencv and xvfb (with daemonize script) packages
-- ----------------------------------------------------------------------------

-- General Setup
local distro		= "Quantal"

---	Checks for the existance of a file.
--	@param fileName The file path and name as a string.
--	@return True if the file exists, else false.
local function FileExists( fileName )
	local file = io.open( fileName )
	if file then
		io.close( file )
		return true
	else
		return false
	end
end

local function SetBuildAgentProperty( contents, key, value, separator )
	separator = separator or "="

	return contents:gsub( ("(%s%s)(.-)(%%c)"):format( key, separator ), "%1" .. value .. "%3" )
end

local tweaks =
{
	_VERSION = "1.4",
	_APP_NAME = "TeamCity Build Agent Setup Tweaks",
	{
		name = "get-tc-build-agent",
		comment = "Download the latest TeamCity build agent software.",
		command =
		{
			"wget http://zeusci.gentex.com/update/buildAgent.zip",
			"unzip buildAgent.zip -d /opt/tcBuildAgent",
		}
	},
	{
		name = "install-tc-build-agent",
		comment = "Installs the TeamCity build agent.",
		command =
		{
			"chmod +x /opt/tcBuildAgent/bin/*.sh",
			"cd /opt/tcBuildAgent/bin && sudo ./install.sh http://zeusci.gentex.com -1"
		}
	},
	{
		name = "configure-tc-build-agent",
		comment = "Configures the TeamCity build agent.",
		command = function ()
			local tcBuildAgentPropertiesFilepath = "/opt/tcBuildAgent/conf/buildAgent.properties"
			if FileExists( tcBuildAgentPropertiesFilepath ) then
				-- Make sure the directories exist
				local workDir = "/mnt/data/tcBuildAgent/work"
				local tempDir = "/mnt/data/tcBuildAgent/temp"
				os.execute( ("mkdir -p %s"):format( workDir ) )
				os.execute( ("mkdir -p %s"):format( tempDir ) )
				-- Update the properties file
				local contents = io.input( tcBuildAgentPropertiesFilepath ):read( "*a" )
				contents = SetBuildAgentProperty( contents, "workDir", workDir )
				contents = SetBuildAgentProperty( contents, "tempDir", tempDir )
				-- Add the HOME environment variable to the TC build environment
				contents = contents .. "\nenv.HOME=/tmp\n"
				io.output( tcBuildAgentPropertiesFilepath ):write( contents )
			else
				error( "buildAgent.properties file not found" )
			end
		end
	},
	{
		name = "cleanup-tc-build-agent",
		comment = "Cleanup TeamCity Build agent temp files.",
		command = { "rm buildAgent.zip" }
	},
	{
		name = "install-misc-support-packages",
		comment = "Installs miscilanious packages that are Gentex specific.",
		command = { "apt-get -y install unixodbc libopencv-dev" }
	},
	{
		name = "install-adtf",
		comment = "Installs ADTF and it's support libraries.",
		command = function ()
			--  NOTICE: Just change this table to update version and download information for ADTF
			local adtfFilenames =
			{
				{
					name		= "ADTF",
					filename	= "adtf-2.8.0.run",
					url			= "http://eeweb.gentex.com/redmine/attachments/download/4629/adtf-2.8.0-linux64.run",
					destination	= "/opt/adtf/2.8.0"
				},
				{
					name		= "ADTF Device Toolbox",
					filename	= "adtf-device-toolbox-2.2.0.run",
					url			= "http://eeweb.gentex.com/redmine/attachments/download/4631/adtf-device-toolbox-2.2.0-adtf2.8.0-linux64.run",
					destination	= "/opt/adtf/2.8.0"
				},
				{
					name		= "ADTF Streaming Library",
					filename	= "adtf-streaminglib-2.5.1.run",
					url			= "http://eeweb.gentex.com/redmine/attachments/download/4630/adtf-streaminglib-2.5.1-adtf2.7.0-linux64.run",
					destination	= "/opt/adtf/streaming/2.5.1"
				}
			}

			for _, details in ipairs( adtfFilenames ) do
				-- Get the files
				os.execute( ("wget --output-document=%s %s"):format( details.filename, details.url ) )
				-- Make all files executable
				os.execute( ("chmod +x %s"):format( details.filename ) )
				-- Run the installer
				os.execute( ("./%s -- /S /D=%s"):format( details.filename, details.destination ) )
				-- Cleanup
				os.remove( details.filename )
			end
		end
	},
	{
		name = "setup-environmant-variables",
		comment = "Add the required environment variables to the system.",
		command = function ()
			local profiledContents =
([==[#!/bin/sh
# Generated on %s by install scripts.
# WARNING: Don't hand edit this file.
export ADTF_280=/opt/adtf/2.8.0
export ADTF_ROOT=$ADTF_280
export ADTF_STREAMING_251=/opt/adtf/streaming/2.5.1
export ADTF_STREAMING_ROOT=$ADTF_STREAMING_251
]==]):format( os.date() )
			local profiledFilepath = "/etc/profile.d/build-agent-extra-environment-variables.sh"
			io.output( profiledFilepath ):write( profiledContents )
			-- make it executable
			os.execute( ("chmod +x %s"):format( profiledFilepath ) )
		end
	},
	{
		name = "daemonize-build-agent-launch",
		comment = "Makes the build agent start at system power on.",
		command = function ()
			if not FileExists( "/etc/profile.d/build-agent-extra-environment-variables.sh" ) then
				error( "Environment variable profile.d file missing")
			end

			local serviceScript	=
[==[#!/bin/sh

# Add build agent environment variables.
. /etc/profile.d/build-agent-extra-environment-variables.sh

# Set this to meet your system configuration.
TEAMCITY_AGENT_HOME=/opt/tcBuildAgent

# Set to specify the Java to use.
#export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

case "$1" in
start|stop)
  sh $TEAMCITY_AGENT_HOME/bin/agent.sh $1 $2
;;
*)
  echo "Run as $0 (start|stop[ force])"
  exit 1
;;
esac
]==]
			local serviceLocation = "/etc/init.d/tcbuildagent"
			-- Write the file out
			io.output( serviceLocation ):write( serviceScript )

			-- Set permissions
			os.execute( ("chmod +x %s"):format( serviceLocation ) )
			-- Make it start with the system boot
			os.execute( "update-rc.d tcbuildagent defaults" )
		end,
	},
	{
		name = "daemonize-xvfb-launch",
		comment = "Makes Xvfb start at system power on.",
		command =
		{
			"apt-get -y install xvfb",
		function ()
			local serviceScript	=
[==[#! /bin/sh
### BEGIN INIT INFO
# Provides:          Xvfb
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start Xvfb.
# Description:       Start the X virtual framebuffer.
### END INIT INFO

# Author: Hannes Brandstaetter-Mueller <hannes.brandstaetter@fh-hagenberg.at>
#
# Please remove the "Author" lines above and replace them
# with your own name if you copy and modify this script.

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="X virtual framebuffer"
NAME="Xvfb"
DAEMON=/usr/bin/$NAME
DAEMON_ARGS=":1 -screen 0 640x480x24"
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
. /lib/lsb/init-functions

#
# Function that starts the daemon/service
#
do_start()
{
        # Return
        #   0 if daemon has been started
        #   1 if daemon was already running
        #   2 if daemon could not be started
        start-stop-daemon --start --background --quiet --pidfile $PIDFILE --exec $DAEMON --test > /dev/null \
                || return 1
        start-stop-daemon --start --background --quiet --pidfile $PIDFILE --exec $DAEMON -- \
                $DAEMON_ARGS \
                || return 2
        # Add code here, if necessary, that waits for the process to be ready
        # to handle requests from services started subsequently which depend
        # on this one.  As a last resort, sleep for some time.
}

#
# Function that stops the daemon/service
#
do_stop()
{
        # Return
        #   0 if daemon has been stopped
        #   1 if daemon was already stopped
        #   2 if daemon could not be stopped
        #   other if a failure occurred
        start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --pidfile $PIDFILE --name $NAME
        RETVAL="$?"
        [ "$RETVAL" = 2 ] && return 2
        # Wait for children to finish too if this is a daemon that forks
        # and if the daemon is only ever run from this initscript.
        # If the above conditions are not satisfied then add some other code
        # that waits for the process to drop all resources that could be
        # needed by services started subsequently.  A last resort is to
        # sleep for some time.
        start-stop-daemon --stop --quiet --oknodo --retry=0/30/KILL/5 --exec $DAEMON
        [ "$?" = 2 ] && return 2
        # Many daemons don't delete their pidfiles when they exit.
        rm -f $PIDFILE
        return "$RETVAL"
}

#
# Function that sends a SIGHUP to the daemon/service
#
do_reload() {
        #
        # If the daemon can reload its configuration without
        # restarting (for example, when it is sent a SIGHUP),
        # then implement that here.
        #
        start-stop-daemon --stop --signal 1 --quiet --pidfile $PIDFILE --name $NAME
        return 0
}

case "$1" in
  start)
        [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
        do_start
        case "$?" in
                0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
                2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
        esac
        ;;
  stop)
        [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
        do_stop
        case "$?" in
                0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
                2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
        esac
        ;;
  status)
       status_of_proc "$DAEMON" "$NAME" && exit 0 || exit $?
       ;;
  #reload|force-reload)
        #
        # If do_reload() is not implemented then leave this commented out
        # and leave 'force-reload' as an alias for 'restart'.
        #
        #log_daemon_msg "Reloading $DESC" "$NAME"
        #do_reload
        #log_end_msg $?
        #;;
  restart|force-reload)
        #
        # If the "reload" option is implemented then remove the
        # 'force-reload' alias
        #
        log_daemon_msg "Restarting $DESC" "$NAME"
        do_stop
        case "$?" in
          0|1)
                do_start
                case "$?" in
                        0) log_end_msg 0 ;;
                        1) log_end_msg 1 ;; # Old process is still running
                        *) log_end_msg 1 ;; # Failed to start
                esac
                ;;
          *)
                # Failed to stop
                log_end_msg 1
                ;;
        esac
        ;;
  *)
        #echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
        echo "Usage: $SCRIPTNAME {start|stop|status|restart|force-reload}" >&2
        exit 3
        ;;
esac
]==]
			local serviceLocation = "/etc/init.d/xvfbd"
			-- Write the file out
			io.output( serviceLocation ):write( serviceScript )

			-- Set permissions
			os.execute( ("chmod +x %s"):format( serviceLocation ) )
			-- Make it start with the system boot
			os.execute( "update-rc.d xvfbd defaults" )
		end,
		}
	},
	{
		name = "make-security-unattended-update",
		comment = "Make the server install security only updates unattended.",
		command = function ()
			local aptAutoUpdateFilepath = "/etc/apt/apt.conf.d/10periodic"
			if FileExists( aptAutoUpdateFilepath ) then
				local contents =
[==[APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
]==]
				-- Update the properties file
				local aptAutoUpdateContents = io.input( aptAutoUpdateFilepath ):read( "*a" )
				if not string.find( aptAutoUpdateContents, contents ) then
					io.output( aptAutoUpdateFilepath ):write( contents )
				end
			else
				error( aptAutoUpdateFilepath .. " file not found" )
			end
		end
	},
}

return tweaks
