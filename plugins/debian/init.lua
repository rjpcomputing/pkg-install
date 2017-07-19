local plugin = require( "plugins.interface" )

local _M =
{
	name			= "Debian",
	distro			= "Debian",
	description		= "Packages installed on all Debian systems",
	_VERSION		= "1.0",
	installCommand	= "apt-get -y install",
	plugins			= -- Plugins this uses
	{
		"deb-core",
		"lua-package-install"
	},
	packages =
	{
		"sudo",
		"libexpat1-dev",
		"firmware-linux-nonfree",
		"libwxgtk-webview3.0-dev",
	},
	desktopPackages =
	{
		"cups",
		"cups-client",
		"cups-pdf",
		"dmz-cursor-theme",
		"gnome-tweak-tool",
		"rabbitvcs-nautilus",
		"libgl1-mesa-dri",
		--"xserver-xorg-video-ati",
		--"xserver-xorg-video-nvidia",
		--"chromium",
		--"iceowl-extension",
	},
	PreInstall	= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PreInstall() called..." ) end
		self:AddExtraAptSources( options )
		os.execute( "apt-get update" )

		self.versionSpecific:PreInstall( options )
	end,
	Install		= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "Install() called..." ) end
		local allPackages = self:GetAllPackages( options )
		Utils.InsertValues( allPackages, self.versionSpecific.packages or {} )
		if options.desktop then Utils.InsertValues( allPackages, self.versionSpecific.desktopPackages or {} ) end
		table.sort( allPackages )

		local allPackagesString = table.concat( allPackages, " " )
		print( ">>", ("%i packages to be installed..." ):format( #allPackages ) )
		local cmd = options.installCommand .. " " .. allPackagesString
		print( "$ " .. cmd )
		local exitCode = os.execute( cmd )
		if exitCode ~= 0 then error( "Packages not installed correctly. Can not continue until the situation is fixed.") end

		self.versionSpecific:Install( options )
	end,
	PostInstall = function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PostInstall() called..." ) end
		-- Set the cursor so apps like Chrome use it.
		os.execute( "update-alternatives --set x-cursor-theme /usr/share/icons/DMZ-White/cursor.theme" )
		self.versionSpecific:PostInstall( options )
	end
}

function _M:AddExtraAptSources( options )
	local aptDetails =
	{
		--[[codelite =
		{
			listEntry = "deb http://repos.codelite.org/debian/ "..options.codename:lower().." contrib",
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.10 (GNU/Linux)

mQENBEyFTVoBCACiQXR6FXSrsjmCVa1380zYQ+QEE0OWegO1TwBzjYLQ+CSN/e3H
6XqBYdMEZo/eKTbUJxzUELkAQ/WrxSpJknxbr6PocQvCktyocMgK8cSpvvAgj2oh
Pj0TN2DkeAemvEsnk9jRZIbRo6/ylX4LhnkztSaAQxHICT1iXX9Arf9XgIl/7XYa
fDaNss3W+Ts/zIV0r9CgvBvBpJoePMrMyk9Ft+tM13b7r0oOQtmIfmIHUFYXk3ci
TtE9LuqvQNCIN0iDq9EvdI9hKZ46yVCKSNU93CLGwrionyz/tNKPl8Py8VptAwfJ
RUGccitpGLoruXpIloSyoFYSVNLqNa2QhQ7NABEBAAG0MERhdmlkIEhhcnQgKGNv
ZGVsaXRlIGtleSkgPGRhdmlkQGNvZGVsaXRlLmNvLnVrPokBOAQTAQIAIgUCTIVN
WgIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQaFbh2xrIJgnWagf9EoqF
OBbY+BeEpZ3UzSDz39rMSUAHTPzt+FLmrnU/g5MCoX5rEW3MiDuWBK5mkvfQTkrq
DRPNGZf/SQmqL5qjmt8uvX9e5oyOZAma1vZ1Aza+kni5XhmbNX3HkAznYAC9rnIP
QVLKVUVfGr9xLwJwnCvQ9XbrAMCOSiG5l2PNP1v31CLYvEiCoTiIUyjok/GnSSoO
fxxE6NDcWod4J3GjnOck+POPEIRjNs449kILt9zOJTDSTIeaO9cYknn8L4dLpfBl
rYKkeksPq5Ha0/Jcd86qsUzAIqEoXJw07IARMsXBTgG4gR/C2P78x77pBOitRFNx
KgGLozlAfSTMu3Xpi7kBDQRMhU1aAQgAusdK91OIJDwtoDmE+5Crqf0SZDQ4PijL
l4INXt0GE0exBOQCpCbFnk8Ja4zF4S2485kSrqE9AzPl1D1LYj01UiiwJQ09EwX2
5KKNCB/05IAGrRx10yb9ZiEe7PnsH/VlfwJapGZgyMwS8+6EmDffw23tHtX96ykr
vkBVWQkrAnnB+Q+7gs/y3+M1OQXLRxGx6N67EiTvygmAE93kI4wc+9lRbK/Au7B1
K9eWTLAhphFuFbNOgChdkv+zD57D1nclmNGG8EDwbxU4NjFdFUKUyKp0v+QB6OqM
fBdH4M10EDNX7Cn5wx0xJbMfny/LV/yUzmlRkDu4bn7BIJGoHrEroQARAQABiQEf
BBgBAgAJBQJMhU1aAhsMAAoJEGhW4dsayCYJcb8H/Ahp0JSqol1AiBIRxMQXNXh9
hha4MdPWW3rTcIuBVJ6FjEJPTw/rE9dbUcxjxoCn0WgYy48AFyrBp/TM4Y9CuAh7
AIyEtsxtuzEjf8keSpW6dsAhxpPrUXEDTUdNaDi/efNdHumZwl79mreFPIFiWlpg
VAPtLxbsylPXxJamylkSJ8UKGnu6qqSmvIB8vyMvYBtRXAjDR3XQ1u2dsaYAsiXF
Iftcemioz8bvdH/udEaUjsPyzm5JDqHafo08S2dEN+ZrJfIbw26HFl3LClYIxSdZ
L+nMjs7YCYWeC5oZVW3pepqDcT5IejgZL94IHgV6BvHcwwsDiW8lAdgHmz5Vs9o=
=g35i
-----END PGP PUBLIC KEY BLOCK-----]=],
		},]]

		virtualbox =
		{
			listEntry = "deb http://download.virtualbox.org/virtualbox/debian "..options.codename:lower().." contrib non-free",
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.12 (GNU/Linux)

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
=Rv7/
-----END PGP PUBLIC KEY BLOCK-----]=]
		},

		debmultimedia =
		{
			listEntry = "deb http://www.deb-multimedia.org "..options.codename:lower().." main non-free",
			key = [=[-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCAAGBQJZaL0wAAoJEFyAjCtlVYEXm3gP/R1BsQg95smLQVmxiIAnMCE+
iXRansJ7sI2aj+3JOasy+AcX7u9WM60KMlXp/pdzI3sU6DQJMCPe0n8CpqWdSX3W
fBYIho6E0BV7aPc91RN1vV5OXcp/oCz6LpIOhXlJKfskBw0W83/YOKHjw8Tj+NJS
AS/flWDYXKcc9Jw3DaGSpSWSBy+h3uJki5RC75rorBLpMAXes60SHd+LIUc9YwG+
l3alirliTMIooxSVg9Ns9eLXu79TPSkeyBEI6RGyJnGJBKTycTZtdAXenWcW7nN0
ASFZDhfkVsXGb7Yg4POt759kKb7iBx2GRjDUypFRS4TLmcvMRJSVkH8MEFSbBRf/
cG5HOOhC9YNCWlxwCSPgyCTla3tJxqAA2ZH9bZCgsMiGbzkCma7pG71CbzCKcBbC
pWP/g5ri5ir5YgSU0i5ifPXDxsx6dBnYdP/4tjoeevVcyjnpFgLENLEgrL4p0HpI
f4OmNmai4EbXVOLdGfni/FBHVIzYIbAPPCWCO5SWJKko+S8VJ4c2NAXcJ8u1jVHQ
dQFhmBJMIOMIs1CVo49ZYIKN9LS95LHr1T5sOzzw74vP1rA1sHkXVFMq43nABoKD
zUWP/Z0ZA18mcIfkfFn2anpj8RFGPDlcYfxHkYheBs3JmSbJEKxVpRVwg15pwYzg
exSlQphWRzjshzX3Pr0b
=lkKj
-----END PGP SIGNATURE-----]=]
		},

		chrome =
		{
			listEntry = "deb http://dl.google.com/linux/chrome/deb/ stable main",
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

mQGiBEXwb0YRBADQva2NLpYXxgjNkbuP0LnPoEXruGmvi3XMIxjEUFuGNCP4Rj/a
kv2E5VixBP1vcQFDRJ+p1puh8NU0XERlhpyZrVMzzS/RdWdyXf7E5S8oqNXsoD1z
fvmI+i9b2EhHAA19Kgw7ifV8vMa4tkwslEmcTiwiw8lyUl28Wh4Et8SxzwCggDcA
feGqtn3PP5YAdD0km4S4XeMEAJjlrqPoPv2Gf//tfznY2UyS9PUqFCPLHgFLe80u
QhI2U5jt6jUKN4fHauvR6z3seSAsh1YyzyZCKxJFEKXCCqnrFSoh4WSJsbFNc4PN
b0V0SqiTCkWADZyLT5wll8sWuQ5ylTf3z1ENoHf+G3um3/wk/+xmEHvj9HCTBEXP
78X0A/0Tqlhc2RBnEf+AqxWvM8sk8LzJI/XGjwBvKfXe+l3rnSR2kEAvGzj5Sg0X
4XmfTg4Jl8BNjWyvm2Wmjfet41LPmYJKsux3g0b8yzQxeOA4pQKKAU3Z4+rgzGmf
HdwCG5MNT2A5XxD/eDd+L4fRx0HbFkIQoAi1J3YWQSiTk15fw7RMR29vZ2xlLCBJ
bmMuIExpbnV4IFBhY2thZ2UgU2lnbmluZyBLZXkgPGxpbnV4LXBhY2thZ2VzLWtl
eW1hc3RlckBnb29nbGUuY29tPohjBBMRAgAjAhsDBgsJCAcDAgQVAggDBBYCAwEC
HgECF4AFAkYVdn8CGQEACgkQoECDD3+sWZHKSgCfdq3HtNYJLv+XZleb6HN4zOcF
AJEAniSFbuv8V5FSHxeRimHx25671az+uQINBEXwb0sQCACuA8HT2nr+FM5y/kzI
A51ZcC46KFtIDgjQJ31Q3OrkYP8LbxOpKMRIzvOZrsjOlFmDVqitiVc7qj3lYp6U
rgNVaFv6Qu4bo2/ctjNHDDBdv6nufmusJUWq/9TwieepM/cwnXd+HMxu1XBKRVk9
XyAZ9SvfcW4EtxVgysI+XlptKFa5JCqFM3qJllVohMmr7lMwO8+sxTWTXqxsptJo
pZeKz+UBEEqPyw7CUIVYGC9ENEtIMFvAvPqnhj1GS96REMpry+5s9WKuLEaclWpd
K3krttbDlY1NaeQUCRvBYZ8iAG9YSLHUHMTuI2oea07Rh4dtIAqPwAX8xn36JAYG
2vgLAAMFB/wKqaycjWAZwIe98Yt0qHsdkpmIbarD9fGiA6kfkK/UxjL/k7tmS4Vm
CljrrDZkPSQ/19mpdRcGXtb0NI9+nyM5trweTvtPw+HPkDiJlTaiCcx+izg79Fj9
KcofuNb3lPdXZb9tzf5oDnmm/B+4vkeTuEZJ//IFty8cmvCpzvY+DAz1Vo9rA+Zn
cpWY1n6z6oSS9AsyT/IFlWWBZZ17SpMHu+h4Bxy62+AbPHKGSujEGQhWq8ZRoJAT
G0KSObnmZ7FwFWu1e9XFoUCt0bSjiJWTIyaObMrWu/LvJ3e9I87HseSJStfw6fki
5og9qFEkMrIrBCp3QGuQWBq/rTdMuwNFiEkEGBECAAkFAkXwb0sCGwwACgkQoECD
D3+sWZF/WACfeNAu1/1hwZtUo1bR+MWiCjpvHtwAnA1R3IHqFLQ2X3xJ40XPuAyY
/FJG
=Quqp
-----END PGP PUBLIC KEY BLOCK-----]=]
		},
	}

	local file = io.output( "/etc/apt/sources.list.d/pkg-install-additional.list" )
	file:write( "# This file was created by a script, don't edit this by hand.\n# Any changes made will be lost.\n\n" )

	for ppa, value in pairs( aptDetails ) do
		print( ">>", "Adding '" .. ppa .. "' APT Repo" )
		if value.ppaRepo ~= nil then
			-- Add key using add-apt-repository.
			os.execute( "sudo add-apt-repository -y " .. value.ppaRepo )
		else
			-- Write the comment to the file.
			file:write( "# "..ppa.." APT Repo\n" )
			-- Write the list entry.
			file:write( value.listEntry )
			file:write( "\n\n" )

			-- Write the key file to a file so apt-key can add it.
			local keyFile = io.output( ppa..".key" )
			keyFile:write( value.key )
			keyFile:close()
			-- Add key using apt-key.
			os.execute( "apt-key add "..ppa..".key" )
			os.remove( ppa..".key" )
		end
	end

	file:close()
end

return function( options )
	options = options or { distributor_id = "" }
	if options.distributor_id:lower() == "debian" then
		_M.versionSpecific	= require( "debian." .. options.codename )( options )
		print( ("Loaded sub-module %q"):format( "debian." .. options.codename ) )
	end

	if options.desktop and options.joindomain then
		table.insert( _M.plugins, "domain-setup" )
	end

	return plugin.new( _M )
end
