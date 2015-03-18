#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
--	Test pkg-install plugin syste,
--	Author:	R. Pusztai <rjpcomputing@gmail.com>
--	Date:	03/09/2015
-- ----------------------------------------------------------------------------
require( "pl" )

-- Allow plugins to require other plugins
local homeDir	= os.getenv( "HOME" )
package.path	= package.path .. (";%s/.pkg-install/plugins/?.lua;%s/.pkg-install/plugins/?/init.lua;./plugins/?.lua;./?/init.lua;./plugins/?/init.lua"):format( homeDir, homeDir )
package.cpath	= package.cpath .. (";%s/.pkg-install/plugins/?.so;./plugins/?.so;%s/.pkg-install/plugins/?.dll;./plugins/?.dll;%s/.pkg-install/plugins/?/init.so;./plugins/?/init.so;./?/init.so;%s/.pkg-install/plugins/?/init.dll;./plugins/?/init.dll;./?/init.dll"):format( homeDir, homeDir, homeDir, homeDir)
local Plugins = require( "plugins" )

-- Helper functions -----------------------------------------------------------
--
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


local options = OperatingSystemDetails()
options.desktop = arg[1] or true
options.runningAsVm = IsRunningInVm()
print( pretty.write( options ) )

local function main()
	local loadedPlugins = Plugins:Load( options )
	local mainPlugin = {}

	-- Find plugins that focus on distros
	for pluginName, plugin in pairs( loadedPlugins ) do
		if plugin.distro then
			if options.distributor_id:lower() == plugin.distro:lower() then
				mainPlugin = plugin

				break
			end
		end
	end

	print( ">>", ("%s (%s) is being installed..."):format( mainPlugin.distro, options.codename ) )
	-- Pre-install Event
	for _, pluginName in ipairs( mainPlugin.plugins ) do
		local plugin = loadedPlugins[pluginName]
		if plugin.PreInstall then plugin:PreInstall( options ) end
	end
	if mainPlugin.PreInstall then mainPlugin:PreInstall( options ) end

	-- Install Event
	for _, pluginName in ipairs( mainPlugin.plugins ) do
		local plugin = loadedPlugins[pluginName]
		if plugin.Install then plugin:Install( options ) end
	end
	if mainPlugin.Install then mainPlugin:Install( options ) end


	-- Post-install Event
	for _, pluginName in ipairs( mainPlugin.plugins ) do
		local plugin = loadedPlugins[pluginName]
		if plugin.PostInstall then plugin:PostInstall( options ) end
	end
	if mainPlugin.PostInstall then mainPlugin:PostInstall( options ) end
end

main()
