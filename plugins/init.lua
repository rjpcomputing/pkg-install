-- ----------------------------------------------------------------------------
--	pkg-install plugin definition
--	Author:	R. Pusztai <rjpcomputing@gmail.com>
--	Date:	03/09/2015
-- ----------------------------------------------------------------------------
local Plugins =
{
	-- Add plugin names here
	plugins	= { "deb-core", "lua-package-install", "ubuntu", "debian" },
	loadedPlugins = {},
}

function Plugins:Add( pluginName, options )
	assert( "string"	== type( pluginName ), "Invalid pluginName. Expected string, but found " .. type( pluginName ) )
	local plugin = require( pluginName )
	assert( "function"	== type( plugin ), "Error loading plugin. Expected function to be returned, but found " .. type( plugin ) )
	-- Initialize the plugin passing in details about the current run
	plugin = plugin( options )
	assert( "string"	== type( plugin.name ), "Invalid plugin.name. Expected string, but found " .. type( plugin.name ) )
	assert( "string"	== type( plugin._VERSION ), "Invalid plugin._VERSION. Expected string, but found " .. type( plugin._VERSION ) )
	self.loadedPlugins[pluginName] = plugin

	return plugin
end

function Plugins:Load( options )
	print( ("Loading %i plugins..."):format( #self.plugins ) )
	for _, plugin in ipairs( self.plugins ) do
		self:Add( plugin, options )
		print( ("Loaded %q..."):format( plugin ) )
	end

	return self.loadedPlugins
end

return Plugins
