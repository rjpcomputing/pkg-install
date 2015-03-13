local plugin = require( "plugins.interface" )

local _M =
{
	name			= "Debian",
	distro			= "Debian",
	description		= "Packages installed on all Debian systems",
	_VERSION		= "1.0-dev",
	plugins			= -- Plugins this uses
	{
		"deb-core",
		"lua-package-install"
	},
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
	PreInstall	= function( self, options )
		print( "[DEBUG]", self.name, "PreInstall() called..." )
	end,
	Install		= function( self, options )
		print( "[DEBUG]", self.name, "Install() called..." )
	end,
	PostInstall = function( self, options )
		print( "[DEBUG]", self.name, "PostInstall() called..." )
	end
}

return function( options )
	options = options or { distributor_id = "" }
	if options.distributor_id:lower() == "debian" then
		_M.versionSpecific	= require( "debian." .. options.codename )
		print( ("Loaded sub-module %q"):format( "debian." .. options.codename ) )
	end

	return _M
end
