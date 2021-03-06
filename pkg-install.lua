#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your machine up and running quickly after a fresh install.
-- Author:	Ryan P. <rjpcomputing@gmail.com>
-- Date:	04/15/2014
-- Notes:
--			Assumes root privileges.
--
-- Changes:
--	04/28/2015 (2.0-dev) - Initial Release with plugin support.
--	08/25/2015 (2.0-4) - Adding tweak support.
--	08/25/2015 (2.0-5) - Made tweaks aware of OS details so they can make choices specific to OS.
--	10/20/2015 (2.0-6) - Added Sid and Stretch Debian support.
--	                   - Added no-domain flag to skip domain joining.
--	11/04/2015 (2.0-7) - Added Wily and Xenial Ubuntu support.
--	                   - With no-desktop only add certain PPAs.
--	04/01/2016 (2.0-8) - Added wxWebview.
--	                   - Added log4cplus.
--	                   - Added asio.
--	07/19/2017 (2.0-9) - Removed libboost-dbg.
--	                   - Added openjdk-8-jdk for sid and stretch.
--	                   - Changed virtualbox to v5.1.
--	                   - Added flash player for sid and stretch.
--	07/19/2017 (2.0-10) - Removed flash player for sid and stretch. Must use Google Chrome.
-- ----------------------------------------------------------------------------
-- require( "pl" )
local argparse = require( "argparse" )

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

local function IsRunningInVm()
	os.execute( "apt-get install -y virt-what" )
	local cmdOutput = io.popen( "virt-what 2>&1" ):read( "*all" )
	local vmNames = { "kvm", "parallels", "qemu", "virtualbox", "vmware", "xen" }
	for _, name in ipairs( vmNames ) do
		if cmdOutput:find( name ) then
			return true
		end
	end

	return false
end

-- Utils Class ----------------------------------------------------------------
--
Utils = {}

--- assert that the given argument is in fact of the correct type.
-- @param n argument index
-- @param val the value
-- @param tp the type
-- @param verify an optional verification function
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

--io.output( "pkg-install.print.txt" ):write( ("pkg-install started at %s\n"):format( os.date() ) )
--local oldPrint = print
--function print(...)
--	local o = io.open( "pkg-install.print.txt", "a+" )
--	o:write( ... )
--	o:write( "\n" )
--	o:close()
--	oldPrint( ... ); io.stdout:flush()
--end

