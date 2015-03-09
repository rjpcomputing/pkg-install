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

	end,
	Install		= function()
	end,
	PostInstall = function()
	end
}

return function( options )
	if options and options.desktop then

	end

	return _M
end
