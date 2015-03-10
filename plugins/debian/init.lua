local _M =
{
	name		= "Debian",
	description	= "Packages installed on all Debian systems",
	_VERSION	= "1.0-dev",
	packages =
	{
	},
	desktopPackages =
	{
		"gnome-tweak-tool",
		"rabbitvcs-nautilus",
		--"chromium",
		--"iceowl-extension",
	},
	PreInstall	= function()
	end,
	Install		= function()
	end,
	PostInstall = function()
	end
}

return function( options )
	_M.options			= options or { release = "" }
	local osVersion		= options.release:gsub( "%.", "_" ) or "stable"
	if options.distributor_id:lower() == "debian" then
		_M.versionSpecific	= require( "debian." .. options.codename )
		print( ("Loaded sub-module %q"):format( "debian." .. options.codename ) )
	end

	return _M
end
