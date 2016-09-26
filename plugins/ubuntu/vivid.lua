local _M =
{
	name		= "15.04",
	description	= "Specific details for installing Ubnutu 15.04 (Vivid)",
	_VERSION	= "1.0",
	packages	=
	{
		-- General
		-- Development
		-- Libraries
		"libwxgtk-webview3.0-dev",
	},
	desktopPackages =
	{
		-- General
		-- Development
		"rabbitvcs-nautilus",
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
