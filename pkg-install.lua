#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your machine up and running quickly after a fresh install.
-- Author:	Ryan Pusztai
-- Date:	11/03/2009
-- Notes:	Built against Ubuntu 9.10 (Karmic).
--			Assumes root privileges.
-- ----------------------------------------------------------------------------

-- General Applications
local generalPackages =
{
	"joe",
	"htop",
	"gnome-do",
	"guake",
	"p7zip-full",
	"p7zip-rar",
	"nautilus-open-terminal",
	"nautilus-gksu",
	"python-setuptools",
	"python-wxgtk2.8",
	"ubuntu-restricted-extras",
	"samba",
	"smbfs",
	"virtualbox-3.1",
	"dkms",
}

-- Development packages
local develPackages =
{
	"build-essential",
	"gdb",
	"subversion",
	"svnwcrev",
	"premake",
	"valgrind",
	"codelite",
--	"codelite-plugins",
	"meld",
	"wxformbuilder",
	"wxfb-wxadditions",
	"doxygen",
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
	"liblua5.1-zip*",
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
	"libboost1.40-all*",
	"libboost1.40-dbg",
	"liblua5.1-0-dev",
	"liblua5.1-0-dbg",
}

local distro = "karmic"
local aptDetails =
{
	gnomedo =
	{
		listEntry = "deb http://ppa.launchpad.net/do-core/ppa/ubuntu "..distro.." main\ndeb-src http://ppa.launchpad.net/do-core/ppa/ubuntu "..distro.." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ESXUVdQEEAN8ALfH3wueKsSgDwA/HVEHdB7nlppqGKW/tubvGTy0ayf4M9ylX45szZK97
uL9/UHh5/B7eGMSB45EMJ0/qvTiflS6SwCxRCoKCW1PpYZlVcOLh5UUBkyREPJZcki1lK7pf
xvG9LkYKnvBP89s2PnO5LlDheEsVR4SqDGEtich/ABEBAAG0JExhdW5jaHBhZCBQUEEgZm9y
IEdOT01FIERvIENvcmUgVGVhbYi2BBMBAgAgBQJJdRV1AhsDBgsJCAcDAgQVAggDBBYCAwEC
HgECF4AACgkQKKggUHdVjdCVeAP+ONJtMFx9MGSJe33YiskagXEG5cQGYdDi5sWWUAP80bP1
Qe+Dsnjs3VKQ9ZZW3M8UNXsoFFN501hgJFBwUUCWIRSGZkzVgKoZZtZOe0Dws39xfV//8JFS
Te/r0oPzrr10iTFupTe/wBR0M9JbKGdY7SvooyqU+W2rf8/LldGx7KE=
=3C2V
-----END PGP PUBLIC KEY BLOCK-----]=],
	},
