local plugin = require( "plugins.interface" )

local _M =
{
	name			= "Debian",
	distro			= "Debian",
	description		= "Packages installed on all Debian systems",
	_VERSION		= "1.0-dev",
	installCommand	= "apt-get -y install",
	plugins			= -- Plugins this uses
	{
		"deb-core",
		"lua-package-install",
		"domain-setup"
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
		self.versionSpecific:PreInstall( options )
	end,
	Install		= function( self, options )
		print( "[DEBUG]", self.name, "Install() called..." )
		local allPackages = self:GetAllPackages( options )
		Utils.InsertValues( allPackages, self.versionSpecific.packages or {} )
		if options.desktop then Utils.InsertValues( allPackages, self.versionSpecific.desktopPackages or {} ) end
		table.sort( allPackages )

		local allPackagesString = table.concat( allPackages, " " )
		print( (">> %i packages to be installed..." ):format( #allPackages ) )
		local cmd = options.installCommand .. " " .. allPackagesString
		print( "$ " .. cmd )
		os.execute( cmd )

		self.versionSpecific:Install( options )
	end,
	PostInstall = function( self, options )
		print( "[DEBUG]", self.name, "PostInstall() called..." )
		self.versionSpecific:PostInstall( options )
	end
}

return function( options )
	options = options or { distributor_id = "" }
	if options.distributor_id:lower() == "debian" then
		_M.versionSpecific	= require( "debian." .. options.codename )
		print( ("Loaded sub-module %q"):format( "debian." .. options.codename ) )
	end

	if options.desktop then
		table.insert( _M.plugins, "domain-setup" )
	end

	return plugin.new( _M )
end
