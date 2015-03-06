local _M =
{
	name		= "14.10",
	description	= "Specific details for installing Ubnutu 14.10 (Utopic)",
	_VERSION	= "1.0-dev",
	packages	=
	{
		-- General
		-- Development
		"premake4",
		"liblua5.1-sublua*",
		-- Libraries
	},
	desktopPackages =
	{
		-- General
		-- Development
		-- Libraries
	},
	PreInstall	= function()
	end,
	Install		= function()
	end,
	PostInstall = function()
	end
}

return function( options )
	if options and options.desktop then
		for _, desktopPackage in ipairs( _M.desktopPackages ) do
			table.insert( _M.packages, desktopPackage )
		end
	end

	return _M
end
