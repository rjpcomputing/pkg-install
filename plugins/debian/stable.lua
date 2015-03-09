local _M =
{
	name		= "Stable",
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
