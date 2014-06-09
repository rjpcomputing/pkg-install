#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your server machine up and running quickly after a fresh install.
-- Author:	Ryan P. <rjpcomputing@gmail.com>
-- Date:	05/20/2014
-- Notes:	Built against Ubuntu 14.04 (Trusty Tahr).
--			Assumes root privileges.
--
-- Changes:
--	05/20/2014 (14.04-01) - Initial Release
--	05/30/2014 (14.04-02) - Replaced libneon with libserf for SVN support
--	06/05/2014 (14.04-03) - Added sqlite3 commandline tool.
--	                      - Changed over to using LuaRocks for all Lua Modules.
-- ----------------------------------------------------------------------------

-- General Setup
local distro = "Trusty"
local appName = "pkg-install-srv"
local appVer = "14.04-03"

---	Checks for the existance of a file.
--	@param fileName The file path and name as a string.
--	@return True if the file exists, else false.
local function FileExists( fileName )
	local file = io.open( fileName )
	if file then
		io.close( file )
		return true
	else
		return false
	end
end

-- General Applications
local generalPackages =
{
	"aptitude",
	"gdebi-core",
	"joe",
	"htop",
	"p7zip-full",
	"p7zip-rar",
	"zip",
	"unzip",
	"samba",
	"cifs-utils",
	"smbnetfs",
	"ssh",
	"sshpass",
	"dos2unix",
	"openjdk-7-jdk",
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
	"premake",
	"premake4",
	"valgrind",
	"debhelper",
	"rake",
	"doxygen",
	"graphviz",
	"luarocks",
	"lua-zip",
	"liblua5.1-sublua*",
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
}

local rocks =
{
	"busted",
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
	--{ "lualogging", from = "http://luarocks.org/repositories/rocks-cvs/" },
	"lualogging",
	"luaposix",
	{ "luasec", options = { OPENSSL_LIBDIR = "/lib/x86_64-linux-gnu" } },
	"luasocket",
	{ "luasql-postgres", options = { PGSQL_INCDIR = "/usr/include/postgresql", POSTGRES_INCDIR = "/usr/include/postgresql" } },
	{ "luasql-sqlite3", from = "http://luarocks.org/repositories/rocks-cvs/" },
	{ "lzlib", options = { ZLIB_LIBDIR = "/usr/lib/x86_64-linux-gnu" } },
	"markdown",
	"md5",
	"orbit",
	"penlight",
	"rings",
	"struct",
	{ "wsapi-xavante", from = "http://luarocks.org/repositories/rocks-cvs/" },
	--"lunary",
	--"luazip",
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
	
	--[[wxwidgets =
	{
		ppaRepo = "ppa:wxformbuilder/wxwidgets",
		listEntry = "deb http://ppa.launchpad.net/wxformbuilder/wxwidgets/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/wxformbuilder/wxwidgets/ubuntu "..distro:lower().." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.1.4
Comment: Hostname: keyserver.ubuntu.com

mI0ESy/PmQEEAO5/zYxLgGiRReb0ZmJSnD+VAaDDOQNCeysCdz7R7h9wUe5ZZOSkvogpd7sy
E/Y7SuxHZJQoh7j+nWP5AgFdIOiSV+LZMtdsL3pG77NJkBKPOS0eH87cIK9XNWyeoj8cb9El
KEbsgp5/GFPM9PF378tCCymxnzjak71+UCf2kCk7ABEBAAG0EUxhdW5jaHBhZCBSZWxlYXNl
iLYEEwECACAFAksvz5kCGwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAKCRDeRtnvVlJrw8D5
BAC7tTGtqZ2YigkbyIv08BNi2kuYOe0geESXEs86JWpnzqRF3tvYaH1PPsmdHDj9BofaAc/3
FqNHhZtWdnp7WmOMnOIXLRqtbUViZVoUdEN9PKqrjmmEIjWKkF+8Xt71vZ8bVvWH5+v7m/90
TlBREjjfeQKun9Vo5LLM6ns/whDb5g==
=S2Rj
-----END PGP PUBLIC KEY BLOCK-----]=],
	},]]
	
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
}

function AddExtraAptSources()
	-- Make sure that 'add-apt-repository' is on the machine
	os.execute( "sudo apt-get -y install software-properties-common" )

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
end

function InstallNonAptApplications()

end

