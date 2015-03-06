#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your machine up and running quickly after a fresh install.
-- Author:	Ryan P. <rjpcomputing@gmail.com>
-- Date:	04/15/2014
-- Notes:	Built against Ubuntu 14.10 (Utopic Unicorn).
--			Assumes root privileges.
--
-- Changes:
--	11/10/2014 (14.10-01) - Initial Release with plugin support.
-- ----------------------------------------------------------------------------
-- require( "pl" )
local argparser = require( "argparse" )

-- Helper Functions -----------------------------------------------------------
--
local function FileExists( fileName )
	local file = io.open( fileName )
	if file then
		io.close( file )
		return true
	else
		return false
	end
end

local function OperatingSystemDetails()
	local lsbRelease = io.popen( "lsb_release -idrc" )
	local releaseInfo = lsbRelease:read( "*all" )
	lsbRelease:close()

	-- parse info
	local osDetails = {}
	for k, v in string.gmatch( releaseInfo, "([%w%s]+):%s(.-)%c" ) do
		osDetails[k:gsub(" ", "_"):lower()] = v
	end

	return osDetails
end

-- Utils Class ----------------------------------------------------------------
--
Utils = {}

--- assert that the given argument is in fact of the correct type.
-- @param n argument index
-- @param val the value
-- @param tp the type
-- @param verify an optional verfication function
-- @param msg an optional custom message
-- @param lev optional stack position for trace, default 2
-- @raise if the argument n is not the correct type
-- @usage assert_arg(1,t,'table')
-- @usage assert_arg(n,val,'string',path.isdir,'not a directory')
function Utils.AssertArg(n,val,tp,verify,msg,lev)
    if type(val) ~= tp then
        error(("argument %d expected a '%s', got a '%s'"):format(n,tp,type(val)),lev or 2)
    end
    if verify and not verify(val) then
        error(("argument %d: '%s' %s"):format(n,val,msg),lev or 2)
    end
end

--- assert the common case that the argument is a string.
-- @param n argument index
-- @param val a value that must be a string
-- @raise val must be a string
function Utils.AssertString (n,val)
    Utils.AssertArg(n,val,'string',nil,nil,3)
end

-- Copy a table into another in-place
-- @returns first table with t2 contents
function Utils.TableUpdate( t1, t2 )
	Utils.AssertArg( 1,t1,'table' )
	Utils.AssertArg( 2,t2,'table' )
	for k, v in pairs( t1 ) do
		t1[k] = v
	end

	return t1
end

