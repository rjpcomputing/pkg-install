#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your machine up and running as a TeamCity Build Agent.
-- Author:	Ryan Pusztai
-- Date:	11/05/2012
-- Notes:	Built against Ubuntu 12.10 (Quantal).
--			Assumes root privileges.
--
-- Changes:
--	11/05/2012 (12.10-01) - Initial Release
--	11/08/2012 (12.10-02) - Fixed path to TC properties file
--	11/08/2012 (12.10-03) - Fixed the absense of 'admin' group in Quantal
--	11/14/2012 (12.10-04) - Change the main user to autobuild instead of linbuilder
-- ----------------------------------------------------------------------------

-- General Setup
local distro	= "Quantal"
local appName	= "first-run_build-agent_linux"
local appVer	= "12.10-04"
local verbose	= false		-- "true" shows verbose output, "false" hides the prints

local oldPrint = print
function print( ... )
	if verbose then oldPrint( ... ) end
end

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

local function ProcessCommand( cmd, ... )
	-- Check to see if the command to run is a function
	if "function" == type( cmd ) then
		print( ">>", tostring( cmd ) )
		cmd( ... )
	elseif "string" == type( cmd ) then
		print( ">>", cmd )
		os.execute( cmd )
	else
		error( "Invalid command type (" .. type( cmd ) .. "). Only string and function are valid." )
	end
end

---	Tweak object
--	@class table
--	@name Tweaks
--	@field name {string} The name of the tweak
--	@field comment {string} A comment/short description of the tweak
--	@field command {table/string/function} If it is a table it can have values of either string or function. Each element in the table will be processed. If it is a string then os.execute() will be called on it. If it is a function it will call that function for you.

---	Processes the tweaks from the supplied .tweaks file
--	@param tweaks {table} Table of tweak objects. {name = "tweak name", comment = "Some comment", command = "cmd --to --execute"}
--	@param ... {vararg} Variable argument list to pass to commands
--		Command can be a string or table.
local function ProcessTweaks( tweaks, ... )
	for i = 1, #tweaks do
		print( ">", ("Tweak %q - %s"):format( tweaks[i].name, tweaks[i].comment ) )
		if "table" == type( tweaks[i].command ) then
			for j = 1, #tweaks[i].command do
				ProcessCommand( tweaks[i].command[j], ... )
			end
		else
			ProcessCommand( tweaks[i].command, ... )
		end
	end
end

local function GetHostname()
	return io.input( "/etc/hostname" ):read()
end

local function ChangeHostname( hostname )
	-- Change the /etc/hostname file
	local hostnameFilepath = "/etc/hostname"
	local oldHostname = GetHostname()
	-- Write the new hostname to the file
	io.open( hostnameFilepath, "w+" ):write( hostname .. "\n" )

	-- Change the /etc/hosts file
	local hostsFilepath = "/etc/hosts"
	local hostsContents = io.input( hostsFilepath ):read( "*a" )
	-- Change the contents
	hostsContents = hostsContents:gsub( "(127.0.1.1).-(%c)", "%1 " .. hostname .. "%2"	)

	io.output( hostsFilepath ):write( hostsContents )
end

local function SetBuildAgentProperty( contents, key, value, separator )
	separator = separator or "="

	return contents:gsub( ("(%s%s)(.-)(%%c)"):format( key, separator ), "%1" .. value .. "%3" )
end

local function ConfigureTeamCityBuildAgentProperties( hostname )
	local tcBuildAgentPropertiesFilepath = "/opt/tcBuildAgent/conf/buildAgent.properties"
	if FileExists( tcBuildAgentPropertiesFilepath ) then
		local contents = io.input( tcBuildAgentPropertiesFilepath ):read( "*a" )
		--contents = SetBuildAgentProperty( contents, "serverUrl", "http://zeusci.gentex.com/" )
		contents = SetBuildAgentProperty( contents, "name", hostname )
		--contents = SetBuildAgentProperty( contents, "workDir", "/mnt/data/tcBuildAgent/work" )
		--contents = SetBuildAgentProperty( contents, "tempDir", "/mnt/data/tcBuildAgent/temp" )

		io.output( tcBuildAgentPropertiesFilepath ):write( contents )
	else
		error( "buildAgent.properties file not found" )
	end
end

local tweaks =
{
	_VERSION = "1.00",
	_APP_NAME = "TeamCity Build Agent Setup Tweaks",
	{
		name = "configure-hostname",
		comment = "Configures machines hostname.",
		command = ChangeHostname
	},
	{
		name = "add-tc-build-agent-user",
		comment = "Adds 'linbuilder' user to the machine.",
		command =
		{
			"useradd autobuild -m -G sudo -s /bin/bash",	-- Add autobuild user and make it an admin
			"echo autobuild:lucid321 | chpasswd",			-- Set autobuild's password
		}
	},
	{
		name = "configure-tc-build-agent-properties",
		comment = "Configures TeamCity's build agent properties.",
		command = ConfigureTeamCityBuildAgentProperties
	},
}

function main()
	-- Check if script is being ran as root.
	local username = os.getenv( "USER" )
	if username ~= "root" then
		error( "Please run this as root. Use 'sudo' to run this as root", 0 )
	end

	oldPrint( "> " .. appName .. " v" .. appVer .. " - Quick setup of a TeamCity Build Agent." )

	local hostname = arg[1]
	if hostname then
		if tweaks then
			oldPrint( ">>", #tweaks + 1 .. " tweaks to install" )
			print( ">>", "Processing tweaks..." )
			ProcessTweaks( tweaks, hostname )
		end

		oldPrint( "> Finished installing packages..." )
		oldPrint( "> Reboot to complete setup (i.e. sudo reboot)..." )
	else
		error( ("Missing <HOSTNAME>\nPlease pass <HOSTNAME> as the first commandline argument\n\nUsage: %s <HOSTNAME>"):format( arg[0] ) )
	end
end

main()
