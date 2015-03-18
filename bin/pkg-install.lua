#!/usr/bin/env lua

package.preload[ "plugins.ubuntu.utopic" ] = assert( (loadstring or load)(
"local _M =\
{\
	name		= \"14.10\",\
	description	= \"Specific details for installing Ubnutu 14.10 (Utopic)\",\
	_VERSION	= \"1.0\",\
	packages	=\
	{\
		-- General\
		-- Development\
		-- Libraries\
	},\
	desktopPackages =\
	{\
		-- General\
		-- Development\
		-- Libraries\
	},\
	PreInstall	= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PreInstall() called...\" ) end\
	end,\
	Install		= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"Install() called...\" ) end\
	end,\
	PostInstall = function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PostInstall() called...\" ) end\
	end\
}\
\
return function( options )\
	if options and options.desktop then\
\
	end\
\
	return _M\
end\
"
, '@'.."./plugins/ubuntu/utopic.lua" ) )

package.preload[ "plugins.debian.jessie" ] = assert( (loadstring or load)(
"local _M =\
{\
	name		= \"Jessie\",\
	description	= \"Specific details for installing Debian Testing (Jessie)\",\
	_VERSION	= \"1.0\",\
	packages	=\
	{\
		-- General\
		-- Development\
		\"premake4\",\
		-- Libraries\
	},\
	desktopPackages =\
	{\
		-- General\
		-- Development\
		-- Libraries\
	},\
	PreInstall	= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PreInstall() called...\" ) end\
	end,\
	Install		= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"Install() called...\" ) end\
	end,\
	PostInstall = function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PostInstall() called...\" ) end\
	end\
}\
\
return function( options )\
	if options and options.desktop then\
\
	end\
\
	return _M\
end\
"
, '@'.."./plugins/debian/jessie.lua" ) )

package.preload[ "plugins.debian.wheezy" ] = assert( (loadstring or load)(
"local _M =\
{\
	name		= \"Wheezy\",\
	description	= \"Specific details for installing Debian Stable (Wheezy)\",\
	_VERSION	= \"1.0\",\
	packages	=\
	{\
		-- General\
		-- Development\
		-- Libraries\
	},\
	desktopPackages =\
	{\
		-- General\
		-- Development\
		-- Libraries\
	},\
	PreInstall	= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PreInstall() called...\" ) end\
	end,\
	Install		= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"Install() called...\" ) end\
	end,\
	PostInstall = function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PostInstall() called...\" ) end\
	end\
}\
\
return function( options )\
	if options and options.desktop then\
\
	end\
\
	return _M\
end\
"
, '@'.."./plugins/debian/wheezy.lua" ) )

package.preload[ "plugins.interface" ] = assert( (loadstring or load)(
"local Plugins = require( \"plugins\" )\
\
local function AppendValues( tbl, values )\
	for _, value in ipairs( values ) do\
		tbl[1 + #tbl] = value\
	end\
\
	return tbl\
end\
\
-- PluginInterface ------------------------------------------------------------\
--\
local PluginInterface = {}\
PluginInterface.__index = PluginInterface\
-- Constructor\
function PluginInterface.new( plugin )\
	local self = setmetatable( plugin, PluginInterface )\
\
	return self\
end\
\
function PluginInterface:GetAllPackages( plugin )\
	local allPackages = {}\
	AppendValues( allPackages, self.packages or {} )\
	if self.options.debug then print( \"[DEBUG]\", \"allpackages count:\", #allPackages  ) end\
	if self.options.desktop then\
		AppendValues( allPackages, self.desktopPackages or {} )\
		if self.options.debug then print( \"[DEBUG]\", \"allpackages after desktop count:\", #allPackages ) end\
	end\
\
	for _, requiredPluginName in ipairs( Plugins.plugins or {} ) do\
		allPackages = AppendValues( allPackages, Plugins.loadedPlugins[requiredPluginName].packages or {} )\
		if self.options.desktop then allPackages = AppendValues( allPackages, Plugins.loadedPlugins[requiredPluginName].desktopPackages or {} ) end\
		if self.options.debug then print( \"[DEBUG]\", (\"Required plugin %q. allPackages count: %i\"):format( requiredPluginName, #allPackages ) ) end\
	end\
\
	if self.options.runningAsVm then\
		allPackages[1 + #allPackages] = \"virtualbox-guest-dkms\"\
	end\
	if self.options.debug then print( \"[DEBUG]\", \"allpackages count:\", #allPackages  ) end\
\
	return allPackages\
end\
\
return PluginInterface\
"
, '@'.."./plugins/interface.lua" ) )

package.preload[ "plugins.domain-setup" ] = assert( (loadstring or load)(
"\
-- ----------------------------------------------------------------------------\
-- Script to get your server machine up and running quickly after a fresh install.\
-- Author:	Ryan Pusztai\
-- Date:	03/16/2015\
-- Notes:\
--\
-- Changes:\
--	03/16/2015 (1.0-01) - Initial Release\
-- ----------------------------------------------------------------------------\
local _M =\
{\
	name		= \"domain-setup\",\
	description	= \"Install PowerBroker Identity Services and join the domain\",\
	_VERSION	= \"1.0\",\
	packages	=\
	{\
	},\
	PreInstall	= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PreInstall() called...\" ) end\
	end,\
	Install		= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"Install() called...\" ) end\
		-- Install  PowerBroker Identity Services\
		local url = \"http://download.beyondtrust.com/PBISO/8.2.1/linux.deb.x64/pbis-open-8.2.1.2979.linux.x86_64.deb.sh\"\
		local filename = url:gsub( \"\\\\\", \"/\" ):match( \"([^/]-[^%.]+)$\" )\
		os.execute( (\"wget %s\"):format( url ) )\
		os.execute( (\"chmod +x %s\"):format( filename ) )\
		os.execute( (\"./%s -- --no-legacy --dont-join install\"):format( filename ) )\
		-- Cleanup\
		os.execute( \"rm -rf pbis-open-*\" )\
\
		-- Join the domain\
		os.execute( \"/opt/pbis/bin/domainjoin-cli join GENTEX.COM compadd g3n_ADD\" )\
\
		-- Fix an Ubuntu 14.04 bug where it doesn't allow a login to finish and start X11/Unity\
		if options.distributor_id:lower() == \"ubuntu\" and options.release == \"14.04\" then\
			FixPAM1404()\
		end\
\
		-- Set the proper user domain prefix\
		os.execute( \"/opt/pbis/bin/config UserDomainPrefix WONDERLAN\" )\
		-- Change the \"HomeDirTemplate\" setting to have the value of \"%H/%D/%U\"\
		os.execute( '/opt/pbis/bin/config HomeDirTemplate \"%H/%D/%U\"' )\
		-- Make the default shell bash. This is what is the norm for Ubuntu.\
		os.execute( \"/opt/pbis/bin/config LoginShellTemplate /bin/bash\" )\
		-- Make sure to use the default domain so that the user does not need to login using DomainName\\username.\
		os.execute( \"/opt/pbis/bin/config AssumeDefaultDomain true\" )\
	end,\
	PostInstall = function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PostInstall() called...\" ) end\
		MakeUserAdmin()\
	end\
}\
\
local function MakeUserAdmin()\
	print( \"Do you want to add a user as admin? [yN]\" )\
	local shouldAddUser = io.stdin:read():lower() == \"y\"\
	if shouldAddUser then\
		print( \"Please enter the username to add as administrator and press <Enter>\" )\
		local username = io.stdin:read()\
\
		print( (\"Adding %q as an administrator of this machine\"):format( username ) )\
		local groupFilename = \"/etc/group\"\
\
		-- Add user to these specified groups\
		local groups = { \"adm\", \"cdrom\", \"sudo\", \"dip\", \"plugdev\", \"lpadmin\", \"sambashare\", \"dialout\" }\
		local groupLines = {}\
		for line in io.lines( groupFilename ) do\
			local addUsername = false\
			-- Search for lines starting with specific group\
			for _, group in ipairs( groups ) do\
				if string.find( line, (\"^%s:\"):format( group ) ) then\
					addUsername = true\
					break	-- It can only be found once per line\
				end\
			end\
\
			if addUsername == true then\
				groupLines[#groupLines + 1] = line .. \",\" .. username\
			else\
				groupLines[#groupLines + 1] = line\
			end\
		end\
\
		-- Backup group file\
		os.execute( (\"mv %s %s.bak\"):format( groupFilename, groupFilename ) )\
\
		-- Write it to disk\
		local groupFileOut = io.output( groupFilename )\
		groupFileOut:write( table.concat( groupLines, \"\\n\" ) )\
		groupFileOut:write( \"\\n\" )	-- Add a newline to the end of the file\
		groupFileOut:close()\
	end\
end\
\
local function FixPAM1404()\
	-- Read the file contents\
	local commonSession = io.input( \"/etc/pam.d/common-session\" )\
	local commonSessionContents = commonSession:read( \"*all\" )\
	commonSession:close()\
\
	-- Change the contents to fix the bug\
	commonSessionContents = commonSessionContents:gsub( \"session%s-sufficient%s-pam_lsass.so\", \"session [success=ok default=ignore] pam_lsass.so\" )\
\
	-- Write the modified contents to the file.\
	commonSession = io.output( \"/etc/pam.d/common-session\" )\
	commonSession:write( commonSessionContents )\
	commonSession:close()\
end\
\
return function( options )\
	return _M\
end\
"
, '@'.."./plugins/domain-setup.lua" ) )

