local _M =
{
	name		= "Testing",
	description	= "Specific details for installing Debian Testing (Jessie)",
	_VERSION	= "1.0-dev",
	packages	=
	{
		-- General
		-- Development
		"premake4",
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
