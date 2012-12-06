#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your machine up and running quickly after a fresh install.
-- Author:	Ryan Pusztai
-- Date:	06/09/2009
-- Notes:	Built against Ubuntu 9.04 (Jaunty).
--			Assumes root privileges.
-- ----------------------------------------------------------------------------

-- General Applications
local generalPackages =
{
	"joe",
	"htop",
	"gnome-do",
	"p7zip-full",
	"p7zip-rar",
	"nautilus-open-terminal",
	"nautilus-gksu",
	"python-setuptools",
	"python-wxgtk2.8",
	"ubuntu-restricted-extras",
	"virtualbox-3.0",
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
	"codelite",
	"meld",
	"wxformbuilder",
	"wxfb-wxadditions",
	"doxygen",
	"liblua5.1-bit0",
	"liblua5.1-copas0",
	"liblua5.1-cosmo0",
	"liblua5.1-coxpcall0",
	"liblua5.1-curl0",
	"liblua5.1-doc0",
	"liblua5.1-expat0",
	"liblua5.1-filesystem0",
	"liblua5.1-logging",
	"liblua5.1-lpeg1",
	"liblua5.1-markdown0",
	"liblua5.1-md5-0",
	"liblua5.1-orbit0",
	"liblua5.1-posix1",
	"liblua5.1-rings0",
	"liblua5.1-socket2",
	"liblua5.1-sql-mysql-2",
	"liblua5.1-sql-sqlite3-2",
	"liblua5.1-zip0",
}

local libraryPackages =
{
	"libwxgtk2.8-0",
	"libwxgtk2.8-dev",
	"libwxgtk2.8-dbg",
	"wx2.8-headers",
	"wx-common",
	"libwxadditions28",
	"libwxadditions28-dev",
	"libwxadditions28-dbg",
	"libboost1.37-dev",
	"libboost1.37-dbg",
	"liblua5.1-0-dev",
	"liblua5.1-0-dbg",
}

local aptDetails =
{
	gnomedo =
	{
		listEntry = "deb http://ppa.launchpad.net/do-core/ppa/ubuntu jaunty main\ndeb-src http://ppa.launchpad.net/do-core/ppa/ubuntu jaunty main",
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

	subversion =
	{
		listEntry = "deb http://ppa.launchpad.net/anders-kaseorg/subversion-1.6/ubuntu jaunty main\ndeb-src http://ppa.launchpad.net/anders-kaseorg/subversion-1.6/ubuntu jaunty main",
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
		listEntry = "deb http://ppa.launchpad.net/byobu/ppa/ubuntu jaunty main\ndeb-src http://ppa.launchpad.net/byobu/ppa/ubuntu jaunty main",
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

	listen =
	{
		listEntry = "deb http://ppa.launchpad.net/listen-devel/ppa/ubuntu jaunty main\ndeb-src http://ppa.launchpad.net/listen-devel/ppa/ubuntu jaunty main",
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
		listEntry = "deb http://ppa.launchpad.net/rjmyst3/ppa/ubuntu jaunty main\ndeb-src http://ppa.launchpad.net/rjmyst3/ppa/ubuntu jaunty main",
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

	virtualbox =
	{
		listEntry = "deb http://download.virtualbox.org/virtualbox/debian jaunty non-free",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.6 (GNU/Linux)

mQGiBEh7C8oRBACtOAieuw71PWaeBpi3djCX2sbZ3pqvfMsTaUb4E8Jo6ylC5xOa
rc4PUQt5/fHaFwOgP+MF11pt8LunY7nXgFNufmXWxAwjaB26EqAF9CytxJS7viu9
tjEFqWQIL+2GHE1sEAevr8EvVr7fnmCUuY06nb1WvaOlL1VO2DAs+aJ2fwCguhlZ
ozqrrFyhO7XjRX9imHXbIvsD/2ntslEsaYgnTaNAOCGVUZi4kUQKVZrELgYpLo0Z
Wq6fbAskgI5qFe4XgP0TqLoI4KLg5OaMXdWDhboaJ3Ln9JgQnjLS3fJG75Lu3QF/
6nPWYKcuQILLOcsXPthHDxyvRqTv5uUmiNRSDJSMLMA2LgUjzKJ7mEzDZ/uL8jZq
jfR2A/9r+H4wct/YS0Xmm2JWZxDlT+D27zF0zKzHVINr2eSK8K5mIhOZxAJN37ay
qVcegz23JII3MQKOuvuH7pBzGEY1IiT6gvAI7WjVm+pRU+TarVwytoANWOvTWfid
2Y/OgClJ4iqnhj/egM/c3A7KrGG4Q/Tj1rHqnB+rRilVoYQbaLRRU3VuIE1pY3Jv
c3lzdGVtcywgSW5jLiAoeFZNIFZpcnR1YWxCb3ggYXJjaGl2ZSBzaWduaW5nIGtl
eSkgPGluZm9AdmlydHVhbGJveC5vcmc+iGAEExECACAFAkh7C8oCGwMGCwkIBwMC
BBUCCAMEFgIDAQIeAQIXgAAKCRDc+fh7bfvLrnOHAJwLYTeiZC3HyO6758GKiMHZ
2VTO5gCfXb1PdW17wqGKz5nyka9qpjOAs2C5Ag0ESHsL0BAIAKVaUE5yk8vsXkbj
CPxrs2R7XuqrLp2/KSdjV7wi1dhwOgFUNObNMsK3K683mxmMnT65mJ/HqiXgW9WY
5PgLzrHnEA27O7v2ol3O86wkr5BHaaStsLpkDIMItywjPqZkp7KHFDRXrhGTiHLg
0D6YQB/+GRlxWZTAmB6F+ZGwQj3k9+q7kUd5Gj+LbmC6RA/7yrxgLgCRpdbilGQd
xV2mGanX2qoA0Fu1nVXDWw3lPU95za3iAXVle89YRNFRK2WxV0hIFhqA/DndR1Y8
M9fL4jDYXRtbDnUTkhfZiH9MiuDVSzcXN0cUApaovLlnvDaPB7iLTi8SmIMdO6YY
ME7JwCsAAwUIAISgj2zdQC4TilbTGifMMJ0m3dVbjaoApuTaQc+vulCIhr/rf1DN
V7gtLNd+CRx67xtyVKfxPWL5vBL9OBCWcCdYY2iCplXv8gUZmwRtTN/B0+Ce07Re
+bWUe/wBl7z6YBYQnmtOxK55OXEgzv3/wL7L8Mt3co8AeO1qy4kM66JFnq8Scw81
Axx4lcIPW1q17moygSwD/1YbEgFMQHs/8V8aqB9xIs5yOdsA4VWj32V7ymW2V+sx
4oKoiZiYuGZOjgGpZlQMxgUaORO0PPRSqnCmuV9zujmd28Fljdrb+WDvc/xDwiKg
nN/FKpMczPur8keOGpPSeUmZPaxkNmKbqGyISQQYEQIACQUCSHsL0AIbDAAKCRDc
+fh7bfvLronZAKCfiCvC2s61vA1x/YJ9QUPn4lCpjgCbB4dSVAHE/imWR02yFhqz
32NqKPU=
=FQ5T
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
	os.execute( "aptitude update" )

	-- Install all packages
	print( "Installing packages..." )
	local cmd = "aptitude -y install "..allPackages
	os.execute( cmd )

	print( "Finished installing packages..." )
end

main()