package.preload[ "plugins.ubuntu.init" ] = assert( (loadstring or load)(
"local plugin = require( \"plugins.interface\" )\
\
local _M =\
{\
	name			= \"Ubuntu\",\
	distro			= \"Ubuntu\",\
	description		= \"Installs packages for based on the Ubuntu version\",\
	_VERSION		= \"1.0\",\
	plugins			= -- Plugins this uses\
	{\
		\"deb-core\",\
		\"lua-package-install\"\
	},\
	packages =\
	{\
		\"liblua5.1-sublua*\",\
		\"premake4\",\
	},\
	desktopPackages =\
	{\
		\"ubuntu-restricted-extras\",\
		\"unity-tweak-tool\",\
		\"xul-ext-lightning\",\
		\"rabbitvcs-nautilus3\",\
		--\"chromium-browser\",\
\
		\"wxformbuilder\",\
		\"wxfb-wxadditions\",\
		\"libwxadditions30*\",\
	},\
	PreInstall	= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PreInstall() called...\" ) end\
--		AddExtraAptSources()\
		os.execute( \"apt-get update\" )\
\
		self.versionSpecific:PreInstall( options )\
	end,\
	Install		= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"Install() called...\" ) end\
		local allPackages = self:GetAllPackages( options )\
		Utils.InsertValues( allPackages, self.versionSpecific.packages or {} )\
		if options.desktop then Utils.InsertValues( allPackages, self.versionSpecific.desktopPackages or {} ) end\
		table.sort( allPackages )\
\
		local allPackagesString = table.concat( allPackages, \" \" )\
		print( (\">> %i packages to be installed...\" ):format( #allPackages ) )\
		local cmd = \"apt-get -y install \" .. allPackagesString\
		print( \"$ \" .. cmd )\
--		os.execute( cmd )\
\
		self.versionSpecific:Install( options )\
	end,\
	PostInstall = function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PostInstall() called...\" ) end\
--		AddManualUserLogin()\
\
		self.versionSpecific:PostInstall( options )\
	end\
}\
\
local function AddManualUserLogin()\
	local filePath = \"/etc/lightdm/lightdm.conf.d/50-manual-login.conf\"\
	os.execute( (\"mkdir -p %s\"):format( filePath:match( \".*/\" ) ) )\
	os.execute( (\"touch %s\"):format( filePath ) )\
	local file = io.open( filePath, \"w+\" )\
	if file then\
		print( \">>\", \"Making manual user login possible...\" )\
\
		local linesToAdd = \"[SeatDefaults]\\nallow-guest=false\\ngreeter-show-manual-login=true\"\
		file:write( (\"%s\\n\"):format( linesToAdd ) )\
		file:close()\
	end\
end\
\
local function AddExtraAptSources()\
	local aptDetails =\
	{\
		--[[[\"boost-latest\"] =\
		{\
			ppaRepo = \"ppa:boost-latest/ppa\",\
			listEntry = \"deb http://ppa.launchpad.net/boost-latest/ppa/ubuntu \"..distro:lower()..\" main\\ndeb-src http://ppa.launchpad.net/boost-latest/ppa/ubuntu \"..distro:lower()..\" main\",\
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----\
Version: SKS 1.0.10\
\
mI0EStj7mgEEAKn3iB53wYRSSORMbMjrwYif14q2gG5eqHIyMargLVIRscIvKxFD9x6cedl0\
DspGPG3dzhQLtP59cs537q+Sw4o4fkmtpYmjebFXfVCVo2/OW+jueoRd1FO6TzYncx7M7vf9\
js/7cWJS+ajmNUEuPkBQ0KYKqBXmpd8wew/24Mg9ABEBAAG0FkxhdW5jaHBhZCBib29zdC1s\
YXRlc3SItgQTAQIAIAUCStj7mgIbAwYLCQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEAz7hK4C\
nbXH7jcD/AuyGCH5GFX2KSiYr5f9ok6sOQxu42MtwYkZ59rEdCU5x44n4jHPUZOevpidutPa\
FPj1IVLHus1M/k44s3QjDnaJu/WH6E8KW15xLxXhh724s6lrHuNqmd9Mu8v5lAE27ttOSSrZ\
hzXKImEEiTVJc40nhLfZXtQ0qBdGFqLPsRww\
=qE4j\
-----END PGP PUBLIC KEY BLOCK-----]=],\
		},]]\
\
		rabbitvcs =\
		{\
			ppaRepo = \"ppa:rabbitvcs/ppa\",\
			listEntry = \"deb http://ppa.launchpad.net/rabbitvcs/ppa/ubuntu \"..distro:lower()..\" main\\ndeb-src http://ppa.launchpad.net/rabbitvcs/ppa/ubuntu \"..distro:lower()..\" main\",\
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----\
Version: SKS 1.0.10\
\
mI0ESsykEwEEAKq7U4qgEM0AhtarHcAqMxmKN8TUUwktQWu/JNxk+aNoqK9P5pY+aRYFzUCX\
IVKVQg6KxC5TO4dapz4xvz8KvI0aKLtb6kpJhVKnydg000DA/bkEJbor/YBc4OfvdbjqPIbC\
O2CL394ZvDGqpQbXoP0Auy9wKF1A3Kvd2g8LZa7VABEBAAG0E0xhdW5jaHBhZCBSYWJiaXRW\
Q1OItgQTAQIAIAUCSsykEwIbAwYLCQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEC7leTY070o1\
mW0D/RWsC9AFVjEoQYF9UOdu4sq3eY6uT/GUfIBJMmm10SI4/CzBLChoRg9ZkCDAdlfP6qab\
bXQnWfI6BV0NwNbb4AQjImLvpXZikzx5NDbRXjML6/Qk9DkLfn6cZpKbr2gI41k1ar3LHCE2\
APlN9ZheYInv1XLS4G+jDQjnMbd0VdzP\
=P8E1\
-----END PGP PUBLIC KEY BLOCK-----]=],\
		},\
\
		--[[kupfer =\
			{\
				ppaRepo = \"ppa:kupfer-team/ppa\",\
				listEntry = \"deb http://ppa.launchpad.net/kupfer-team/ppa/ubuntu \"..distro:lower()..\" main\\ndeb-src http://ppa.launchpad.net/kupfer-team/ppa/ubuntu \"..distro..\" main\",\
				key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----\
Version: SKS 1.1.4\
Comment: Hostname: keyserver.ubuntu.com\
\
mI0ESrzzZgEEAL271y6y9swKMrM9WDLN1b0mdw+392lXOpi1r1xyR9DocpNgFQgvWKN7cx4w\
d7nXCCv3AQV3R9gnHo0keB6jTCpofCUax8Gt86znZECyJpwBD8UUypRDws0zkMw/vjoe8JK2\
tEyxzrJahNtgQfyoWSx/SyGwNh8jpTr59HuozHPPABEBAAG0EExhdW5jaHBhZCBLdXBmZXKI\
tgQTAQIAIAUCSrzzZgIbAwYLCQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEBe1E3ApL2BmQAoD\
/2Szs2fp6WEcnQkxdX4awPJDyj5IljEbFhPD+KRM3VK9j76bfSDyOEc/sk8ErWqK3/VocqDf\
R3GtJucJcYW6wIFoaDJ/mTzHH2GIcHbK7CH/3PjCL7wlvMQGPOR4a1DcXRh5ItobL/pmKGGo\
D/r6CSKuBlF4zOVAwzFwAD+aaBZU\
=fULo\
-----END PGP PUBLIC KEY BLOCK-----]=],\
			},]]\
\
		codegear =\
		{\
			ppaRepo = \"ppa:codegear/release\",\
			listEntry = \"deb http://ppa.launchpad.net/codegear/release/ubuntu \"..distro:lower()..\" main\\ndeb-src http://ppa.launchpad.net/codegear/release/ubuntu \"..distro:lower()..\" main\",\
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----\
Version: SKS 1.0.10\
\
mI0ETp8G7QEEAL1tQSp/GNeGvnLfjv/5xGJzBMRbXe1upf6d6u7N2vrRPtzlsutQnik7Vb8x\
fPbuOQl26vokV3h6+27Lph0B0fQUqb7VwC37yh19cct99Wm4I2YDgOuWvmwUUbLEXrXuChV+\
Kwq5Y1Ia9HUXDSd+1Pj6uWO4/vxN3e5VpFUQipfPABEBAAG0GkxhdW5jaHBhZCBQUEEgZm9y\
IENvZGVHZWFyiLgEEwECACIFAk6fBu0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJ\
ELPd8HImZBuRU84EAIwZ/bh/y+dmbG3gNfnlUxIx3co0ztW0GJNjK3ppCKeWFwa2RMRSkFPl\
VUjsQMxhPSrz4lAfsFlFnr2UKBhyCpew/V0fJGGV2g8OwZpR50EwiaBowKpoTK6EDJGwLX6k\
FZNAsp3EmvwZr+hRfX+z2KbV01yxU5ITSx47tUB3orVc\
=g/kS\
-----END PGP PUBLIC KEY BLOCK-----]=],\
		},\
\
		codelite =\
		{\
			listEntry = \"deb http://repos.codelite.org/ubuntu/ \"..distro:lower()..\" universe\",\
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----\
Version: GnuPG v1.4.10 (GNU/Linux)\
\
mQENBEyFTVoBCACiQXR6FXSrsjmCVa1380zYQ+QEE0OWegO1TwBzjYLQ+CSN/e3H\
6XqBYdMEZo/eKTbUJxzUELkAQ/WrxSpJknxbr6PocQvCktyocMgK8cSpvvAgj2oh\
Pj0TN2DkeAemvEsnk9jRZIbRo6/ylX4LhnkztSaAQxHICT1iXX9Arf9XgIl/7XYa\
fDaNss3W+Ts/zIV0r9CgvBvBpJoePMrMyk9Ft+tM13b7r0oOQtmIfmIHUFYXk3ci\
TtE9LuqvQNCIN0iDq9EvdI9hKZ46yVCKSNU93CLGwrionyz/tNKPl8Py8VptAwfJ\
RUGccitpGLoruXpIloSyoFYSVNLqNa2QhQ7NABEBAAG0MERhdmlkIEhhcnQgKGNv\
ZGVsaXRlIGtleSkgPGRhdmlkQGNvZGVsaXRlLmNvLnVrPokBOAQTAQIAIgUCTIVN\
WgIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQaFbh2xrIJgnWagf9EoqF\
OBbY+BeEpZ3UzSDz39rMSUAHTPzt+FLmrnU/g5MCoX5rEW3MiDuWBK5mkvfQTkrq\
DRPNGZf/SQmqL5qjmt8uvX9e5oyOZAma1vZ1Aza+kni5XhmbNX3HkAznYAC9rnIP\
QVLKVUVfGr9xLwJwnCvQ9XbrAMCOSiG5l2PNP1v31CLYvEiCoTiIUyjok/GnSSoO\
fxxE6NDcWod4J3GjnOck+POPEIRjNs449kILt9zOJTDSTIeaO9cYknn8L4dLpfBl\
rYKkeksPq5Ha0/Jcd86qsUzAIqEoXJw07IARMsXBTgG4gR/C2P78x77pBOitRFNx\
KgGLozlAfSTMu3Xpi7kBDQRMhU1aAQgAusdK91OIJDwtoDmE+5Crqf0SZDQ4PijL\
l4INXt0GE0exBOQCpCbFnk8Ja4zF4S2485kSrqE9AzPl1D1LYj01UiiwJQ09EwX2\
5KKNCB/05IAGrRx10yb9ZiEe7PnsH/VlfwJapGZgyMwS8+6EmDffw23tHtX96ykr\
vkBVWQkrAnnB+Q+7gs/y3+M1OQXLRxGx6N67EiTvygmAE93kI4wc+9lRbK/Au7B1\
K9eWTLAhphFuFbNOgChdkv+zD57D1nclmNGG8EDwbxU4NjFdFUKUyKp0v+QB6OqM\
fBdH4M10EDNX7Cn5wx0xJbMfny/LV/yUzmlRkDu4bn7BIJGoHrEroQARAQABiQEf\
BBgBAgAJBQJMhU1aAhsMAAoJEGhW4dsayCYJcb8H/Ahp0JSqol1AiBIRxMQXNXh9\
hha4MdPWW3rTcIuBVJ6FjEJPTw/rE9dbUcxjxoCn0WgYy48AFyrBp/TM4Y9CuAh7\
AIyEtsxtuzEjf8keSpW6dsAhxpPrUXEDTUdNaDi/efNdHumZwl79mreFPIFiWlpg\
VAPtLxbsylPXxJamylkSJ8UKGnu6qqSmvIB8vyMvYBtRXAjDR3XQ1u2dsaYAsiXF\
Iftcemioz8bvdH/udEaUjsPyzm5JDqHafo08S2dEN+ZrJfIbw26HFl3LClYIxSdZ\
L+nMjs7YCYWeC5oZVW3pepqDcT5IejgZL94IHgV6BvHcwwsDiW8lAdgHmz5Vs9o=\
=g35i\
-----END PGP PUBLIC KEY BLOCK-----]=],\
		},\
\
		wxformbuilder =\
		{\
			ppaRepo = \"ppa:wxformbuilder/release\",\
			listEntry = \"deb http://ppa.launchpad.net/wxformbuilder/release/ubuntu \"..distro:lower()..\" main\\ndeb-src http://ppa.launchpad.net/wxformbuilder/release/ubuntu \"..distro:lower()..\" main\",\
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----\
Version: SKS 1.0.10\
\
mI0ESy/PmQEEAO5/zYxLgGiRReb0ZmJSnD+VAaDDOQNCeysCdz7R7h9wUe5ZZOSkvogpd7sy\
E/Y7SuxHZJQoh7j+nWP5AgFdIOiSV+LZMtdsL3pG77NJkBKPOS0eH87cIK9XNWyeoj8cb9El\
KEbsgp5/GFPM9PF378tCCymxnzjak71+UCf2kCk7ABEBAAG0EUxhdW5jaHBhZCBSZWxlYXNl\
iLYEEwECACAFAksvz5kCGwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAKCRDeRtnvVlJrw8D5\
BAC7tTGtqZ2YigkbyIv08BNi2kuYOe0geESXEs86JWpnzqRF3tvYaH1PPsmdHDj9BofaAc/3\
FqNHhZtWdnp7WmOMnOIXLRqtbUViZVoUdEN9PKqrjmmEIjWKkF+8Xt71vZ8bVvWH5+v7m/90\
TlBREjjfeQKun9Vo5LLM6ns/whDb5g==\
=S2Rj\
-----END PGP PUBLIC KEY BLOCK-----]=],\
		},\
\
		--[[virtualbox =\
		{\
			listEntry = \"deb http://download.virtualbox.org/virtualbox/debian \"..distro:lower()..\" contrib non-free\",\
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----\
Version: GnuPG v1.4.9 (GNU/Linux)\
\
mQGiBEvy0LARBACPBH1AUv6krDseyvbL63CWS9fw43iReZ+NmgmDp4/sPsYHLduQ\
rxKSqiK7fgFFE+fas/7DCaZXIQW6hnqeD3CgnX0w1+gYiyqEuPY1LQH9okBR5o92\
/s2FLm7oUN4RNGv6vWoNSH1ZiRHknL5D0pKSGTKU+pG6cBYWJytAuJZHfwCguS55\
aPZuXfhjaWsXG8TF6GH0K8ED/RY3KbirJ7rueK/7KL7ziwqn4CdhQSLOhbZ/R2E0\
bknJQDo+vWJciRRRpTe+AG59ctgDF7lEXpjvCms0atyKtE8hObNaMJ5p48l/sgFL\
LEujqiq4tByAn2hDOf0s7YrfruIY+HHkBSI9XbwH9nPlsQq8WNsTWTzPrw+ZlQ7v\
AEuuA/9cJ/4qYUOq1pg3i/GqH+2dbRHOFH6idXr5YrdB3cYW8jORagOcwdQHeV/0\
CaTZVMyMhTVjtIiUt+UR/96CHKxedg0giHwD61GidpUVBUYSaDhjOKE3jwf6/jo5\
714e4+ZfL3y1Q2N4HzfK/gEkvPZby/o8WX2N7vUcxfztQ8yq6bRJT3JhY2xlIENv\
cnBvcmF0aW9uIChWaXJ0dWFsQm94IGFyY2hpdmUgc2lnbmluZyBrZXkpIDxpbmZv\
QHZpcnR1YWxib3gub3JnPohgBBMRAgAgBQJL8tCwAhsDBgsJCAcDAgQVAggDBBYC\
AwECHgECF4AACgkQVEIqS5irUTmlvwCeIjsPZ0I9HhLmlS9dLjk397Y5rncAn3kB\
XUPRIWb83FMxRwqS85rTCZyouQINBEvy0LAQCAC/pkqDW6H99qQdyW8zvQL5xj6C\
UcvlTpL5VkaIRDVwRNbiFoWsVMv2jdhmlJEoh5N+aXYcAzLv0HaiZBSDmTO6fqMM\
uPRHyIioQQUFNW4hRI7sdMkYvd2oZcxnzRCLdzG+s42EmzxE4F29eT/FA7o/QBj2\
nDbomVqM9jCXKB5/jSJ0W3Uf7I8b7go0AawJT9vVARRMFjz4A7h6QfjeSO9sPHSC\
1Dx5Fmd3u4y08W+o6w2kxXRYT9wfMFuGl4MWVJ+f6KPyRhqRCEaa/mz7lXhQdfeG\
qW8psDHKmoNnpPEq5Rl4aDIJOppwYJhnDELv+k8JJ6R1JM9hJUWTG8zv9sLzAAMF\
CAC6pagGYEK8Dh+3SV6dXjBLNghmj5qnx6GoCXwCDTEFXeWUnszZrqM7PTKLyrfK\
ZjOhluydpQSGY7TqDBJJ6emLyNNJV92IQ21eN/h9i0wB97pu8jwvi7RjD0vSkDHh\
OpSr9vJm9EeESU1Z+mEKOjz2AONjRLplbBNt9kbXmSWpIP8XMFkU+1KTuNbfi+h4\
muOJWKkAGcT7bMUlqbZQjZ2O0RtwDjThxHvw8NhRkxPDYHVxE4uRRobhPquq4NsC\
QkMc7LlRilXZCS5mrabHw5+edullNWaQtGuKGlQXGfM4kEhGt7b/XIiyhI5bsh60\
o8Mz0KuFpClp9B7c78+QBzTbiEkEGBECAAkFAkvy0LACGwwACgkQVEIqS5irUTnq\
qACgtXuTbe2b72sgKdc6gGRKPhLDoEMAmgLwGVN3a4CqewQL+03bqfcKczNH\
=19g1\
-----END PGP PUBLIC KEY BLOCK-----]=]\
		},]]\
\
		chrome =\
		{\
			listEntry = \"deb https://dl.google.com/linux/chrome/deb/ stable main\",\
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----\
Version: GnuPG v1.4.2.2 (GNU/Linux)\
\
mQGiBEXwb0YRBADQva2NLpYXxgjNkbuP0LnPoEXruGmvi3XMIxjEUFuGNCP4Rj/a\
kv2E5VixBP1vcQFDRJ+p1puh8NU0XERlhpyZrVMzzS/RdWdyXf7E5S8oqNXsoD1z\
fvmI+i9b2EhHAA19Kgw7ifV8vMa4tkwslEmcTiwiw8lyUl28Wh4Et8SxzwCggDcA\
feGqtn3PP5YAdD0km4S4XeMEAJjlrqPoPv2Gf//tfznY2UyS9PUqFCPLHgFLe80u\
QhI2U5jt6jUKN4fHauvR6z3seSAsh1YyzyZCKxJFEKXCCqnrFSoh4WSJsbFNc4PN\
b0V0SqiTCkWADZyLT5wll8sWuQ5ylTf3z1ENoHf+G3um3/wk/+xmEHvj9HCTBEXP\
78X0A/0Tqlhc2RBnEf+AqxWvM8sk8LzJI/XGjwBvKfXe+l3rnSR2kEAvGzj5Sg0X\
4XmfTg4Jl8BNjWyvm2Wmjfet41LPmYJKsux3g0b8yzQxeOA4pQKKAU3Z4+rgzGmf\
HdwCG5MNT2A5XxD/eDd+L4fRx0HbFkIQoAi1J3YWQSiTk15fw7RMR29vZ2xlLCBJ\
bmMuIExpbnV4IFBhY2thZ2UgU2lnbmluZyBLZXkgPGxpbnV4LXBhY2thZ2VzLWtl\
eW1hc3RlckBnb29nbGUuY29tPohjBBMRAgAjAhsDBgsJCAcDAgQVAggDBBYCAwEC\
HgECF4AFAkYVdn8CGQEACgkQoECDD3+sWZHKSgCfdq3HtNYJLv+XZleb6HN4zOcF\
AJEAniSFbuv8V5FSHxeRimHx25671az+uQINBEXwb0sQCACuA8HT2nr+FM5y/kzI\
A51ZcC46KFtIDgjQJ31Q3OrkYP8LbxOpKMRIzvOZrsjOlFmDVqitiVc7qj3lYp6U\
rgNVaFv6Qu4bo2/ctjNHDDBdv6nufmusJUWq/9TwieepM/cwnXd+HMxu1XBKRVk9\
XyAZ9SvfcW4EtxVgysI+XlptKFa5JCqFM3qJllVohMmr7lMwO8+sxTWTXqxsptJo\
pZeKz+UBEEqPyw7CUIVYGC9ENEtIMFvAvPqnhj1GS96REMpry+5s9WKuLEaclWpd\
K3krttbDlY1NaeQUCRvBYZ8iAG9YSLHUHMTuI2oea07Rh4dtIAqPwAX8xn36JAYG\
2vgLAAMFB/wKqaycjWAZwIe98Yt0qHsdkpmIbarD9fGiA6kfkK/UxjL/k7tmS4Vm\
CljrrDZkPSQ/19mpdRcGXtb0NI9+nyM5trweTvtPw+HPkDiJlTaiCcx+izg79Fj9\
KcofuNb3lPdXZb9tzf5oDnmm/B+4vkeTuEZJ//IFty8cmvCpzvY+DAz1Vo9rA+Zn\
cpWY1n6z6oSS9AsyT/IFlWWBZZ17SpMHu+h4Bxy62+AbPHKGSujEGQhWq8ZRoJAT\
G0KSObnmZ7FwFWu1e9XFoUCt0bSjiJWTIyaObMrWu/LvJ3e9I87HseSJStfw6fki\
5og9qFEkMrIrBCp3QGuQWBq/rTdMuwNFiEkEGBECAAkFAkXwb0sCGwwACgkQoECD\
D3+sWZF/WACfeNAu1/1hwZtUo1bR+MWiCjpvHtwAnA1R3IHqFLQ2X3xJ40XPuAyY\
/FJG\
=Quqp\
-----END PGP PUBLIC KEY BLOCK-----]=]\
		},\
\
		oraclejava =\
		{\
			ppaRepo = \"ppa:webupd8team/java\",\
			listEntry = \"deb http://ppa.launchpad.net/webupd8team/java/ubuntu \"..distro:lower()..\" main\\ndeb-src http://ppa.launchpad.net/webupd8team/java/ubuntu \"..distro..\" main\",\
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----\
Version: SKS 1.1.4\
Comment: Hostname: keyserver.ubuntu.com\
\
mI0ES9/P3AEEAPbI+9BwCbJucuC78iUeOPKl/HjAXGV49FGat0PcwfDd69MVp6zUtIMbLgkU\
OxIlhiEkDmlYkwWVS8qy276hNg9YKZP37ut5+GPObuS6ZWLpwwNus5PhLvqeGawVJ/obu7d7\
gM8mBWTgvk0ErnZDaqaU2OZtHataxbdeW8qH/9FJABEBAAG0DUxhdW5jaHBhZCBWTEOItgQT\
AQIAIAUCS9/P3AIbAwYLCQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEMJRgkjuoUiG5wYEANCd\
jhXXEpPUbP7cRGXL6cFvrUFKpHHopSC9NIQ9qxJVlUK2NjkzCCFhTxPSHU8LHapKKvie3e+l\
kvWW5bbFN3IuQUKttsgBkQe2aNdGBC7dVRxKSAcx2fjqP/s32q1lRxdDRM6xlQlEA1j94ewG\
9SDVwGbdGcJ43gLxBmuKvUJ4\
=0Cp+\
-----END PGP PUBLIC KEY BLOCK-----]=],\
		},\
	}\
\
	local file = io.output( \"/etc/apt/sources.list.d/pkg-install-additional.list\" )\
	file:write( \"# This file was created by a script, don't edit this by hand.\\n# Any changes made will be lost.\\n\\n\" )\
\
	for ppa, value in pairs( aptDetails ) do\
		print( \">>\", \"Adding '\" .. ppa .. \"' PPA\" )\
		if value.ppaRepo ~= nil then\
			-- Add key using add-apt-repository.\
			os.execute( \"sudo add-apt-repository -y \" .. value.ppaRepo )\
		else\
			-- Write the comment to the file.\
			file:write( \"# \"..ppa..\" PPA\\n\" )\
			-- Write the list entry.\
			file:write( value.listEntry )\
			file:write( \"\\n\\n\" )\
\
			-- Write the key file to a file so apt-key can add it.\
			local keyFile = io.output( ppa..\".key\" )\
			keyFile:write( value.key )\
			keyFile:close()\
			-- Add key using apt-key.\
			os.execute( \"apt-key add \"..ppa..\".key\" )\
			os.remove( ppa..\".key\" )\
		end\
	end\
\
	file:close()\
\
	-- Cleans up partial list.\
	os.execute( \"sudo rm -rf /var/lib/apt/lists/partial/*\")\
end\
\
return function( options )\
	_M.options = options or { distributor_id = \"\" }\
	if options.distributor_id:lower() == \"ubuntu\" then\
		_M.versionSpecific	= require( \"ubuntu.\" .. options.codename )( options )\
		print( (\"Loaded sub-module %q\"):format( \"ubuntu.\" .. options.codename ) )\
	end\
\
	if options.desktop then\
		table.insert( _M.plugins, \"domain-setup\" )\
	end\
\
	return plugin.new( _M )\
end\
"
, '@'.."./plugins/ubuntu/init.lua" ) )

