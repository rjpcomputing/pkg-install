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
		"lua-package-install"
	},
	packages =
	{
		"sudo",
		"openjdk-7-jdk",
		"libexpat1-dev",
		"firmware-linux-nonfree",
	},
	desktopPackages =
	{
		"cups",
		"cups-client",
		"cups-pdf",
		"dmz-cursor-theme",
		"gnome-tweak-tool",
		"rabbitvcs-nautilus",
		"flashplugin-nonfree",
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
		codelite =
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
		},

		--[[virtualbox =
		{
			listEntry = "deb http://download.virtualbox.org/virtualbox/debian "..options.codename:lower().." contrib non-free",
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.9 (GNU/Linux)

mQGiBEvy0LARBACPBH1AUv6krDseyvbL63CWS9fw43iReZ+NmgmDp4/sPsYHLduQ
rxKSqiK7fgFFE+fas/7DCaZXIQW6hnqeD3CgnX0w1+gYiyqEuPY1LQH9okBR5o92
/s2FLm7oUN4RNGv6vWoNSH1ZiRHknL5D0pKSGTKU+pG6cBYWJytAuJZHfwCguS55
aPZuXfhjaWsXG8TF6GH0K8ED/RY3KbirJ7rueK/7KL7ziwqn4CdhQSLOhbZ/R2E0
bknJQDo+vWJciRRRpTe+AG59ctgDF7lEXpjvCms0atyKtE8hObNaMJ5p48l/sgFL
LEujqiq4tByAn2hDOf0s7YrfruIY+HHkBSI9XbwH9nPlsQq8WNsTWTzPrw+ZlQ7v
AEuuA/9cJ/4qYUOq1pg3i/GqH+2dbRHOFH6idXr5YrdB3cYW8jORagOcwdQHeV/0
CaTZVMyMhTVjtIiUt+UR/96CHKxedg0giHwD61GidpUVBUYSaDhjOKE3jwf6/jo5
714e4+ZfL3y1Q2N4HzfK/gEkvPZby/o8WX2N7vUcxfztQ8yq6bRJT3JhY2xlIENv
cnBvcmF0aW9uIChWaXJ0dWFsQm94IGFyY2hpdmUgc2lnbmluZyBrZXkpIDxpbmZv
QHZpcnR1YWxib3gub3JnPohgBBMRAgAgBQJL8tCwAhsDBgsJCAcDAgQVAggDBBYC
AwECHgECF4AACgkQVEIqS5irUTmlvwCeIjsPZ0I9HhLmlS9dLjk397Y5rncAn3kB
XUPRIWb83FMxRwqS85rTCZyouQINBEvy0LAQCAC/pkqDW6H99qQdyW8zvQL5xj6C
UcvlTpL5VkaIRDVwRNbiFoWsVMv2jdhmlJEoh5N+aXYcAzLv0HaiZBSDmTO6fqMM
uPRHyIioQQUFNW4hRI7sdMkYvd2oZcxnzRCLdzG+s42EmzxE4F29eT/FA7o/QBj2
nDbomVqM9jCXKB5/jSJ0W3Uf7I8b7go0AawJT9vVARRMFjz4A7h6QfjeSO9sPHSC
1Dx5Fmd3u4y08W+o6w2kxXRYT9wfMFuGl4MWVJ+f6KPyRhqRCEaa/mz7lXhQdfeG
qW8psDHKmoNnpPEq5Rl4aDIJOppwYJhnDELv+k8JJ6R1JM9hJUWTG8zv9sLzAAMF
CAC6pagGYEK8Dh+3SV6dXjBLNghmj5qnx6GoCXwCDTEFXeWUnszZrqM7PTKLyrfK
ZjOhluydpQSGY7TqDBJJ6emLyNNJV92IQ21eN/h9i0wB97pu8jwvi7RjD0vSkDHh
OpSr9vJm9EeESU1Z+mEKOjz2AONjRLplbBNt9kbXmSWpIP8XMFkU+1KTuNbfi+h4
muOJWKkAGcT7bMUlqbZQjZ2O0RtwDjThxHvw8NhRkxPDYHVxE4uRRobhPquq4NsC
QkMc7LlRilXZCS5mrabHw5+edullNWaQtGuKGlQXGfM4kEhGt7b/XIiyhI5bsh60
o8Mz0KuFpClp9B7c78+QBzTbiEkEGBECAAkFAkvy0LACGwwACgkQVEIqS5irUTnq
qACgtXuTbe2b72sgKdc6gGRKPhLDoEMAmgLwGVN3a4CqewQL+03bqfcKczNH
=19g1
-----END PGP PUBLIC KEY BLOCK-----]=]
		},]]

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
