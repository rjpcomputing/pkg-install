local _M =
{
	name		= "14.10",
	description	= "Specific details for installing Ubnutu 14.10 (Utopic)",
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
		"nautilus-open-terminal",
		-- Development
		"rabbitvcs-nautilus3",
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