package.preload[ "plugins.lua-package-install" ] = assert( (loadstring or load)(
"local _M =\
{\
	name		= \"Lua\",\
	description	= \"Install Lua batteries\",\
	_VERSION	= \"1.0\",\
	packages	=\
	{\
	},\
	rocks =\
	{\
		{ \"busted\", version = \"1.11.1-1\" },		-- Version specified because the latest RC2 has a bug\
		\"copas\",\
		\"cosmo\",\
		\"coxpcall\",\
		\"ldoc\",\
		\"lpeg\",\
		\"lua-discount\",\
		\"luabitop\",\
		\"luacurl\",\
		{ \"luadbi-postgresql\", options = { PGSQL_INCDIR = \"/usr/include/postgresql\", POSTGRES_INCDIR = \"/usr/include/postgresql\" } },\
		\"luadbi-sqlite3\",\
		\"luaexpat\",\
		\"luafilesystem\",\
		\"luajson\",\
		{ \"lualogging\", version = \"1.2.0-1\" },	-- the current latest stable (1.3.0-1) seems to be corrupt, so i am pinning the version.\
		\"luaposix\",\
		{ \"luasec\", options = { OPENSSL_LIBDIR = \"/lib/x86_64-linux-gnu\" } },\
		\"luasocket\",\
		{ \"luasql-postgres\", options = { PGSQL_INCDIR = \"/usr/include/postgresql\", POSTGRES_INCDIR = \"/usr/include/postgresql\" } },\
		{ \"luasql-sqlite3\", version = \"cvs-1\", from = \"http://rocks.moonscript.org/dev\" },\
		\"luazip\",\
		{ \"lzlib\", options = { ZLIB_LIBDIR = \"/usr/lib/x86_64-linux-gnu\" } },\
		\"markdown\",\
		\"md5\",\
		\"orbit\",\
		\"penlight\",\
		\"rings\",\
		\"struct\",\
		{ \"wsapi-xavante\", version = \"cvs-1\", from = \"http://rocks.moonscript.org/dev\" },\
		--\"lunary\",\
	},\
	PreInstall	= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PreInstall() called...\" ) end\
		os.execute( \"wget http://luarocks.org/releases/luarocks-2.2.0.tar.gz\" )\
		os.execute( \"tar zxpf luarocks-2.2.0.tar.gz\" )\
		os.execute( \"cd luarocks-2.2.0; ./configure; sudo make bootstrap\" )\
	end,\
	Install		= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"Install() called...\" ) end\
		-- Update LuaRocks\
		os.execute( \"luarocks --from=http://rocks.moonscript.org install luarocks\" )\
		--os.execute( \"apt-get remove -y luarocks\" )	-- Seems to break the updated installation, so leaving it\
\
		-- Install rocks one at a time because LuaRocks doen't support lists\
		for _, rock in pairs( self.rocks ) do\
			local cmd = (\"luarocks %s install %s\")\
			if \"table\" == type( rock ) then\
				local options = {}\
				options[1 + #options] = \"--from=\" .. ( rock.from or \"http://rocks.moonscript.org\" )\
				if rock.options then\
					for name, value in pairs( rock.options ) do\
						options[1 + #options] = (\"%s=%s\"):format( name, value )\
					end\
				end\
				print( (\"[%s] %s\"):format( rock[1], string.rep( \"-\", 20 ) ) )\
				--print( cmd:format( table.concat( options, \" \" ), (\"%s %s\"):format( rock[1], rock.version or \"\"  ) ) )\
				os.execute( cmd:format( table.concat( options, \" \" ), (\"%s %s\"):format( rock[1], rock.version or \"\"  ) ) )\
			else\
				print( (\"[%s] %s\"):format( rock, string.rep( \"-\", 20 ) ) )\
				os.execute( cmd:format( \"--from=http://rocks.moonscript.org\", rock ) )\
			end\
		end\
	end,\
	PostInstall = function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PostInstall() called...\" ) end\
	end\
}\
\
return function( options )\
	return _M\
end\
"
, '@'.."./plugins/lua-package-install.lua" ) )

