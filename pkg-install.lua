#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your machine up and running quickly after a fresh install.
-- Author:	Ryan P. <rjpcomputing@gmail.com>
-- Date:	04/15/2014
-- Notes:	Built against Ubuntu 14.10 (Utopic Unicorn).
--			Assumes root privileges.
--
-- Changes:
--	11/10/2014 (14.10-01) - Initial Release with plugin support.
-- ----------------------------------------------------------------------------
-- require( "pl" )
-- Allow plugins to require other plugins
package.path	= package.path .. (";%s/.pkg-install/plugins/?.lua;%s/.pkg-install/plugins/?/init.lua;./plugins/?.lua;./?/init.lua;./plugins/?/init.lua"):format( homeDir, homeDir )
package.cpath	= package.cpath .. (";%s/.pkg-install/plugins/?.so;./plugins/?.so;%s/.pkg-install/plugins/?.dll;./plugins/?.dll;%s/.pkg-install/plugins/?/init.so;./plugins/?/init.so;./?/init.so;%s/.pkg-install/plugins/?/init.dll;./plugins/?/init.dll;./?/init.dll"):format( homeDir, homeDir, homeDir, homeDir)
local Plugins = require( "plugins" )
local argparser = require( "argparse" )

local homeDir	= os.getenv( "HOME" )

-- Helper Functions -----------------------------------------------------------
--
local function FileExists( fileName )
	local file = io.open( fileName )
	if file then
		io.close( file )
		return true
	else
		return false
	end
end

local function OperatingSystemDetails()
	local lsbRelease = io.popen( "lsb_release -idrc" )
	local releaseInfo = lsbRelease:read( "*all" )
	lsbRelease:close()

	-- parse info
	local osDetails = {}
	for k, v in string.gmatch( releaseInfo, "([%w%s]+):%s(.-)%c" ) do
		osDetails[k:gsub(" ", "_"):lower()] = v
	end

	return osDetails
end

-- Utils Class ----------------------------------------------------------------
--
Utils = {}

--- assert that the given argument is in fact of the correct type.
-- @param n argument index
-- @param val the value
-- @param tp the type
-- @param verify an optional verfication function
-- @param msg an optional custom message
-- @param lev optional stack position for trace, default 2
-- @raise if the argument n is not the correct type
-- @usage assert_arg(1,t,'table')
-- @usage assert_arg(n,val,'string',path.isdir,'not a directory')
function Utils.AssertArg(n,val,tp,verify,msg,lev)
    if type(val) ~= tp then
        error(("argument %d expected a '%s', got a '%s'"):format(n,tp,type(val)),lev or 2)
    end
    if verify and not verify(val) then
        error(("argument %d: '%s' %s"):format(n,val,msg),lev or 2)
    end
end

--- assert the common case that the argument is a string.
-- @param n argument index
-- @param val a value that must be a string
-- @raise val must be a string
function Utils.AssertString (n,val)
    Utils.AssertArg(n,val,'string',nil,nil,3)
end

-- Copy a table into another in-place
-- @returns first table with t2 contents
function Utils.TableUpdate( t1, t2 )
	Utils.AssertArg( 1,t1,'table' )
	Utils.AssertArg( 2,t2,'table' )
	for k, v in pairs( t1 ) do
		t1[k] = v
	end

	return t1
end

