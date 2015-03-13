local function AppendValues( tbl, values )
	local res = {}
	for _, value in ipairs( values ) do
		res[1 + #res] = value
	end

	return res
end

-- PluginInterface ------------------------------------------------------------
--
local PluginInterface = {}
PluginInterface.__index = PluginInterface
-- Constructor
function PluginInterface.new( options )
	local self = setmetatable( {}, PluginInterface )
	self.options	= options

	return self
end

function Plugins:GetAllPackages( plugin )
print( pretty.write( self ) )
	local allPackages = {}
	AppendValues( allPackages, self.packages or {} )
print( "[DEBUG]", "allpackages count:", #allPackages  )
	if self.options.desktop then AppendValues( allPackages, plugin.desktopPackages or {} ) end
print( "[DEBUG]", "allpackages count:", #allPackages  )

	for _, requiredPluginName in ipairs( plugin.plugins ) do
		AppendValues( allPackages, self.loadedPlugins[requiredPluginName].packages or {} )
		if self.options.desktop then AppendValues( allPackages, self.loadedPlugins[requiredPluginName].desktopPackages or {} ) end
print( "[DEBUG]", "allpackages count:", #allPackages  )
	end

	if self.options.runningAsVm then
		allPackages[1 + #allPackages] = "virtualbox-guest-dkms"
	end
print( "[DEBUG]", "allpackages count:", #allPackages  )

	return allPackages
end

return Plugins