package.preload[ "plugins.ubuntu.trusty" ] = assert( (loadstring or load)(
"local _M =\
{\
	name		= \"14.04\",\
	description	= \"Specific details for installing Ubnutu 14.04 (Trusty)\",\
	_VERSION	= \"1.0\",\
	packages	=\
	{\
		-- General\
		-- Development\
		-- Libraries\
	},\
	desktopPackages =\
	{\
		-- General\
		-- Development\
		-- Libraries\
	},\
	PreInstall	= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PreInstall() called...\" ) end\
	end,\
	Install		= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"Install() called...\" ) end\
	end,\
	PostInstall = function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PostInstall() called...\" ) end\
	end\
}\
\
return function( options )\
	if options and options.desktop then\
\
	end\
\
	return _M\
end\
"
, '@'.."./plugins/ubuntu/trusty.lua" ) )

package.preload[ "plugins.init" ] = assert( (loadstring or load)(
"-- ----------------------------------------------------------------------------\
--	pkg-install plugin definition\
--	Author:	R. Pusztai <rjpcomputing@gmail.com>\
--	Date:	03/09/2015\
-- ----------------------------------------------------------------------------\
local Plugins =\
{\
	-- Add plugin names here\
	plugins	= { \"deb-core\", \"lua-package-install\", \"ubuntu\", \"debian\" },\
	loadedPlugins = {},\
}\
\
function Plugins:Add( pluginName, options )\
	assert( \"string\"	== type( pluginName ), \"Invalid pluginName. Expected string, but found \" .. type( pluginName ) )\
	local plugin = require( pluginName )\
	assert( \"function\"	== type( plugin ), \"Error loading plugin. Expected function to be returned, but found \" .. type( plugin ) )\
	-- Initialize the plugin passing in details about the current run\
	plugin = plugin( options )\
	assert( \"string\"	== type( plugin.name ), \"Invalid plugin.name. Expected string, but found \" .. type( plugin.name ) )\
	assert( \"string\"	== type( plugin._VERSION ), \"Invalid plugin._VERSION. Expected string, but found \" .. type( plugin._VERSION ) )\
	self.loadedPlugins[pluginName] = plugin\
\
	return plugin\
end\
\
function Plugins:Load( options )\
	print( (\"Loading %i plugins...\"):format( #self.plugins ) )\
	for _, plugin in ipairs( self.plugins ) do\
		self:Add( plugin, options )\
		print( (\"Loaded %q...\"):format( plugin ) )\
	end\
\
	return self.loadedPlugins\
end\
\
return Plugins\
"
, '@'.."./plugins/init.lua" ) )