--- insert values into a table.
-- similar to table.insert but inserts values from given table values,
-- not the object itself, into table t at position pos.
-- @within Copying
-- @array t the list
-- @int[opt] position (default is at end)
-- @array values
function Utils.InsertValues(t, ...)
    Utils.AssertArg(1,t,'table')
    local pos, values
    if select('#', ...) == 1 then
        pos,values = #t+1, ...
    else
        pos,values = ...
    end
    if #values > 0 then
        for i=#t,pos,-1 do
            t[i+#values] = t[i]
        end
        local offset = 1 - pos
        for i=pos,pos+#values-1 do
            t[i] = values[i + offset]
        end
    end
    return t
end

-- DebInit Class --------------------------------------------------------------
--
local PkgInstall =
{
	_NAME		= "pkg-install",
	_VERSION	= "2.0-dev",
	args		= args,
	hello		=
[=[       __                                             __             ___    ___
      /\ \                        __                 /\ \__         /\_ \  /\_ \
 _____\ \ \/'\      __           /\_\    ___     ____\ \ ,_\    __  \//\ \ \//\ \
/\ '__`\ \ , <    /'_ `\  _______\/\ \ /' _ `\  /',__\\ \ \/  /'__`\  \ \ \  \ \ \
\ \ \L\ \ \ \\`\ /\ \L\ \/\______\\ \ \/\ \/\ \/\__, `\\ \ \_/\ \L\.\_ \_\ \_ \_\ \_
 \ \ ,__/\ \_\ \_\ \____ \/______/ \ \_\ \_\ \_\/\____/ \ \__\ \__/.\_\/\____\/\____\
  \ \ \/  \/_/\/_/\/___L\ \         \/_/\/_/\/_/\/___/   \/__/\/__/\/_/\/____/\/____/
   \ \_\            /\____/
    \/_/            \_/__/
]=]

}
PkgInstall.__index = PkgInstall
function PkgInstall.new()
	local self = setmetatable( {}, PkgInstall )
	self.operatingSystemDetails = OperatingSystemDetails()
	print( pretty.write( self.operatingSystemDetails ) )

	self.homeDir	= os.getenv( "HOME" )
	-- Allow plugins to require other plugins
	package.path	= package.path .. (";%s/.pkg-install/plugins/?.lua;%s/.pkg-install/plugins/?/init.lua;./plugins/?.lua;./plugins/?/init.lua"):format( self.homeDir, self.homeDir )
	package.cpath	= package.cpath .. (";%s/.pkg-install/plugins/?.so;./plugins/?.so;%s/.pkg-install/plugins/?.dll;./plugins/?.dll;%s/.pkg-install/plugins/?/init.so;./plugins/?/init.so;%s/.pkg-install/plugins/?/init.dll;./plugins/?/init.dll"):format( self.homeDir, self.homeDir, self.homeDir, self.homeDir)
    local parser = argparse()
        :name( self._NAME )
        :description( "Script to get your machine up and running quickly after a fresh install." )

    local args = parser:parse()
    for k, v in pairs(args) do print(k, v) end

	return self
end

-- Returns the operating systems name in lowercase
function PkgInstall:GetOperatingSystemName()
	return "debian" == self.operatingSystemDetails.distributor_id:lower()
end

local appName = "pkg-install"
local appVer = "2.0-dev"

-- General Applications
local generalPackages =
{
	"aptitude",
	"synaptic",
	"gdebi",
	"alacarte",
	--"chromium-browser",
	"google-chrome-stable",
	"joe",
	"htop",
	--"syspeek",
	"geany",
	"pinta",
	"gimp",
	"kupfer",
	"guake",
	"p7zip-full",
	"p7zip-rar",
	"zip",
	"unzip",
	"dos2unix",
	"pidgin",
	"nautilus-open-terminal",
	"ubuntu-restricted-extras",
	"samba",
	"smbnetfs",
	"cifs-utils",
	"ssh",
	"sshpass",
	"virtualbox",
	"virtualbox-dkms",
	"dkms",
	"unetbootin",
	--"compizconfig-settings-manager",
	"unity-tweak-tool",
	"xul-ext-lightning",
	"synergy",
	--"fuse-exfat",
	--"exfat-utils",
	--"icedtea-plugin",
	"oracle-java8-installer",
	"oracle-java8-set-default",
	"curl",
	"sqlite3",
}

-- Development packages
local develPackages =
{
	"build-essential",
	"gdb",
	"clang",
	"linux-source",
	"linux-headers-generic",
	"automake",
	"checkinstall",
	"patchutils",
	"autotools-dev",
	"quilt",
	"fakeroot",
	"xutils",
	"lintian",
	"dput",
	"dh-make",
	"devscripts",
	"libtool",
	"autoconf",
	"subversion",
	"git",
	"git-svn",
	"svnwcrev",
	--"premake",
	"premake4",
	"valgrind",
	"debhelper",
	"rake",
	"codelite",
	"meld",
	"diffuse",
	"ghex",
	"wxformbuilder",
	"wxfb-wxadditions",
	"doxygen",
	"graphviz",
	"luarocks",
	"liblua5.1-sublua*",
	"rabbitvcs-nautilus3",
	"exuberant-ctags",
}

local libraryPackages =
{
	"libwxgtk3.0-*",
	"libwxgtk-media3.0*",
	"wx3.0-headers",
	"wx-common",
	"libwxadditions30*",
	"libqt4-dev",
	"libqt4-dbg",
	"qt4-dev-tools",
	"libgtk2.0-dev",
	"libgtk2.0-0-dbg",
	"libboost1.55-all-dev",
	"libboost1.55-dbg",
	"liblua5.1-0-dev",
	"liblua5.1-0-dbg",
	"libsvn-dev",
	--"libneon27-gnutls-dev",
	"libserf-dev",
	"libpq-dev",
	"libsqlite3-dev",
	"libncurses5-dev",
	"libcurl4-openssl-dev",
	"libzzip-dev",
	"zlib1g-dev",
	"libbz2-dev",
}

local rocks =
{
	{ "busted", version = "1.11.1-1" },		-- Version specified because the latest RC2 has a bug
	"copas",
	"cosmo",
	"coxpcall",
	"ldoc",
	"lpeg",
	"lua-discount",
	"luabitop",
	"luacurl",
	{ "luadbi-postgresql", options = { PGSQL_INCDIR = "/usr/include/postgresql", POSTGRES_INCDIR = "/usr/include/postgresql" } },
	"luadbi-sqlite3",
	"luaexpat",
	"luafilesystem",
	"luajson",
	{ "lualogging", version = "1.2.0-1" },	-- the current latest stable (1.3.0-1) seems to be corrupt, so i am pinning the version.
	"luaposix",
	{ "luasec", options = { OPENSSL_LIBDIR = "/lib/x86_64-linux-gnu" } },
	"luasocket",
	{ "luasql-postgres", options = { PGSQL_INCDIR = "/usr/include/postgresql", POSTGRES_INCDIR = "/usr/include/postgresql" } },
	{ "luasql-sqlite3", version = "cvs-1", from = "http://rocks.moonscript.org/dev" },
	"luazip",
	{ "lzlib", options = { ZLIB_LIBDIR = "/usr/lib/x86_64-linux-gnu" } },
	"markdown",
	"md5",
	"orbit",
	"penlight",
	"rings",
	"struct",
	{ "wsapi-xavante", version = "cvs-1", from = "http://rocks.moonscript.org/dev" },
	--"lunary",
}

local aptDetails =
{
	--[[["boost-latest"] =
	{
		ppaRepo = "ppa:boost-latest/ppa",
		listEntry = "deb http://ppa.launchpad.net/boost-latest/ppa/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/boost-latest/ppa/ubuntu "..distro:lower().." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0EStj7mgEEAKn3iB53wYRSSORMbMjrwYif14q2gG5eqHIyMargLVIRscIvKxFD9x6cedl0
DspGPG3dzhQLtP59cs537q+Sw4o4fkmtpYmjebFXfVCVo2/OW+jueoRd1FO6TzYncx7M7vf9
js/7cWJS+ajmNUEuPkBQ0KYKqBXmpd8wew/24Mg9ABEBAAG0FkxhdW5jaHBhZCBib29zdC1s
YXRlc3SItgQTAQIAIAUCStj7mgIbAwYLCQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEAz7hK4C
nbXH7jcD/AuyGCH5GFX2KSiYr5f9ok6sOQxu42MtwYkZ59rEdCU5x44n4jHPUZOevpidutPa
FPj1IVLHus1M/k44s3QjDnaJu/WH6E8KW15xLxXhh724s6lrHuNqmd9Mu8v5lAE27ttOSSrZ
hzXKImEEiTVJc40nhLfZXtQ0qBdGFqLPsRww
=qE4j
-----END PGP PUBLIC KEY BLOCK-----]=],
	},]]

	rabbitvcs =
	{
		ppaRepo = "ppa:rabbitvcs/ppa",
		listEntry = "deb http://ppa.launchpad.net/rabbitvcs/ppa/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/rabbitvcs/ppa/ubuntu "..distro:lower().." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ESsykEwEEAKq7U4qgEM0AhtarHcAqMxmKN8TUUwktQWu/JNxk+aNoqK9P5pY+aRYFzUCX
IVKVQg6KxC5TO4dapz4xvz8KvI0aKLtb6kpJhVKnydg000DA/bkEJbor/YBc4OfvdbjqPIbC
O2CL394ZvDGqpQbXoP0Auy9wKF1A3Kvd2g8LZa7VABEBAAG0E0xhdW5jaHBhZCBSYWJiaXRW
Q1OItgQTAQIAIAUCSsykEwIbAwYLCQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEC7leTY070o1
mW0D/RWsC9AFVjEoQYF9UOdu4sq3eY6uT/GUfIBJMmm10SI4/CzBLChoRg9ZkCDAdlfP6qab
bXQnWfI6BV0NwNbb4AQjImLvpXZikzx5NDbRXjML6/Qk9DkLfn6cZpKbr2gI41k1ar3LHCE2
APlN9ZheYInv1XLS4G+jDQjnMbd0VdzP
=P8E1
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	--[[kupfer =
		{
			ppaRepo = "ppa:kupfer-team/ppa",
			listEntry = "deb http://ppa.launchpad.net/kupfer-team/ppa/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/kupfer-team/ppa/ubuntu "..distro.." main",
			key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.1.4
Comment: Hostname: keyserver.ubuntu.com

mI0ESrzzZgEEAL271y6y9swKMrM9WDLN1b0mdw+392lXOpi1r1xyR9DocpNgFQgvWKN7cx4w
d7nXCCv3AQV3R9gnHo0keB6jTCpofCUax8Gt86znZECyJpwBD8UUypRDws0zkMw/vjoe8JK2
tEyxzrJahNtgQfyoWSx/SyGwNh8jpTr59HuozHPPABEBAAG0EExhdW5jaHBhZCBLdXBmZXKI
tgQTAQIAIAUCSrzzZgIbAwYLCQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEBe1E3ApL2BmQAoD
/2Szs2fp6WEcnQkxdX4awPJDyj5IljEbFhPD+KRM3VK9j76bfSDyOEc/sk8ErWqK3/VocqDf
R3GtJucJcYW6wIFoaDJ/mTzHH2GIcHbK7CH/3PjCL7wlvMQGPOR4a1DcXRh5ItobL/pmKGGo
D/r6CSKuBlF4zOVAwzFwAD+aaBZU
=fULo
-----END PGP PUBLIC KEY BLOCK-----]=],
		},]]

	codegear =
	{
		ppaRepo = "ppa:codegear/release",
		listEntry = "deb http://ppa.launchpad.net/codegear/release/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/codegear/release/ubuntu "..distro:lower().." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ETp8G7QEEAL1tQSp/GNeGvnLfjv/5xGJzBMRbXe1upf6d6u7N2vrRPtzlsutQnik7Vb8x
fPbuOQl26vokV3h6+27Lph0B0fQUqb7VwC37yh19cct99Wm4I2YDgOuWvmwUUbLEXrXuChV+
Kwq5Y1Ia9HUXDSd+1Pj6uWO4/vxN3e5VpFUQipfPABEBAAG0GkxhdW5jaHBhZCBQUEEgZm9y
IENvZGVHZWFyiLgEEwECACIFAk6fBu0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJ
ELPd8HImZBuRU84EAIwZ/bh/y+dmbG3gNfnlUxIx3co0ztW0GJNjK3ppCKeWFwa2RMRSkFPl
VUjsQMxhPSrz4lAfsFlFnr2UKBhyCpew/V0fJGGV2g8OwZpR50EwiaBowKpoTK6EDJGwLX6k
FZNAsp3EmvwZr+hRfX+z2KbV01yxU5ITSx47tUB3orVc
=g/kS
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	codelite =
	{
		listEntry = "deb http://repos.codelite.org/ubuntu/ "..distro:lower().." universe",
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

	wxformbuilder =
	{
		ppaRepo = "ppa:wxformbuilder/release",
		listEntry = "deb http://ppa.launchpad.net/wxformbuilder/release/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/wxformbuilder/release/ubuntu "..distro:lower().." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ESy/PmQEEAO5/zYxLgGiRReb0ZmJSnD+VAaDDOQNCeysCdz7R7h9wUe5ZZOSkvogpd7sy
E/Y7SuxHZJQoh7j+nWP5AgFdIOiSV+LZMtdsL3pG77NJkBKPOS0eH87cIK9XNWyeoj8cb9El
KEbsgp5/GFPM9PF378tCCymxnzjak71+UCf2kCk7ABEBAAG0EUxhdW5jaHBhZCBSZWxlYXNl
iLYEEwECACAFAksvz5kCGwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAKCRDeRtnvVlJrw8D5
BAC7tTGtqZ2YigkbyIv08BNi2kuYOe0geESXEs86JWpnzqRF3tvYaH1PPsmdHDj9BofaAc/3
FqNHhZtWdnp7WmOMnOIXLRqtbUViZVoUdEN9PKqrjmmEIjWKkF+8Xt71vZ8bVvWH5+v7m/90
TlBREjjfeQKun9Vo5LLM6ns/whDb5g==
=S2Rj
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	--[[virtualbox =
	{
		listEntry = "deb http://download.virtualbox.org/virtualbox/debian "..distro:lower().." contrib non-free",
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
		listEntry = "deb https://dl.google.com/linux/chrome/deb/ stable main",
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

	oraclejava =
	{
		ppaRepo = "ppa:webupd8team/java",
		listEntry = "deb http://ppa.launchpad.net/webupd8team/java/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/webupd8team/java/ubuntu "..distro.." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.1.4
Comment: Hostname: keyserver.ubuntu.com

mI0ES9/P3AEEAPbI+9BwCbJucuC78iUeOPKl/HjAXGV49FGat0PcwfDd69MVp6zUtIMbLgkU
OxIlhiEkDmlYkwWVS8qy276hNg9YKZP37ut5+GPObuS6ZWLpwwNus5PhLvqeGawVJ/obu7d7
gM8mBWTgvk0ErnZDaqaU2OZtHataxbdeW8qH/9FJABEBAAG0DUxhdW5jaHBhZCBWTEOItgQT
AQIAIAUCS9/P3AIbAwYLCQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEMJRgkjuoUiG5wYEANCd
jhXXEpPUbP7cRGXL6cFvrUFKpHHopSC9NIQ9qxJVlUK2NjkzCCFhTxPSHU8LHapKKvie3e+l
kvWW5bbFN3IuQUKttsgBkQe2aNdGBC7dVRxKSAcx2fjqP/s32q1lRxdDRM6xlQlEA1j94ewG
9SDVwGbdGcJ43gLxBmuKvUJ4
=0Cp+
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	--[[exfat =
	{
		ppaRepo = "ppa:relan/exfat",
		listEntry = "deb http://ppa.launchpad.net/relan/exfat/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/relan/exfat/ubuntu "..distro.." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ETDiLkAEEAMSaDcuqqD1s6bHbkNqr4tHTotoabGt1kxrPGKf5lhyGDF99CTJ9xkiPAfSp
ItX3gjI7LMyDwcRUpvxAfgDE/pSkYPkUp2fX+moMdiekdsvJOAZWw8UxXPh0TVLobIoDz/s7
7GDKUoe354QE0p6W9/VRxw5izLlR2XguBB879S15ABEBAAG0L0xhdW5jaHBhZCBGcmVlIGV4
RkFUIGZpbGUgc3lzdGVtIGltcGxlbWVudGF0aW9uiLYEEwECACAFAkw4i5ACGwMGCwkIBwMC
BBUCCAMEFgIDAQIeAQIXgAAKCRBN+bKMolKnhGTIA/9GmK3r2/w1Zm26FGvLTCl/9nMkS8Q8
F9rnugwEuBOfguGenVVARTH3asNl1uLTBUAMgwdHiLNGd9zR70JADgFZobH1oVkAQ0xvos50
vEFxcnTV6NPI4nrqt/SNQBEKNYRdznOeqMkVlC2W2HNa18L17QFBkzJxhdnNm/4YbUSweg==
=+jvj
-----END PGP PUBLIC KEY BLOCK-----]=],
	},]]
}

function AddExtraAptSources()
	local file = io.output( "/etc/apt/sources.list.d/pkg-install-additional.list" )
	file:write( "# This file was created by a script, don't edit this by hand.\n# Any changes made will be lost.\n\n" )

	for ppa, value in pairs( aptDetails ) do
		print( ">>", "Adding '" .. ppa .. "' PPA" )
		if value.ppaRepo ~= nil then
			-- Add key using add-apt-repository.
			os.execute( "sudo add-apt-repository -y " .. value.ppaRepo )
		else
			-- Write the comment to the file.
			file:write( "# "..ppa.." PPA\n" )
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

	-- Cleans up partial list. Seen for 14.10
	os.execute( "sudo rm -rf /var/lib/apt/lists/partial/*")
end

function InstallNonAptApplications()
	-- VirtualBox 4.x Extension Pack (gives USB2.0 support)
	local virtualBoxExtensionUrl = "http://download.virtualbox.org/virtualbox/4.3.10/Oracle_VM_VirtualBox_Extension_Pack-4.3.10-93012.vbox-extpack"
	local virtualBoxExtensionFilename = virtualBoxExtensionUrl:gsub( "\\", "/" ):match( "([^/]-[^%.]+)$" )
	os.execute( ("wget --no-check-certificate --output-document=%s %s"):format( virtualBoxExtensionFilename, virtualBoxExtensionUrl ) )
	-- Install
	os.execute( ("VBoxManage extpack install %s"):format( virtualBoxExtensionFilename ) )
	-- Cleanup
	os.remove( virtualBoxExtensionFilename )
end

local function IsRunningInVm()
	local cmdOutput = io.popen( "dmidecode  | grep -i product" ):read( "*all" )
	if cmdOutput:find( "VirtualBox" ) or cmdOutput:find( "VMWare" ) then
		return true
	else
		return false
	end
end

function main()
	print( appName .. " v" .. appVer .. " - Script to get your machine up and running quickly after a fresh install." )
	print( ">>", #generalPackages + #develPackages + #libraryPackages + 1 .. " packages to install" )

	-- Check if script is being ran as root.
	local username = os.getenv( "USER" )
	if username ~= "root" then
		error( "Please run this as root. Use 'sudo' to run this as root" )
	end

	AddManualUserLogin()

	if arg[1] ~= "--no-add-apt-sources" then
		-- Add the needed apt repository
		print( ">>", "Adding needed PPA's and keys to APT..." )
		AddExtraAptSources()
	end

	-- Update apt.
	print( ">>", "Updating APT..." )
	os.execute( "apt-get update" )
	-- Upgrade all packages
	print( ">>", "Upgrading packages..." )
	os.execute( "apt-get -y dist-upgrade" )



	-- Make sure Google Chrome does not add Googles repo during the install, because this script does it already.
	os.execute( "touch /etc/default/google-chrome" )

	-- Install all packages
	print( ">>", "Installing packages..." )
	local cmd = "apt-get -y install "..allPackages
	os.execute( cmd )

	print( ">>", "Installing packages that don't have any APT repository..." )
	InstallNonAptApplications()

	print( ">>", "Installing rocks..." )
	InstallRocks()

	-- Upgrade all packages again. In case there was a failure during install.
	print( ">>", "Finish with a full system package upgrate..." )
	os.execute( "apt-get -y dist-upgrade" )

	local success, domain = pcall( dofile, "domain-setup.lua" )
	if success then
		print( ">>", "Joining computer to domain..." )
		domain()
	else
		print( ">>", "No script for joining the domain found..." )
	end

	print( ">>", "Finished installing packages..." )
end

main()
