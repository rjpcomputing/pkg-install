local _M =
{
	name		= "Ubuntu Core",
	description	= "Packages installed on all Ubuntu systems",
	_VERSION	= "1.0-dev",
	packages =
	{
		"liblua5.1-sublua*",
		"premake4",
	},
	desktopPackages =
	{
		"ubuntu-restricted-extras",
		"unity-tweak-tool",
		"xul-ext-lightning",
		"rabbitvcs-nautilus3",
		--"chromium-browser",

		"wxformbuilder",
		"wxfb-wxadditions",
		"libwxadditions30*",
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