package.preload[ "argparse" ] = assert( (loadstring or load)(
"local Parser, Command, Argument, Option\
\
-- Create classes with setters\
do\
   local function deep_update(t1, t2)\
      for k, v in pairs(t2) do\
         if type(v) == \"table\" then\
            v = deep_update({}, v)\
         end\
\
         t1[k] = v\
      end\
\
      return t1\
   end\
\
   local class_metatable = {}\
\
   function class_metatable.__call(cls, ...)\
      return setmetatable(deep_update({}, cls.__proto), cls)(...)\
   end\
\
   function class_metatable.__index(cls, key)\
      return cls.__parent and cls.__parent[key]\
   end\
\
   local function class(proto)\
      local cls = setmetatable({__proto = proto, __parent = {}}, class_metatable)\
      cls.__index = cls\
      return cls\
   end\
\
   local function extend(cls, proto)\
      local new_cls = class(deep_update(deep_update({}, cls.__proto), proto))\
      new_cls.__parent = cls\
      return new_cls\
   end\
\
   local function add_setters(cl, fields)\
      for field, setter in pairs(fields) do\
         cl[field] = function(self, value)\
            setter(self, value)\
            self[\"_\"..field] = value\
            return self\
         end\
      end\
\
      cl.__call = function(self, ...)\
         local name_or_options\
\
         for i=1, select(\"#\", ...) do\
            name_or_options = select(i, ...)\
\
            if type(name_or_options) == \"string\" then\
               if self._aliases then\
                  table.insert(self._aliases, name_or_options)\
               end\
\
               if not self._aliases or not self._name then\
                  self._name = name_or_options\
               end\
            elseif type(name_or_options) == \"table\" then\
               for field in pairs(fields) do\
                  if name_or_options[field] ~= nil then\
                     self[field](self, name_or_options[field])\
                  end\
               end\
            end\
         end\
\
         return self\
      end\
\
      return cl\
   end\
\
   local typecheck = setmetatable({}, {\
      __index = function(self, type_)\
         local typechecker_factory = function(field)\
            return function(_, value)\
               if type(value) ~= type_ then\
                  error((\"bad field '%s' (%s expected, got %s)\"):format(field, type_, type(value)))\
               end\
            end\
         end\
\
         self[type_] = typechecker_factory\
         return typechecker_factory\
      end\
   })\
\
   local function aliased_name(self, name)\
      typecheck.string \"name\" (self, name)\
\
      table.insert(self._aliases, name)\
   end\
\
   local function aliased_aliases(self, aliases)\
      typecheck.table \"aliases\" (self, aliases)\
\
      if not self._name then\
         self._name = aliases[1]\
      end\
   end\
\
   local function parse_boundaries(boundaries)\
      if tonumber(boundaries) then\
         return tonumber(boundaries), tonumber(boundaries)\
      end\
\
      if boundaries == \"*\" then\
         return 0, math.huge\
      end\
\
      if boundaries == \"+\" then\
         return 1, math.huge\
      end\
\
      if boundaries == \"?\" then\
         return 0, 1\
      end\
\
      if boundaries:match \"^%d+%-%d+$\" then\
         local min, max = boundaries:match \"^(%d+)%-(%d+)$\"\
         return tonumber(min), tonumber(max)\
      end\
\
      if boundaries:match \"^%d+%+$\" then\
         local min = boundaries:match \"^(%d+)%+$\"\
         return tonumber(min), math.huge\
      end\
   end\
\
   local function boundaries(field)\
      return function(self, value)\
         local min, max = parse_boundaries(value)\
\
         if not min then\
            error((\"bad field '%s'\"):format(field))\
         end\
\
         self[\"_min\"..field], self[\"_max\"..field] = min, max\
      end\
   end\
\
   local function convert(_, value)\
      if type(value) ~= \"function\" then\
         if type(value) ~= \"table\" then\
            error((\"bad field 'convert' (function or table expected, got %s)\"):format(type(value)))\
         end\
      end\
   end\
\
   local function argname(_, value)\
      if type(value) ~= \"string\" then\
         if type(value) ~= \"table\" then\
            error((\"bad field 'argname' (string or table expected, got %s)\"):format(type(value)))\
         end\
      end\
   end\
\
   local function add_help(self, param)\
      if self._has_help then\
         table.remove(self._options)\
         self._has_help = false\
      end\
\
      if param then\
         local help = self:flag()\
            :description \"Show this help message and exit. \"\
            :action(function()\
               io.stdout:write(self:get_help() .. \"\\r\\n\")\
               os.exit(0)\
            end)(param)\
\
         if not help._name then\
            help \"-h\" \"--help\"\
         end\
\
         self._has_help = true\
      end\
   end\
\
   Parser = add_setters(class {\
      _arguments = {},\
      _options = {},\
      _commands = {},\
      _mutexes = {},\
      _require_command = true\
   }, {\
      name = typecheck.string \"name\",\
      description = typecheck.string \"description\",\
      epilog = typecheck.string \"epilog\",\
      require_command = typecheck.boolean \"require_command\",\
      usage = typecheck.string \"usage\",\
      help = typecheck.string \"help\",\
      add_help = add_help\
   })\
\
   Command = add_setters(extend(Parser, {\
      _aliases = {}\
   }), {\
      name = aliased_name,\
      aliases = aliased_aliases,\
      description = typecheck.string \"description\",\
      epilog = typecheck.string \"epilog\",\
      target = typecheck.string \"target\",\
      require_command = typecheck.boolean \"require_command\",\
      action = typecheck[\"function\"] \"action\",\
      usage = typecheck.string \"usage\",\
      help = typecheck.string \"help\",\
      add_help = add_help\
   })\
\
   Argument = add_setters(class {\
      _minargs = 1,\
      _maxargs = 1,\
      _mincount = 1,\
      _maxcount = 1,\
      _defmode = \"unused\",\
      _show_default = true\
   }, {\
      name = typecheck.string \"name\",\
      description = typecheck.string \"description\",\
      target = typecheck.string \"target\",\
      args = boundaries \"args\",\
      default = typecheck.string \"default\",\
      defmode = typecheck.string \"defmode\",\
      convert = convert,\
      argname = argname,\
      show_default = typecheck.boolean \"show_default\"\
   })\
\
   Option = add_setters(extend(Argument, {\
      _aliases = {},\
      _mincount = 0,\
      _overwrite = true\
   }), {\
      name = aliased_name,\
      aliases = aliased_aliases,\
      description = typecheck.string \"description\",\
      target = typecheck.string \"target\",\
      args = boundaries \"args\",\
      count = boundaries \"count\",\
      default = typecheck.string \"default\",\
      defmode = typecheck.string \"defmode\",\
      convert = convert,\
      overwrite = typecheck.boolean \"overwrite\",\
      action = typecheck[\"function\"] \"action\",\
      argname = argname,\
      show_default = typecheck.boolean \"show_default\"\
   })\
end\
\
function Argument:_get_argument_list()\
   local buf = {}\
   local i = 1\
\
   while i <= math.min(self._minargs, 3) do\
      local argname = self:_get_argname(i)\
\
      if self._default and self._defmode:find \"a\" then\
         argname = \"[\" .. argname .. \"]\"\
      end\
\
      table.insert(buf, argname)\
      i = i+1\
   end\
\
   while i <= math.min(self._maxargs, 3) do\
      table.insert(buf, \"[\" .. self:_get_argname(i) .. \"]\")\
      i = i+1\
\
      if self._maxargs == math.huge then\
         break\
      end\
   end\
\
   if i < self._maxargs then\
      table.insert(buf, \"...\")\
   end\
\
   return buf\
end\
\
function Argument:_get_usage()\
   local usage = table.concat(self:_get_argument_list(), \" \")\
\
   if self._default and self._defmode:find \"u\" then\
      if self._maxargs > 1 or (self._minargs == 1 and not self._defmode:find \"a\") then\
         usage = \"[\" .. usage .. \"]\"\
      end\
   end\
\
   return usage\
end\
\
function Argument:_get_type()\
   if self._maxcount == 1 then\
      if self._maxargs == 0 then\
         return \"flag\"\
      elseif self._maxargs == 1 and (self._minargs == 1 or self._mincount == 1) then\
         return \"arg\"\
      else\
         return \"multiarg\"\
      end\
   else\
      if self._maxargs == 0 then\
         return \"counter\"\
      elseif self._maxargs == 1 and self._minargs == 1 then\
         return \"multicount\"\
      else\
         return \"twodimensional\"\
      end\
   end\
end\
\
-- Returns placeholder for `narg`-th argument. \
function Argument:_get_argname(narg)\
   local argname = self._argname or self:_get_default_argname()\
\
   if type(argname) == \"table\" then\
      return argname[narg]\
   else\
      return argname\
   end\
end\
\
function Argument:_get_default_argname()\
   return \"<\" .. self._name .. \">\"\
end\
\
function Option:_get_default_argname()\
   return \"<\" .. self:_get_default_target() .. \">\"\
end\
\
-- Returns label to be shown in the help message. \
function Argument:_get_label()\
   return self._name\
end\
\
function Option:_get_label()\
   local variants = {}\
   local argument_list = self:_get_argument_list()\
   table.insert(argument_list, 1, nil)\
\
   for _, alias in ipairs(self._aliases) do\
      argument_list[1] = alias\
      table.insert(variants, table.concat(argument_list, \" \"))\
   end\
\
   return table.concat(variants, \", \")\
end\
\
function Command:_get_label()\
   return table.concat(self._aliases, \", \")\
end\
\
function Argument:_get_description()\
   if self._default and self._show_default then\
      if self._description then\
         return (\"%s (default: %s)\"):format(self._description, self._default)\
      else\
         return (\"default: %s\"):format(self._default)\
      end\
   else\
      return self._description or \"\"\
   end\
end\
\
function Command:_get_description()\
   return self._description or \"\"\
end\
\
function Option:_get_usage()\
   local usage = self:_get_argument_list()\
   table.insert(usage, 1, self._name)\
   usage = table.concat(usage, \" \")\
\
   if self._mincount == 0 or self._default then\
      usage = \"[\" .. usage .. \"]\"\
   end\
\
   return usage\
end\
\
function Option:_get_default_target()\
   local res\
\
   for _, alias in ipairs(self._aliases) do\
      if alias:sub(1, 1) == alias:sub(2, 2) then\
         res = alias:sub(3)\
         break\
      end\
   end\
\
   res = res or self._name:sub(2)\
   return (res:gsub(\"-\", \"_\"))\
end\
\
function Option:_is_vararg()\
   return self._maxargs ~= self._minargs\
end\
\
function Parser:_get_fullname()\
   local parent = self._parent\
   local buf = {self._name}\
\
   while parent do\
      table.insert(buf, 1, parent._name)\
      parent = parent._parent\
   end\
\
   return table.concat(buf, \" \")\
end\
\
function Parser:_update_charset(charset)\
   charset = charset or {}\
\
   for _, command in ipairs(self._commands) do\
      command:_update_charset(charset)\
   end\
\
   for _, option in ipairs(self._options) do\
      for _, alias in ipairs(option._aliases) do\
         charset[alias:sub(1, 1)] = true\
      end\
   end\
\
   return charset\
end\
\
function Parser:argument(...)\
   local argument = Argument(...)\
   table.insert(self._arguments, argument)\
   return argument\
end\
\
function Parser:option(...)\
   local option = Option(...)\
\
   if self._has_help then\
      table.insert(self._options, #self._options, option)\
   else\
      table.insert(self._options, option)\
   end\
\
   return option\
end\
\
function Parser:flag(...)\
   return self:option():args(0)(...)\
end\
\
function Parser:command(...)\
   local command = Command():add_help(true)(...)\
   command._parent = self\
   table.insert(self._commands, command)\
   return command\
end\
\
function Parser:mutex(...)\
   local options = {...}\
\
   for i, option in ipairs(options) do\
      assert(getmetatable(option) == Option, (\"bad argument #%d to 'mutex' (Option expected)\"):format(i))\
   end\
\
   table.insert(self._mutexes, options)\
   return self\
end\
\
local max_usage_width = 70\
local usage_welcome = \"Usage: \"\
\
function Parser:get_usage()\
   if self._usage then\
      return self._usage\
   end\
\
   local lines = {usage_welcome .. self:_get_fullname()}\
\
   local function add(s)\
      if #lines[#lines]+1+#s <= max_usage_width then\
         lines[#lines] = lines[#lines] .. \" \" .. s\
      else\
         lines[#lines+1] = (\" \"):rep(#usage_welcome) .. s\
      end\
   end\
\
   -- This can definitely be refactored into something cleaner\
   local mutex_options = {}\
   local vararg_mutexes = {}\
\
   -- First, put mutexes which do not contain vararg options and remember those which do\
   for _, mutex in ipairs(self._mutexes) do\
      local buf = {}\
      local is_vararg = false\
\
      for _, option in ipairs(mutex) do\
         if option:_is_vararg() then\
            is_vararg = true\
         end\
\
         table.insert(buf, option:_get_usage())\
         mutex_options[option] = true\
      end\
\
      local repr = \"(\" .. table.concat(buf, \" | \") .. \")\"\
\
      if is_vararg then\
         table.insert(vararg_mutexes, repr)\
      else\
         add(repr)\
      end\
   end\
\
   -- Second, put regular options\
   for _, option in ipairs(self._options) do\
      if not mutex_options[option] and not option:_is_vararg() then\
         add(option:_get_usage())\
      end\
   end\
\
   -- Put positional arguments\
   for _, argument in ipairs(self._arguments) do\
      add(argument:_get_usage())\
   end\
\
   -- Put mutexes containing vararg options\
   for _, mutex_repr in ipairs(vararg_mutexes) do\
      add(mutex_repr)\
   end\
\
   for _, option in ipairs(self._options) do\
      if not mutex_options[option] and option:_is_vararg() then\
         add(option:_get_usage())\
      end\
   end\
\
   if #self._commands > 0 then\
      if self._require_command then\
         add(\"<command>\")\
      else\
         add(\"[<command>]\")\
      end\
\
      add(\"...\")\
   end\
\
   return table.concat(lines, \"\\r\\n\")\
end\
\
local margin_len = 3\
local margin_len2 = 25\
local margin = (\" \"):rep(margin_len)\
local margin2 = (\" \"):rep(margin_len2)\
\
local function make_two_columns(s1, s2)\
   if s2 == \"\" then\
      return margin .. s1\
   end\
\
   s2 = s2:gsub(\"[\\r\\n][\\r\\n]?\", function(sub)\
      if #sub == 1 or sub == \"\\r\\n\" then\
         return \"\\r\\n\" .. margin2\
      else\
         return \"\\r\\n\\r\\n\" .. margin2\
      end\
   end)\
\
   if #s1 < (margin_len2-margin_len) then\
      return margin .. s1 .. (\" \"):rep(margin_len2-margin_len-#s1) .. s2\
   else\
      return margin .. s1 .. \"\\r\\n\" .. margin2 .. s2\
   end\
end\
\
function Parser:get_help()\
   if self._help then\
      return self._help\
   end\
\
   local blocks = {self:get_usage()}\
   \
   if self._description then\
      table.insert(blocks, self._description)\
   end\
\
   local labels = {\"Arguments: \", \"Options: \", \"Commands: \"}\
\
   for i, elements in ipairs{self._arguments, self._options, self._commands} do\
      if #elements > 0 then\
         local buf = {labels[i]}\
\
         for _, element in ipairs(elements) do\
            table.insert(buf, make_two_columns(element:_get_label(), element:_get_description()))\
         end\
\
         table.insert(blocks, table.concat(buf, \"\\r\\n\"))\
      end\
   end\
\
   if self._epilog then\
      table.insert(blocks, self._epilog)\
   end\
\
   return table.concat(blocks, \"\\r\\n\\r\\n\")\
end\
\
local function get_tip(context, wrong_name)\
   local context_pool = {}\
   local possible_name\
   local possible_names = {}\
\
   for name in pairs(context) do\
      for i=1, #name do\
         possible_name = name:sub(1, i-1) .. name:sub(i+1)\
\
         if not context_pool[possible_name] then\
            context_pool[possible_name] = {}\
         end\
\
         table.insert(context_pool[possible_name], name)\
      end\
   end\
\
   for i=1, #wrong_name+1 do\
      possible_name = wrong_name:sub(1, i-1) .. wrong_name:sub(i+1)\
\
      if context[possible_name] then\
         possible_names[possible_name] = true\
      elseif context_pool[possible_name] then\
         for _, name in ipairs(context_pool[possible_name]) do\
            possible_names[name] = true\
         end\
      end\
   end\
\
   local first = next(possible_names)\
   if first then\
      if next(possible_names, first) then\
         local possible_names_arr = {}\
\
         for name in pairs(possible_names) do\
            table.insert(possible_names_arr, \"'\" .. name .. \"'\")\
         end\
\
         table.sort(possible_names_arr)\
         return \"\\r\\nDid you mean one of these: \" .. table.concat(possible_names_arr, \" \") .. \"?\"\
      else\
         return \"\\r\\nDid you mean '\" .. first .. \"'?\"\
      end\
   else\
      return \"\"\
   end\
end\
\
local function plural(x)\
   if x == 1 then\
      return \"\"\
   end\
\
   return \"s\"\
end\
\
-- Compatibility with strict.lua and other checkers:\
local default_cmdline = rawget(_G, \"arg\") or {}\
\
function Parser:_parse(args, errhandler)\
   args = args or default_cmdline\
   local parser\
   local charset\
   local options = {}\
   local arguments = {}\
   local commands\
   local option_mutexes = {}\
   local used_mutexes = {}\
   local opt_context = {}\
   local com_context\
   local result = {}\
   local invocations = {}\
   local passed = {}\
   local cur_option\
   local cur_arg_i = 1\
   local cur_arg\
   local targets = {}\
\
   local function error_(fmt, ...)\
      return errhandler(parser, fmt:format(...))\
   end\
\
   local function assert_(assertion, ...)\
      return assertion or error_(...)\
   end\
\
   local function convert(element, data)\
      if element._convert then\
         local ok, err\
\
         if type(element._convert) == \"function\" then\
            ok, err = element._convert(data)\
         else\
            ok = element._convert[data]\
         end\
\
         assert_(ok ~= nil, \"%s\", err or \"malformed argument '\" .. data .. \"'\")\
         data = ok\
      end\
\
      return data\
   end\
\
   local invoke, pass, close\
\
   function invoke(element)\
      local overwrite = false\
\
      if invocations[element] == element._maxcount then\
         if element._overwrite then\
            overwrite = true\
         else\
            error_(\"option '%s' must be used at most %d time%s\", element._name, element._maxcount, plural(element._maxcount))\
         end\
      else\
         invocations[element] = invocations[element]+1\
      end\
\
      passed[element] = 0\
      local type_ = element:_get_type()\
      local target = targets[element]\
\
      if type_ == \"flag\" then\
         result[target] = true\
      elseif type_ == \"multiarg\" then\
         result[target] = {}\
      elseif type_ == \"counter\" then\
         if not overwrite then\
            result[target] = result[target]+1\
         end\
      elseif type_ == \"multicount\" then\
         if overwrite then\
            table.remove(result[target], 1)\
         end\
      elseif type_ == \"twodimensional\" then\
         table.insert(result[target], {})\
\
         if overwrite then\
            table.remove(result[target], 1)\
         end\
      end\
\
      if element._maxargs == 0 then\
         close(element)\
      end\
   end\
\
   function pass(element, data)\
      passed[element] = passed[element]+1\
      data = convert(element, data)\
      local type_ = element:_get_type()\
      local target = targets[element]\
\
      if type_ == \"arg\" then\
         result[target] = data\
      elseif type_ == \"multiarg\" or type_ == \"multicount\" then\
         table.insert(result[target], data)\
      elseif type_ == \"twodimensional\" then\
         table.insert(result[target][#result[target]], data)\
      end\
\
      if passed[element] == element._maxargs then\
         close(element)\
      end\
   end\
\
   local function complete_invocation(element)\
      while passed[element] < element._minargs do\
         pass(element, element._default)\
      end\
   end\
\
   function close(element)\
      if passed[element] < element._minargs then\
         if element._default and element._defmode:find \"a\" then\
            complete_invocation(element)\
         else\
            error_(\"too few arguments\")\
         end\
      else\
         if element == cur_option then\
            cur_option = nil\
         elseif element == cur_arg then\
            cur_arg_i = cur_arg_i+1\
            cur_arg = arguments[cur_arg_i]\
         end\
      end\
   end\
\
   local function switch(p)\
      parser = p\
\
      for _, option in ipairs(parser._options) do\
         table.insert(options, option)\
\
         for _, alias in ipairs(option._aliases) do\
            opt_context[alias] = option\
         end\
\
         local type_ = option:_get_type()\
         targets[option] = option._target or option:_get_default_target()\
\
         if type_ == \"counter\" then\
            result[targets[option]] = 0\
         elseif type_ == \"multicount\" or type_ == \"twodimensional\" then\
            result[targets[option]] = {}\
         end\
\
         invocations[option] = 0\
      end\
\
      for _, mutex in ipairs(parser._mutexes) do\
         for _, option in ipairs(mutex) do\
            if not option_mutexes[option] then\
               option_mutexes[option] = {mutex}\
            else\
               table.insert(option_mutexes[option], mutex)\
            end\
         end\
      end\
\
      for _, argument in ipairs(parser._arguments) do\
         table.insert(arguments, argument)\
         invocations[argument] = 0\
         targets[argument] = argument._target or argument._name\
         invoke(argument)\
      end\
\
      cur_arg = arguments[cur_arg_i]\
      commands = parser._commands\
      com_context = {}\
\
      for _, command in ipairs(commands) do\
         targets[command] = command._target or command._name\
\
         for _, alias in ipairs(command._aliases) do\
            com_context[alias] = command\
         end\
      end\
   end\
\
   local function get_option(name)\
      return assert_(opt_context[name], \"unknown option '%s'%s\", name, get_tip(opt_context, name))\
   end\
\
   local function do_action(element)\
      if element._action then\
         element._action()\
      end\
   end\
\
   local function handle_argument(data)\
      if cur_option then\
         pass(cur_option, data)\
      elseif cur_arg then\
         pass(cur_arg, data)\
      else\
         local com = com_context[data]\
\
         if not com then\
            if #commands > 0 then\
               error_(\"unknown command '%s'%s\", data, get_tip(com_context, data))\
            else\
               error_(\"too many arguments\")\
            end\
         else\
            result[targets[com]] = true\
            do_action(com)\
            switch(com)\
         end\
      end\
   end\
\
   local function handle_option(data)\
      if cur_option then\
         close(cur_option)\
      end\
\
      cur_option = opt_context[data]\
\
      if option_mutexes[cur_option] then\
         for _, mutex in ipairs(option_mutexes[cur_option]) do\
            if used_mutexes[mutex] and used_mutexes[mutex] ~= cur_option then\
               error_(\"option '%s' can not be used together with option '%s'\", data, used_mutexes[mutex]._name)\
            else\
               used_mutexes[mutex] = cur_option\
            end\
         end\
      end\
\
      do_action(cur_option)\
      invoke(cur_option)\
   end\
\
   local function mainloop()\
      local handle_options = true\
\
      for _, data in ipairs(args) do\
         local plain = true\
         local first, name, option\
\
         if handle_options then\
            first = data:sub(1, 1)\
            if charset[first] then\
               if #data > 1 then\
                  plain = false\
                  if data:sub(2, 2) == first then\
                     if #data == 2 then\
                        if cur_option then\
                           close(cur_option)\
                        end\
\
                        handle_options = false\
                     else\
                        local equal = data:find \"=\"\
                        if equal then\
                           name = data:sub(1, equal-1)\
                           option = get_option(name)\
                           assert_(option._maxargs > 0, \"option '%s' does not take arguments\", name)\
\
                           handle_option(data:sub(1, equal-1))\
                           handle_argument(data:sub(equal+1))\
                        else\
                           get_option(data)\
                           handle_option(data)\
                        end\
                     end\
                  else\
                     for i = 2, #data do\
                        name = first .. data:sub(i, i)\
                        option = get_option(name)\
                        handle_option(name)\
\
                        if i ~= #data and option._minargs > 0 then\
                           handle_argument(data:sub(i+1))\
                           break\
                        end\
                     end\
                  end\
               end\
            end\
         end\
\
         if plain then\
            handle_argument(data)\
         end\
      end\
   end\
\
   switch(self)\
   charset = parser:_update_charset()\
   mainloop()\
\
   if cur_option then\
      close(cur_option)\
   end\
\
   while cur_arg do\
      if passed[cur_arg] == 0 and cur_arg._default and cur_arg._defmode:find \"u\" then\
         complete_invocation(cur_arg)\
      else\
         close(cur_arg)\
      end\
   end\
\
   if parser._require_command and #commands > 0 then\
      error_(\"a command is required\")\
   end\
\
   for _, option in ipairs(options) do\
      if invocations[option] == 0 then\
         if option._default and option._defmode:find \"u\" then\
            invoke(option)\
            complete_invocation(option)\
            close(option)\
         end\
      end\
\
      if invocations[option] < option._mincount then\
         if option._default and option._defmode:find \"a\" then\
            while invocations[option] < option._mincount do\
               invoke(option)\
               close(option)\
            end\
         else\
            error_(\"option '%s' must be used at least %d time%s\", option._name, option._mincount, plural(option._mincount))\
         end\
      end\
   end\
\
   return result\
end\
\
function Parser:error(msg)\
   io.stderr:write((\"%s\\r\\n\\r\\nError: %s\\r\\n\"):format(self:get_usage(), msg))\
   os.exit(1)\
end\
\
function Parser:parse(args)\
   return self:_parse(args, Parser.error)\
end\
\
function Parser:pparse(args)\
   local errmsg\
   local ok, result = pcall(function()\
      return self:_parse(args, function(_, err)\
         errmsg = err\
         return error()\
      end)\
   end)\
\
   if ok then\
      return true, result\
   else\
      assert(errmsg, result)\
      return false, errmsg\
   end\
end\
\
return function(...)\
   return Parser(default_cmdline[0]):add_help(true)(...)\
end\
"
, '@'.."./argparse.lua" ) )

