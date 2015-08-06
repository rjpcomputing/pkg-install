local _M =
{
	name		= "Wheezy",
	description	= "Specific details for installing Debian Stable (Wheezy)",
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
		"unetbootin",
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
