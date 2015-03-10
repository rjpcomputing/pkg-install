-- ----------------------------------------------------------------------------
--	pkg-install plugin definition
--	Author:	R. Pusztai <rjpcomputing@gmail.com>
--	Date:	03/09/2015
-- ----------------------------------------------------------------------------
local Plugins =
{
	-- Add plugins here
	plugins	= { "deb-core", "lua-package-install", "ubuntu", "debian" },
	loadedPlugins = {},
}
Plugins.__index = Plugins
function Plugins.new( options )
	local self = setmetatable( {}, Plugins )
	self.options	= options

	return self
end

-- Constructor
function Plugins:Add( pluginName )
	assert( "string"	== type( pluginName ), "Invalid pluginName. Expected string, but found " .. type( pluginName ) )
	local plugin = require( pluginName )
	assert( "function"	== type( plugin ), "Invalid arg1. Expected function, but found " .. type( plugin ) )
	-- Initialize the plugin passing in details about the current run
	plugin = plugin( self.options )
	assert( "string"	== type( plugin.name ), "Invalid plugin.name. Expected string, but found " .. type( plugin.name ) )
	assert( "string"	== type( plugin._VERSION ), "Invalid plugin._VERSION. Expected string, but found " .. type( plugin._VERSION ) )
	self.loadedPlugins[plugin.name] = plugin

	return plugin
end

function Plugins:Load()
	print( ("Loading %i plugins..."):format( #self.plugins ) )
	for _, plugin in ipairs( self.plugins ) do
		self:Add( plugin )
		print( ("Loaded %q..."):format( plugin ) )
	end

	return self.loadedPlugins
end

return Plugins