package.preload[ "plugins.deb-core" ] = assert( (loadstring or load)(
"local plugin = require( \"plugins.interface\" )\
\
local _M =\
{\
	name		= \"Debian Core\",\
	description	= \"Packages installed on all Debian based systems\",\
	_VERSION	= \"1.0\",\
	packages =\
	{\
		--\
		-- General --\
		--\
		\"aptitude\",\
		\"gdebi-core\",\
		\"joe\",\
		\"htop\",\
		\"p7zip-full\",\
		\"p7zip-rar\",\
		\"zip\",\
		\"unzip\",\
		\"samba\",\
		\"cifs-utils\",\
		\"smbnetfs\",\
		\"ssh\",\
		\"sshpass\",\
		\"dos2unix\",\
		\"openjdk-8-jdk\",\
		\"curl\",\
		\"sqlite3\",\
		--\
		-- Development --\
		--\
		\"build-essential\",\
		\"gdb\",\
		\"clang\",\
		\"linux-source\",\
		\"linux-headers-generic\",\
		\"automake\",\
		\"checkinstall\",\
		\"patchutils\",\
		\"autotools-dev\",\
		\"quilt\",\
		\"fakeroot\",\
		\"xutils\",\
		\"lintian\",\
		\"dput\",\
		\"dh-make\",\
		\"devscripts\",\
		\"libtool\",\
		\"autoconf\",\
		\"subversion\",\
		\"git\",\
		\"git-svn\",\
		\"premake4\",\
		\"valgrind\",\
		\"debhelper\",\
		\"rake\",\
		\"doxygen\",\
		\"graphviz\",\
		\"exuberant-ctags\",\
		--\
		-- Libraries --\
		--\
		\"libwxgtk3.0-*\",\
		\"libwxgtk-media3.0*\",\
		\"wx3.0-headers\",\
		\"wx-common\",\
		\"libqt4-dev\",\
		\"libqt4-dbg\",\
		\"qt4-dev-tools\",\
		\"libgtk2.0-dev\",\
		\"libgtk2.0-0-dbg\",\
		\"libboost-all-dev\",\
		\"libboost-dbg\",\
		\"liblua5.1-0-dev\",\
		\"liblua5.1-0-dbg\",\
		\"libsvn-dev\",\
		\"libserf-dev\",\
		\"libpq-dev\",\
		\"libsqlite3-dev\",\
		\"libncurses5-dev\",\
		\"libcurl4-openssl-dev\",\
		\"libzzip-dev\",\
		\"zlib1g-dev\",\
		\"libbz2-dev\",\
	},\
	desktopPackages =\
	{\
		--\
		-- General --\
		--\
		\"alacarte\",\
		\"synaptic\",\
		\"google-chrome-stable\",\
		\"geany\",\
		\"pinta\",\
		\"gimp\",\
		\"kupfer\",\
		\"guake\",\
		\"pidgin\",\
		\"nautilus-open-terminal\",\
		\"virtualbox\",\
		\"virtualbox-dkms\",\
		\"dkms\",\
		\"unetbootin\",\
		\"synergy\",\
		--\"icedtea-plugin\",\
		--\
		-- Development --\
		--\
		\"codelite\",\
		\"meld\",\
		\"diffuse\",\
		\"ghex\",\
		--\
		-- Libraries --\
		--\
	},\
	PreInstall	= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PreInstall() called...\" ) end\
		-- Update apt.\
		print( \">>\", \"Updating APT...\" )\
		os.execute( \"apt-get update\" )\
\
		-- Upgrade all packages\
		print( \">>\", \"Upgrading packages...\" )\
		os.execute( \"apt-get -y dist-upgrade\" )\
\
		if options.desktop then\
			-- Make sure Google Chrome does not add Googles repo during the install, because this script does it already.\
			os.execute( \"touch /etc/default/google-chrome\" )\
		end\
	end,\
	Install		= function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"Install() called...\" ) end\
	end,\
	PostInstall = function( self, options )\
		if options.debug then print( \"[DEBUG]\", self.name, \"PostInstall() called...\" ) end\
		if options.desktop and not options.runningAsVm then\
			InstallVirtualBoxExtensionPack()\
		end\
\
		-- Upgrade all packages again. In case there was a failure during install.\
		print( \">>\", \"Finish with a full system package upgrate...\" )\
		os.execute( \"apt-get -y dist-upgrade\" )\
	end\
}\
\
local function InstallVirtualBoxExtensionPack()\
	-- VirtualBox 4.x Extension Pack (gives USB2.0 support)\
	local virtualBoxExtensionUrl = \"http://download.virtualbox.org/virtualbox/4.3.10/Oracle_VM_VirtualBox_Extension_Pack-4.3.10-93012.vbox-extpack\"\
	local virtualBoxExtensionFilename = virtualBoxExtensionUrl:gsub( \"\\\\\", \"/\" ):match( \"([^/]-[^%.]+)$\" )\
	os.execute( (\"wget --no-check-certificate --output-document=%s %s\"):format( virtualBoxExtensionFilename, virtualBoxExtensionUrl ) )\
	-- Install\
	os.execute( (\"VBoxManage extpack install %s\"):format( virtualBoxExtensionFilename ) )\
	-- Cleanup\
	os.remove( virtualBoxExtensionFilename )\
end\
\
return function( options )\
	if options and options.desktop then\
	end\
\
	return plugin.new( _M )\
end\
"
, '@'.."./plugins/deb-core.lua" ) )

