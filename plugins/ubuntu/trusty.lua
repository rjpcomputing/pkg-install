local _M =
{
	name		= "14.04",
	description	= "Specific details for installing Ubnutu 14.04 (Trusty)",
	_VERSION	= "1.0-dev",
	packages	=
	{
		-- General
		-- Development
		-- Libraries
	},
	desktopPackages =
	{
		-- General
		-- Development
		-- Libraries
	},
	PreInstall	= function()
		print( "[DEBUG]", self.name, "PreInstall() called..." )
	end,
	Install		= function()
		print( "[DEBUG]", self.name, "Install() called..." )
	end,
	PostInstall = function()
		print( "[DEBUG]", self.name, "PostInstall() called..." )
	end
}

return function( options )
	if options and options.desktop then

	end

	return _M
end