--- insert values into a table.
-- similar to table.insert but inserts values from given table values,
-- not the object itself, into table t at position pos.
-- @within Copying
-- @array t the list
-- @int[opt] position (default is at end)
-- @array values
function Utils.InsertValues(t, ...)
    Utils.AssertArg(1,t,'table')
    local pos, values
    if select('#', ...) == 1 then
        pos,values = #t+1, ...
    else
        pos,values = ...
    end
    if #values > 0 then
        for i=#t,pos,-1 do
            t[i+#values] = t[i]
        end
        local offset = 1 - pos
        for i=pos,pos+#values-1 do
            t[i] = values[i + offset]
        end
    end
    return t
end

-- DebInit Class --------------------------------------------------------------
--
local PkgInstall =
{
	_NAME		= "pkg-install",
	_VERSION	= "2.0-dev",
	args		= args,
	hello		=
[=[       __                                             __             ___    ___
      /\ \                        __                 /\ \__         /\_ \  /\_ \
 _____\ \ \/'\      __           /\_\    ___     ____\ \ ,_\    __  \//\ \ \//\ \
/\ '__`\ \ , <    /'_ `\  _______\/\ \ /' _ `\  /',__\\ \ \/  /'__`\  \ \ \  \ \ \
\ \ \L\ \ \ \\`\ /\ \L\ \/\______\\ \ \/\ \/\ \/\__, `\\ \ \_/\ \L\.\_ \_\ \_ \_\ \_
 \ \ ,__/\ \_\ \_\ \____ \/______/ \ \_\ \_\ \_\/\____/ \ \__\ \__/.\_\/\____\/\____\
  \ \ \/  \/_/\/_/\/___L\ \         \/_/\/_/\/_/\/___/   \/__/\/__/\/_/\/____/\/____/
   \ \_\            /\____/
    \/_/            \_/__/
]=]

}
PkgInstall.__index = PkgInstall
function PkgInstall.new()
	local self = setmetatable( {}, PkgInstall )
	self.operatingSystemDetails = OperatingSystemDetails()
	print( pretty.write( self.operatingSystemDetails ) )

	self.homeDir	= os.getenv( "HOME" )
	-- Allow plugins to require other plugins
	package.path	= package.path .. (";%s/.pkg-install/plugins/?.lua;%s/.pkg-install/plugins/?/init.lua;./plugins/?.lua;./?.lua;./plugins/?/init.lua"):format( self.homeDir, self.homeDir )
	package.cpath	= package.cpath .. (";%s/.pkg-install/plugins/?.so;./plugins/?.so;%s/.pkg-install/plugins/?.dll;./plugins/?.dll;%s/.pkg-install/plugins/?/init.so;./plugins/?/init.so;%s/.pkg-install/plugins/?/init.dll;./plugins/?/init.dll"):format( self.homeDir, self.homeDir, self.homeDir, self.homeDir)
    local parser = argparse()
        :name( self._NAME )
        :description( "Script to get your machine up and running quickly after a fresh install." )

    local args = parser:parse()
    for k, v in pairs(args) do print(k, v) end

	return self
end

-- Returns the operating systems name in lowercase
function PkgInstall:GetOperatingSystemName()
	return self.operatingSystemDetails.distributor_id:lower()
end

local function IsRunningInVm()
	local cmdOutput = io.popen( "dmidecode  | grep -i product" ):read( "*all" )
	if cmdOutput:find( "VirtualBox" ) or cmdOutput:find( "VMWare" ) then
		return true
	else
		return false
	end
end

function main()
	local app = PkgInstall.new()
	print( app._NAME .. " v" .. app._VERSION .. " - Script to get your machine up and running quickly after a fresh install." )

	-- Check if script is being ran as root.
	local username = os.getenv( "USER" )
	if username ~= "root" then
		error( "Please run this as root. Use 'sudo' to run this as root" )
	end

	if arg[1] ~= "--no-add-apt-sources" then
		-- Add the needed apt repository
		print( ">>", "Adding needed PPA's and keys to APT..." )
		AddExtraAptSources()
	end

	-- Update apt.
	print( ">>", "Updating APT..." )
	os.execute( "apt-get update" )
	-- Upgrade all packages
	print( ">>", "Upgrading packages..." )
	os.execute( "apt-get -y dist-upgrade" )



	-- Make sure Google Chrome does not add Googles repo during the install, because this script does it already.
	os.execute( "touch /etc/default/google-chrome" )

	-- Desktop install
	local desktop = args.desktop or true

	for _, desktopPackage in ipairs( app.desktopPackages ) do
		table.insert( allPackages, desktopPackage )
	end

	-- Install all packages
	print( ">>", "Installing packages..." )
	local cmd = "apt-get -y install " .. allPackages
	os.execute( cmd )

	print( ">>", "Installing packages that don't have any APT repository..." )
	InstallNonAptApplications()

	print( ">>", "Installing rocks..." )
	InstallRocks()

	-- Upgrade all packages again. In case there was a failure during install.
	print( ">>", "Finish with a full system package upgrate..." )
	os.execute( "apt-get -y dist-upgrade" )

	local success, domain = pcall( dofile, "domain-setup.lua" )
	if success then
		print( ">>", "Joining computer to domain..." )
		domain()
	else
		print( ">>", "No script for joining the domain found..." )
	end

	print( ">>", "Finished installing packages..." )
end

main()