package.preload[ "plugins.debian.init" ] = assert( (loadstring or load)(
"local plugin = require( \"plugins.interface\" )\
\
local _M =\
{\
	name			= \"Debian\",\
	distro			= \"Debian\",\
	description		= \"Packages installed on all Debian systems\",\
	_VERSION		= \"1.0-dev\",\
	plugins			= -- Plugins this uses\
	{\
		\"deb-core\",\
		\"lua-package-install\"\
	},\
	packages =\
	{\
	},\
	desktopPackages =\
	{\
		\"gnome-tweak-tool\",\
		\"rabbitvcs-nautilus\",\
		--\"chromium\",\
		--\"iceowl-extension\",\
	},\
	PreInstall	= function( self, options )\
		print( \"[DEBUG]\", self.name, \"PreInstall() called...\" )\
	end,\
	Install		= function( self, options )\
		print( \"[DEBUG]\", self.name, \"Install() called...\" )\
	end,\
	PostInstall = function( self, options )\
		print( \"[DEBUG]\", self.name, \"PostInstall() called...\" )\
	end\
}\
\
return function( options )\
	options = options or { distributor_id = \"\" }\
	if options.distributor_id:lower() == \"debian\" then\
		_M.versionSpecific	= require( \"debian.\" .. options.codename )\
		print( (\"Loaded sub-module %q\"):format( \"debian.\" .. options.codename ) )\
	end\
\
	if options.desktop then\
		table.insert( _M.plugins, \"domain-setup\" )\
	end\
\
	return plugin.new( _M )\
end\
"
, '@'.."./plugins/debian/init.lua" ) )