local function ProcessCommand( cmd )
	-- Check to see if the command to run is a function
	if "function" == type( cmd ) then
		print( ">>", tostring( cmd ) )
		cmd()
	elseif "string" == type( cmd ) then
		print( ">>", cmd )
		os.execute( cmd )
	else
		error( "Invalid command type (" .. type( cmd ) .. "). Only string and function are valid." )
	end
end

local function InstallRocks()
	-- Update LuaRocks
	os.execute( "luarocks install luarocks" )
	--os.execute( "apt-get remove -y luarocks" )	-- Seems to break the updated installation, so leaving it
	
	-- Install rocks one at a time because LuaRocks doen't support lists
	for _, rock in pairs( rocks ) do
		local cmd = ("luarocks install %s")
		if "table" == type( rock ) then
			local options = {}
			if rock.from then options[1 + #options] = "--from=" .. rock.from end
			if rock.options then
				for name, value in pairs( rock.options ) do
					options[1 + #options] = ("%s=%s"):format( name, value )
				end
			end
			print( ("[%s] %s"):format( rock[1], string.rep( "-", 20 ) ) )
			os.execute( cmd:format( ("%s %s"):format( rock[1], table.concat( options, " " ) ) ) )
		else
			print( ("[%s] %s"):format( rock, string.rep( "-", 20 ) ) )
			os.execute( cmd:format( rock ) )
		end
	end
end

---	Tweak object
--	@class table
--	@name Tweaks
--	@field name {string} The name of the tweak
--	@field comment {string} A comment/short description of the tweak
--	@field command {table/string/function} If it is a table it can have values of either string or function. Each element in the table will be processed. If it is a string then os.execute() will be called on it. If it is a function it will call that function for you.

---	Processes the tweaks from the supplied .tweaks file
--	@param tweaks {table} Table of tweak objects. {name = "tweak name", comment = "Some comment", command = "cmd --to --execute"}
--		Command can be
local function ProcessTweaks( tweaks )
	for i = 1, #tweaks do
		print( ">", ("Tweak %q - %s"):format( tweaks[i].name, tweaks[i].comment ) )
		if "table" == type( tweaks[i].command ) then
			for j = 1, #tweaks[i].command do
				ProcessCommand( tweaks[i].command[j] )
			end
		else
			ProcessCommand( tweaks[i].command )
		end
	end
end

function main()
	-- Check if script is being ran as root.
	local username = os.getenv( "USER" )
	if username ~= "root" then
		error( "Please run this as root. Use 'sudo' to run this as root", 0 )
	end

	print( appName .. " v" .. appVer .. " - Quick setup of a fresh install." )
	print( ">>", #generalPackages + #develPackages + #libraryPackages + 1 .. " packages to install" )

	-- Load tweaks files, if specified
	local tweaksFilename = arg[1]
	print( tweaksFilename )
	local tweaks = nil
	if tweaksFilename then
		if FileExists( tweaksFilename ) then
			tweaks = dofile( tweaksFilename )
			-- Verify the tweaks file is valid
			if "table" == type( tweaks ) then
				print( ">>", ("Loaded %i tweaks from %q"):format( #tweaks, tweaksFilename ) )
			else
				error( ("Invalid .tweaks file loaded (%s). The file must return a table of tweak objects."):format( tweaksFilename ) )
			end
		end
	end

	-- Add the needed apt repository
	print( ">>", "Adding needed PPA's and keys to APT..." )
	AddExtraAptSources()

	-- Update apt.
	print( ">>", "Updating APT..." )
	os.execute( "apt-get update" )
	-- Upgrade all packages
	print( ">>", "Upgrading packages..." )
	os.execute( "apt-get -y dist-upgrade" )

	-- Build the packages into a string.
	local allPackages = table.concat( generalPackages, " " ).." "
	allPackages = allPackages..table.concat( develPackages, " " ).." "
	allPackages = allPackages..table.concat( libraryPackages, " " ).." "
	print( ">>", "Full list of packages to be installed..." )
	print( allPackages )

	-- Install all packages
	print( ">>", "Installing packages..." )
	local cmd = "apt-get -y install "..allPackages
	os.execute( cmd )

	print( ">>", "Installing packages that don't have any APT repository..." )
	InstallNonAptApplications()
	
	print( ">>", "Installing rocks..." )
	InstallRocks()

	if tweaks then
		print( ">>", "Processing tweaks..." )
		ProcessTweaks( tweaks )
	end

	print( ">>", "Finished installing packages..." )
end

main()
