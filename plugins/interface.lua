local Plugins = require( "plugins" )

local function AppendValues( tbl, values )
	for _, value in ipairs( values ) do
		tbl[1 + #tbl] = value
	end

	return tbl
end

-- PluginInterface ------------------------------------------------------------
--
local PluginInterface = {}
PluginInterface.__index = PluginInterface
-- Constructor
function PluginInterface.new( plugin )
	local self = setmetatable( plugin, PluginInterface )

	return self
end

function PluginInterface:GetAllPackages( options )
	local allPackages = {}
	AppendValues( allPackages, self.packages or {} )
	if options.debug then print( "[DEBUG]", "allpackages count:", #allPackages  ) end
	if options.desktop then
		AppendValues( allPackages, self.desktopPackages or {} )
		if options.debug then print( "[DEBUG]", "allpackages after desktop count:", #allPackages ) end
	end
	for _, requiredPluginName in ipairs( self.plugins or {} ) do
		if not Plugins.loadedPlugins[requiredPluginName] then
			error( ("Plugin %q not properly loaded. Please make sure it is added to the 'Plugins.plugins' array."):format( requiredPluginName ) )
		end
		allPackages = AppendValues( allPackages, Plugins.loadedPlugins[requiredPluginName].packages or {} )
		if options.desktop then allPackages = AppendValues( allPackages, Plugins.loadedPlugins[requiredPluginName].desktopPackages or {} ) end
		if options.debug then print( "[DEBUG]", ("Required plugin %q. allPackages count: %i"):format( requiredPluginName, #allPackages ) ) end
	end

	if options.runningAsVm then
		allPackages[1 + #allPackages] = "virtualbox-guest-dkms"
	end
	if options.debug then print( "[DEBUG]", "allpackages count:", #allPackages  ) end

	return allPackages
end

return PluginInterface