assert( (loadstring or load)(
"\
-- ----------------------------------------------------------------------------\
-- Script to get your machine up and running quickly after a fresh install.\
-- Author:	Ryan P. <rjpcomputing@gmail.com>\
-- Date:	04/15/2014\
-- Notes:	Built against Ubuntu 14.10 (Utopic Unicorn).\
--			Assumes root privileges.\
--\
-- Changes:\
--	11/10/2014 (14.10-01) - Initial Release with plugin support.\
-- ----------------------------------------------------------------------------\
-- require( \"pl\" )\
local argparse = require( \"argparse\" )\
\
-- Helper Functions -----------------------------------------------------------\
--\
local function FileExists( fileName )\
	local file = io.open( fileName )\
	if file then\
		io.close( file )\
		return true\
	else\
		return false\
	end\
end\
\
local function OperatingSystemDetails()\
	local lsbRelease = io.popen( \"lsb_release -idrc\" )\
	local releaseInfo = lsbRelease:read( \"*all\" )\
	lsbRelease:close()\
\
	-- parse info\
	local osDetails = {}\
	for k, v in string.gmatch( releaseInfo, \"([%w%s]+):%s(.-)%c\" ) do\
		osDetails[k:gsub(\" \", \"_\"):lower()] = v\
	end\
\
	return osDetails\
end\
\
local function IsRunningInVm()\
	os.execute( \"apt-get install -y virt-what\" )\
	local cmdOutput = io.popen( \"virt-what 2>&1\" ):read( \"*all\" )\
	local vmNames = { \"kvm\", \"parallels\", \"qemu\", \"virtualbox\", \"vmware\", \"xen\" }\
	for _, name in ipairs( vmNames ) do\
		if cmdOutput:find( name ) then\
			return true\
		end\
	end\
\
	return false\
end\
\
-- Utils Class ----------------------------------------------------------------\
--\
Utils = {}\
\
--- assert that the given argument is in fact of the correct type.\
-- @param n argument index\
-- @param val the value\
-- @param tp the type\
-- @param verify an optional verfication function\
-- @param msg an optional custom message\
-- @param lev optional stack position for trace, default 2\
-- @raise if the argument n is not the correct type\
-- @usage assert_arg(1,t,'table')\
-- @usage assert_arg(n,val,'string',path.isdir,'not a directory')\
function Utils.AssertArg(n,val,tp,verify,msg,lev)\
    if type(val) ~= tp then\
        error((\"argument %d expected a '%s', got a '%s'\"):format(n,tp,type(val)),lev or 2)\
    end\
    if verify and not verify(val) then\
        error((\"argument %d: '%s' %s\"):format(n,val,msg),lev or 2)\
    end\
end\
\
--- assert the common case that the argument is a string.\
-- @param n argument index\
-- @param val a value that must be a string\
-- @raise val must be a string\
function Utils.AssertString (n,val)\
    Utils.AssertArg(n,val,'string',nil,nil,3)\
end\
\
-- Copy a table into another in-place\
-- @returns first table with t2 contents\
function Utils.TableUpdate( t1, t2 )\
	Utils.AssertArg( 1,t1,'table' )\
	Utils.AssertArg( 2,t2,'table' )\
	for k, v in pairs( t1 ) do\
		t1[k] = v\
	end\
\
	return t1\
end\
\
--- insert values into a table.\
-- similar to table.insert but inserts values from given table values,\
-- not the object itself, into table t at position pos.\
-- @within Copying\
-- @array t the list\
-- @int[opt] position (default is at end)\
-- @array values\
function Utils.InsertValues(t, ...)\
    Utils.AssertArg(1,t,'table')\
    local pos, values\
    if select('#', ...) == 1 then\
        pos,values = #t+1, ...\
    else\
        pos,values = ...\
    end\
    if #values > 0 then\
        for i=#t,pos,-1 do\
            t[i+#values] = t[i]\
        end\
        local offset = 1 - pos\
        for i=pos,pos+#values-1 do\
            t[i] = values[i + offset]\
        end\
    end\
    return t\
end\
\
-- DebInit Class --------------------------------------------------------------\
--\
local PkgInstall =\
{\
	_NAME		= \"pkg-install\",\
	_VERSION	= \"2.0-dev\",\
--	args		= args,\
	hello		=\
[=[       __                                             __             ___    ___\
      /\\ \\                        __                 /\\ \\__         /\\_ \\  /\\_ \\\
 _____\\ \\ \\/'\\      __           /\\_\\    ___     ____\\ \\ ,_\\    __  \\//\\ \\ \\//\\ \\\
/\\ '__`\\ \\ , <    /'_ `\\  _______\\/\\ \\ /' _ `\\  /',__\\\\ \\ \\/  /'__`\\  \\ \\ \\  \\ \\ \\\
\\ \\ \\L\\ \\ \\ \\\\`\\ /\\ \\L\\ \\/\\______\\\\ \\ \\/\\ \\/\\ \\/\\__, `\\\\ \\ \\_/\\ \\L\\.\\_ \\_\\ \\_ \\_\\ \\_\
 \\ \\ ,__/\\ \\_\\ \\_\\ \\____ \\/______/ \\ \\_\\ \\_\\ \\_\\/\\____/ \\ \\__\\ \\__/.\\_\\/\\____\\/\\____\\\
  \\ \\ \\/  \\/_/\\/_/\\/___L\\ \\         \\/_/\\/_/\\/_/\\/___/   \\/__/\\/__/\\/_/\\/____/\\/____/\
   \\ \\_\\            /\\____/\
    \\/_/            \\_/__/\
]=]\
\
}\
PkgInstall.__index = PkgInstall\
function PkgInstall.new()\
	local self = setmetatable( {}, PkgInstall )\
\
	self.homeDir	= os.getenv( \"HOME\" )\
	-- Allow plugins to require other plugins\
	package.path	= package.path .. (\";%s/.pkg-install/plugins/?.lua;%s/.pkg-install/plugins/?/init.lua;./plugins/?.lua;./?.lua;./?/init.lua;./plugins/?/init.lua\"):format( self.homeDir, self.homeDir )\
	package.cpath	= package.cpath .. (\";%s/.pkg-install/plugins/?.so;./plugins/?.so;%s/.pkg-install/plugins/?.dll;./plugins/?.dll;%s/.pkg-install/plugins/?/init.so;./plugins/?/init.so;%s/.pkg-install/plugins/?/init.dll;./plugins/?/init.dll\"):format( self.homeDir, self.homeDir, self.homeDir, self.homeDir)\
    local parser = argparse()\
        :name( self._NAME )\
        :description( \"Script to get your machine up and running quickly after a fresh install.\" )\
	parser:flag \"-n\" \"--no-desktop\"\
	parser:flag \"-d\" \"--debug\"\
\
    local args = parser:parse()\
    for k, v in pairs(args) do print(k, v) end\
\
	self.operatingSystemDetails = OperatingSystemDetails()\
	self.operatingSystemDetails.runningAsVm = IsRunningInVm()\
	if args[\"no-desktop\"] then\
		self.operatingSystemDetails.desktop = false\
	else\
		self.operatingSystemDetails.desktop = true\
	end\
\
	return self\
end\
\
function main()\
	local app = PkgInstall.new()\
	print( app._NAME .. \" v\" .. app._VERSION .. \" - Script to get your machine up and running quickly after a fresh install.\" )\
	print( app.hello )\
\
	-- Check if script is being ran as root.\
	local username = os.getenv( \"USER\" )\
	if username ~= \"root\" then\
		error( \"Please run this as root. Use 'sudo' to run this as root\" )\
	end\
\
	local options = app.operatingSystemDetails\
	--print( pretty.write( options ) )\
	local Plugins = require( \"plugins\" )\
	local loadedPlugins = Plugins:Load( options )\
\
	-- Find plugins that focus on distros\
	local mainPlugin = {}\
	for pluginName, plugin in pairs( loadedPlugins ) do\
		if plugin.distro then\
			if options.distributor_id:lower() == plugin.distro:lower() then\
				mainPlugin = plugin\
\
				break\
			end\
		end\
	end\
\
	print( \">>\", (\"%s (%s) is being installed...\"):format( mainPlugin.distro, options.codename ) )\
	-- Pre-install Event\
	for _, pluginName in ipairs( mainPlugin.plugins ) do\
		local plugin = loadedPlugins[pluginName]\
		if plugin.PreInstall then plugin:PreInstall( options ) end\
	end\
	if mainPlugin.PreInstall then mainPlugin:PreInstall( options ) end\
\
	-- Install Event\
	for _, pluginName in ipairs( mainPlugin.plugins ) do\
		local plugin = loadedPlugins[pluginName]\
		if plugin.Install then plugin:Install( options ) end\
	end\
	if mainPlugin.Install then mainPlugin:Install( options ) end\
\
\
	-- Post-install Event\
	for _, pluginName in ipairs( mainPlugin.plugins ) do\
		local plugin = loadedPlugins[pluginName]\
		if plugin.PostInstall then plugin:PostInstall( options ) end\
	end\
	if mainPlugin.PostInstall then mainPlugin:PostInstall( options ) end\
\
	local success, domain = pcall( dofile, \"domain-setup.lua\" )\
	if success then\
		print( \">>\", \"Joining computer to domain...\" )\
		domain()\
	else\
		print( \">>\", \"No script for joining the domain found...\" )\
	end\
\
	print( \">>\", \"Finished installing packages...\" )\
end\
\
main()\
"
, '@'.."pkg-install.lua" ) )( ... )

