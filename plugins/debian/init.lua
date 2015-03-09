local _M =
{
	name		= "Debian Core",
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
	return _M
end