-- DebInit Class --------------------------------------------------------------
--
local PkgInstall =
{
	_NAME		= "pkg-install",
	_VERSION	= "2.0-10",
--	args		= args,
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

	self.homeDir	= os.getenv( "HOME" )
	-- Allow plugins to require other plugins
	package.path	= package.path .. (";%s/.pkg-install/plugins/?.lua;%s/.pkg-install/plugins/?/init.lua;./plugins/?.lua;./?.lua;./?/init.lua;./plugins/?/init.lua"):format( self.homeDir, self.homeDir )
	package.cpath	= package.cpath .. (";%s/.pkg-install/plugins/?.so;./plugins/?.so;%s/.pkg-install/plugins/?.dll;./plugins/?.dll;%s/.pkg-install/plugins/?/init.so;./plugins/?/init.so;%s/.pkg-install/plugins/?/init.dll;./plugins/?/init.dll"):format( self.homeDir, self.homeDir, self.homeDir, self.homeDir)
    local parser = argparse()
        :name( self._NAME )
        :description( "Script to get your machine up and running quickly after a fresh install." )
	parser:argument( "tweaks", "File to run after all normal operations are complete." )
	   :args "?"
	parser:flag "-n" "--no-desktop"
		:description "Install the server packages only."
	parser:flag "-o" "--no-domain"
		:description "Skip joining the domain."
	parser:flag "-d" "--debug"
		:description "Show verbose debug messages."

    local args = parser:parse()

	self.operatingSystemDetails = OperatingSystemDetails()
	self.operatingSystemDetails.runningAsVm = IsRunningInVm()
	self.operatingSystemDetails.debug = args.debug

	if args.tweaks then
		local tweaks = nil
		if FileExists( args.tweaks ) then
			tweaks = dofile( args.tweaks )
			-- Verify the tweaks file is valid
			if "table" == type( tweaks ) then
				print( ">>", ("Loaded %i tweaks from %q"):format( #tweaks, args.tweaks ) )
			else
				error( ("Invalid tweaks file loaded (%s). The file must return a table of tweak objects."):format( args.tweaks ) )
			end
		end

		self.tweaks = tweaks
	end

	if args["no_desktop"] then
		print( ">>", "Server install started..." )
		self.operatingSystemDetails.desktop = false
	else
		self.operatingSystemDetails.desktop = true
	end

	if args["no_domain"] then
		print( ">>", "No domain support..." )
		self.operatingSystemDetails.joindomain = false
	else
		self.operatingSystemDetails.joindomain = true
	end

	return self
end

local function ProcessCommand( cmd )
	-- Check to see if the command to run is a function
	if "function" == type( cmd ) then
		print( ">>", tostring( cmd ) )
		cmd( OperatingSystemDetails() )
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
--		Command can be
local function ProcessTweaks( tweaks )
	for i = 1, #tweaks do
		print( ">", ("Tweak %q - %s"):format( tweaks[i].name, tweaks[i].comment ) )
		if "table" == type( tweaks[i].command ) then
			for j = 1, #tweaks[i].command do
				ProcessCommand( tweaks[i].command[j] )
			end
		else
			ProcessCommand( tweaks[i].command )
		end
	end
end

function main()
	local app = PkgInstall.new()
	print( app._NAME .. " v" .. app._VERSION .. " - Script to get your machine up and running quickly after a fresh install." )
	print( app.hello )

	-- Check if script is being ran as root.
	local username = os.getenv( "USER" )
	if username ~= "root" then
		error( "Please run this as root. Use 'sudo' to run this as root" )
	end

	local options = app.operatingSystemDetails
	--print( pretty.write( options ) )
	local Plugins = require( "plugins" )
	local loadedPlugins = Plugins:Load( options )

	-- Find plugins that focus on distros
	local mainPlugin = {}
	for pluginName, plugin in pairs( loadedPlugins ) do
		if plugin.distro then
			if options.distributor_id:lower() == plugin.distro:lower() then
				options.installCommand = plugin.installCommand
				mainPlugin = plugin

				break
			end
		end
	end

	print( ">>", ("%s (%s) is being installed..."):format( mainPlugin.distro, options.codename ) )
	-- Pre-install Event
	for _, pluginName in ipairs( mainPlugin.plugins ) do
		local plugin = loadedPlugins[pluginName]
		-- Uncomment to debug specific plugin
		--if plugin.name:lower() == "lua" then
		if plugin.PreInstall then plugin:PreInstall( options ) end
		--end
	end
	if mainPlugin.PreInstall then mainPlugin:PreInstall( options ) end

	-- Install Event
	if mainPlugin.Install then mainPlugin:Install( options ) end
	for _, pluginName in ipairs( mainPlugin.plugins ) do
		local plugin = loadedPlugins[pluginName]
		-- Uncomment to debug specific plugin
		--if plugin.name:lower() == "lua" then
		if plugin.Install then plugin:Install( options ) end
		--end
	end

	-- Post-install Event
	if mainPlugin.PostInstall then mainPlugin:PostInstall( options ) end
	for _, pluginName in ipairs( mainPlugin.plugins ) do
		local plugin = loadedPlugins[pluginName]
		-- Uncomment to debug specific plugin
		--if plugin.name:lower() == "lua" then
		if plugin.PostInstall then plugin:PostInstall( options ) end
		--end
	end

	-- Run any tweakfile passed in
	if app.tweaks then
		print( ">>", "Processing tweaks..." )
		ProcessTweaks( app.tweaks )
	end

	print( ">>", "Finished installing packages..." )
end

main()
