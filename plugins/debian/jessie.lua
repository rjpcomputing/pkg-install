local _M =
{
	name		= "Jessie",
	description	= "Specific details for installing Debian Stable (Jessie)",
	_VERSION	= "1.0",
	packages	=
	{
		-- General
		-- Development
		"premake4",
		-- Libraries
		"qt5-default",
	},
	desktopPackages =
	{
		-- General
		"gnome-themes-extras",
		-- Development
		-- Libraries
	},
	PreInstall	= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PreInstall() called..." ) end
	end,
	Install		= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "Install() called..." ) end
	end,
	PostInstall = function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PostInstall() called..." ) end
	end
}

return function( options )
	if options and options.desktop then

	end

	return _M
end