--[[
	subversion =
	{
		listEntry = "deb http://ppa.launchpad.net/anders-kaseorg/subversion-1.6/ubuntu "..distro.." main\ndeb-src http://ppa.launchpad.net/anders-kaseorg/subversion-1.6/ubuntu "..distro.." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ESXak3QEEAKTdBfrFtEvBel4kluGh2d99v56PzgPB4gJKz5wET4sItbxZDU9hA61kt1hl
o/84l1696hWQvnVCXrXOI2g7ZW3RD/xs/HTG6gBcVjPAW7StXYQ6sLWNEu3mgZ4FA9RdEox2
38F0kqqozx187Tvq/OQBHVzPekcdQkaWPf8QkbJ3ABEBAAG0IExhdW5jaHBhZCBQUEEgZm9y
IEFuZGVycyBLYXNlb3JniEYEExECAAYFAkl3qLwACgkQG9iXoSX6XFaRLgCeLdHCeGYski0Q
YDIfiytgNzH5uFcAoIjEEHAXY9Z4N/nBDurP/Dzx/8M0iLYEEwECACAFAkl2pN0CGwMGCwkI
BwMCBBUCCAMEFgIDAQIeAQIXgAAKCRBimK00QTV2y8i7A/0XzwwjyTWdbcShItGhK4E3l/n0
Lq2JtCtJsjKphOOoE6pW3AjnrGayKZ5FNJoRVZYXNzIaeHhv6qlxdVTNiftUxIXJGOKRmCFJ
jYiltLTmJH+IGOCZAfMlT72AVKOLygEudLHF3KgdCX5/aW7sjCGtuvLJopL6zkcJpiJfoe2e
JA==
=ZaVk
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	byobu =
	{
		listEntry = "deb http://ppa.launchpad.net/byobu/ppa/ubuntu "..distro.." main\ndeb-src http://ppa.launchpad.net/byobu/ppa/ubuntu "..distro.." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ESY8IVwEEALW6ef/McyEoO3jvMURrYdaHp7obBOxWUjuZhM09bUUysfWyDY2VIPGMvuAX
jjnJkC9zGsKWqLhhmvcP2MpIpGb6RbdKINT9RkVNYPe09rGPfTcEYh4enFRLxUA+dcDkLR2h
JFB+ScFoCz4B0hslaZuRZXPVBQP9wizg7+hXzKuLABEBAAG0MkxhdW5jaHBhZCBQUEEgZm9y
IFVidW50dSBTY3JlZW4gUHJvZmlsZSBEZXZlbG9wZXJziLYEEwECACAFAkmPCFcCGwMGCwkI
BwMCBBUCCAMEFgIDAQIeAQIXgAAKCRDPXnSW9DC7pU7hA/4t2hD6udZZofQGmpURmrdHXyEg
D9lXpfDst4RmK2p9Hxo4eVF6Jjcgfw00WkdNb/69jG6AqHInfv+5ihH+JsErN0GZJBUsNe9E
OIOGiOh7ASpUW0+VB5gWqOZgqocQwJoGxZgXriu7NgnRIA9r5MJgnGsKS3EKK17LgiHvD1Bn
yw==
=1clR
-----END PGP PUBLIC KEY BLOCK-----]=],
	},
]]
	listen =
	{
		listEntry = "deb http://ppa.launchpad.net/listen-devel/ppa/ubuntu "..distro.." main\ndeb-src http://ppa.launchpad.net/listen-devel/ppa/ubuntu "..distro.." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ESgCWkAEEAL8zQTXu5ypL5IecmltNy3fOD/4QvPyo9gj4tJqwIz7f8BVC/UDso2k6AKkE
W/0td4OMf642H01jdArwMU8qRZ+hNdRnYRwdocXHf7OLMCf5emG/Q+Re9kVUmgsIOsoq24RF
t0uW1nKCRsXg2G4d5I45ZQPQAmghDUzS9Nb+yjKRABEBAAG0EExhdW5jaHBhZCBMaXN0ZW6I
tgQTAQIAIAUCSgCWkAIbAwYLCQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEO9Q0TyqgyiHfRkD
/iUJw0McasdvgEehk15zvRNpjOSQj242k/FZVDFjL1E4LlohTwEYVvYJPF/rtx8lXFXPVErU
EyIcAZdRDGA5772jivG1CA2VnnYKb2LhOn0tMFCKTAPL4PZoHdmVCoHG/5cLoJe2GnWFlULg
9A49tR6FLunD7GlYVCxF5JP+rmtQ
=GJTv
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	rjmyst3 =
	{
		listEntry = "deb http://ppa.launchpad.net/rjmyst3/ppa/ubuntu "..distro.." main\ndeb-src http://ppa.launchpad.net/rjmyst3/ppa/ubuntu "..distro.." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ESXVF7wEEALZ5fK89WdKlneHD+Wb68yRTCcKTyJKyunxNqjjeXeObz+oiwyqQ9TDyJG5j
fb3PsEZX6vNKQr5I0W5sFDrhFiNAvXYiQLW731lDOKOQuHjkiHtg63mZUt+/ZDU2lY4+yvmQ
XbCue1t8TyijeEAv9l38JJB4P5Gk7qD44OoB/I9FABEBAAG0HUxhdW5jaHBhZCBQUEEgZm9y
IFJ5YW4gTXVsZGVyiLYEEwECACAFAkl1Re8CGwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAK
CRBv0kXOWYrbBYJmA/44tUSekJHlwaEzUKY1tnx+n/BXDod1ZC9B7A9Th5/G59KOD3rWQFJ/
2vUcoX0o68OrbAGjwTupFz5oEXp4/g5gmKbSKK4G6HAZNpNIgm3+pZ0SS0uxgEBocAJMw1fh
2A3Psk0xstMJcHexfYmfdkrFtIiqlL/o5pGRUbbb/mt/Ag==
=34Ck
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	wxformbuilder =
	{
		ppaRepo = "ppa:wxformbuilder/release",
		listEntry = "deb http://ppa.launchpad.net/wxformbuilder/release/ubuntu "..distro.." main\ndeb-src http://ppa.launchpad.net/wxformbuilder/release/ubuntu "..distro.." main",
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

	virtualbox =
	{
		listEntry = "deb http://download.virtualbox.org/virtualbox/debian "..distro.." non-free",
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
	},
}

function AddExtraAptSources()
	local file = io.output( "/etc/apt/sources.list.d/pkg-install-additional.list" )
	file:write( "# This file was created by a script, don't edit this by hand.\n# Any changes made will be lost.\n\n" )

	for ppa, value in pairs( aptDetails ) do
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

	file:close()
end

function main()
	-- Check if script is being ran as root.
	local username = os.getenv( "USER" )
	if username ~= "root" then
		error( "Please run this as root. Use 'sudo' to run this as root" )
	end

	-- Add the needed apt repository
	print( "Adding needed PPA's and keys to APT..." )
	AddExtraAptSources()

	-- Build the packages into a string.
	local allPackages = table.concat( generalPackages, " " ).." "
	allPackages = allPackages..table.concat( develPackages, " " ).." "
	allPackages = allPackages..table.concat( libraryPackages, " " ).." "
	print( "Full list of packages to be installed..." )
	print( allPackages )

	-- Update apt.
	print( "Updating APT..." )
	os.execute( "apt-get update" )

	-- Install all packages
	print( "Installing packages..." )
	local cmd = "apt-get -y install "..allPackages
	os.execute( cmd )

	print( "Finished installing packages..." )
end

main()
