#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your server machine up and running quickly after a fresh install.
-- Author:	Ryan Pusztai
-- Date:	05/16/2012
-- Notes:	Built against Ubuntu 12.04 (Precise).
--			Assumes root privileges.
--
-- Changes:
--	05/17/2012 (12.04-01) - Initial Release
--	11/13/2012 (12.04-02) - Added SubLua to the installed Lua modules
-- ----------------------------------------------------------------------------

-- General Setup
local distro = "Precise"
local appName = "pkg-install-srv"
local appVer = "12.04-02"

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
	"joe",
	"htop",
	"p7zip-full",
	"p7zip-rar",
	"zip",
	"unzip",
	"samba",
	"smbfs",
	"cifs-utils",
	"ssh",
}

-- Development packages
local develPackages =
{
	"build-essential",
	"gdb",
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
	"libtool",
	"autoconf",
	"subversion",
	"git-core",
	"git-svn",
	"svnwcrev",
	"premake",
	"premake4",
	"valgrind",
	"debhelper",
	"doxygen",
	"graphviz",
	"luarocks",
	"liblua5.1-bit*",
	"liblua5.1-copas*",
	"liblua5.1-cosmo*",
	"liblua5.1-coxpcall*",
	"liblua5.1-curl*",
	"liblua5.1-doc*",
	"liblua5.1-expat*",
	"liblua5.1-filesystem*",
	"liblua5.1-logging*",
	"liblua5.1-lpeg*",
	"liblua5.1-markdown*",
	"liblua5.1-md5-*",
	"liblua5.1-orbit*",
	"liblua5.1-posix*",
	"liblua5.1-rings*",
	"liblua5.1-socket*",
	"liblua5.1-sql-mysql-*",
	"liblua5.1-sql-sqlite3-*",
	"liblua5.1-sql-postgres-*",
	"liblua5.1-zip*",
	"liblua5.1-sublua*",
}

local libraryPackages =
{
	"libwxgtk2.8-*",
	--"libwxgtk2.8-dev",
	--"libwxgtk2.8-dbg",
	"wx2.8-headers",
	"wx-common",
	"libwxadditions28*",
	--"libwxadditions28-dev",
	--"libwxadditions28-dbg",
	"libqt4-dev",
	"libqt4-dbg",
	"qt4-dev-tools",
	"libgtk2.0-dev",
	"libgtk2.0-0-dbg",
	"libboost1.48-all-dev",
	"libboost1.48-dbg",
	"liblua5.1-0-dev",
	"liblua5.1-0-dbg",
	"libsvn-dev",
	"libneon27-gnutls-dev",
	"libpq-dev",
	"libmysqlclient-dev",
	"libsqlite3-dev",
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
	--[[ TODO: VMWare has not released a apt repo for Precies yet, so this is hard coded to oneiric
	vmware =
	{
		listEntry = "deb http://packages.vmware.com/tools/esx/4.1latest/ubuntu oneiric main restricted",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.7 (GNU/Linux)

mI0ESAP+VwEEAMZylR8dOijUPNn3He3GdgM/kOXEhn3uQl+sRMNJUDm1qebi2D5b
Qa7GNBIlXm3DEMAS+ZlkiFQ4WnhUq5awEXU7MGcWCEGfums5FckV2tysSfn7HeWd
9mkEnsY2CUZF54lyKfY0f+vdFd6QdYo6b+YxGnLyiunEYHXSEo1TNj1vABEBAAG0
QlZNd2FyZSwgSW5jLiAtLSBMaW51eCBQYWNrYWdpbmcgS2V5IC0tIDxsaW51eC1w
YWNrYWdlc0B2bXdhcmUuY29tPoi8BBMBAgAmBQJIA/5XAhsDBQkRcu4ZBgsJCAcD
AgQVAggDBBYCAwECHgECF4AACgkQwLXgq2b9SUkw0AP/UlmWQIjMNcYfTKCOOyFx
Csl3bY5OZ6HZs4qCRvzESVTyKs0YN1gX5YDDRmE5EbaqSO7OLriA7p81CYhstYID
GjVTBqH/zJz/DGKQUv0A7qGvnX4MDt/cvvgEXjGpeRx42le/mkPsHdwbG/8jKveY
S/eu0g9IenS49i0hcOnjShGIRgQQEQIABgUCSAQWfAAKCRD1ZoIQEyn810LTAJ9k
IOziCqa/awfBvlLq4eRgN/NnkwCeJLOuL6eAueYjaODTcFEGKUXlgM4=
=bXtp
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
end

function InstallNonAptApplications()
	-- Penlight Lua module
	local penlightFilename	= "penlight-latest.zip"
	os.execute( string.format( "wget --no-check-certificate --output-document=%s http://github.com/stevedonovan/Penlight/zipball/master", penlightFilename ) )
	-- Extract
	os.execute( string.format( "unzip -oj %s *lua/* -d pl", penlightFilename ) )
	-- Create directories if don't exist
	os.execute( "sudo mkdir -p /usr/share/lua/5.1/")
	-- Move to location
	os.execute( "sudo mv pl/ /usr/share/lua/5.1/")
	-- Cleanup
	os.remove( penlightFilename )
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

	-- Load tweaks file, if specified
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

	if tweaks then
		print( ">>", "Processing tweaks..." )
		ProcessTweaks( tweaks )
	end

	print( ">>", "Finished installing packages..." )
end

main()
