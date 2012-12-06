#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your machine up and running quickly after a fresh install.
-- Author:	Ryan Pusztai
-- Date:	03/17/2011
-- Notes:	Built against Ubuntu 10.10 (Maverick).
--			Assumes root privileges.
-- ----------------------------------------------------------------------------

-- General Setup
local distro = "Maverick"
local appName = "pkg-install"
local appVer = "10.10-11"

-- General Applications
local generalPackages =
{
	"aptitude",
	"avant-window-navigator-trunk",
	"chromium-browser",
	"joe",
	"htop",
	"geany",
	"gnome-do",
	"kupfer",
	"guake",
	"p7zip-full",
	"p7zip-rar",
	"zip",
	"unzip",
	"pidgin",
	"nautilus-open-terminal",
	"nautilus-gksu",
	--"python-setuptools",
	--"python-wxgtk2.8",
	"remmina",
	"remmina-gnome",
	"ubuntu-restricted-extras",
	"samba",
	--"smbfs",
	"cifs-utils",
	"ssh",
	"virtualbox-4.0",
--	"virtualbox-3.2",
	"dkms",
	"unetbootin",
	"ubuntu-tweak",
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
	"svnwcrev",
	"premake",
	"premake4",
	"valgrind",
	"debhelper",
	"codelite",
	--"codelite-plugins",
	"meld",
	"ghex",
	"wxformbuilder",
	"wxfb-wxadditions",
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
	"liblua5.1-zip*",
	"rabbitvcs-cli",
	"rabbitvcs-core",
	"rabbitvcs-nautilus",
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
	"libboost1.42-all*",
	"libboost1.42-dbg",
	"liblua5.1-0-dev",
	"liblua5.1-0-dbg",
	"libsvn-dev",
	"libneon27-dev"
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

	--[[gnomedo =
	{
		ppaRepo = "ppa:do-core/ppa",
		listEntry = "deb http://ppa.launchpad.net/do-core/ppa/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/do-core/ppa/ubuntu "..distro:lower().." main",
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
	},]]

	["chromium-daily"] =
	{
		ppaRepo = "ppa:chromium-daily/stable",
		listEntry = "deb http://ppa.launchpad.net/chromium-daily/stable/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/chromium-daily/stable/ubuntu "..distro:lower().." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ESaSPtAEEAK1nJtoDZ0ewpOOf0ET6Vp28LqO9mB4ubWjzXyRSbiha5pCvnnSIU1K+7Gzb
t3r0iUV9eKLUmf8pqfF/9kwsoqFqFSCjp+XjUzXsEChcGBWvyfGdTX8ClFfwNxSVLvGSqmdX
gZhs0F8tQB0lPWHGy3VvEt7wG/VHqpcOYpdNYRqxABEBAAG0IExhdW5jaHBhZCBQUEEgZm9y
IGNocm9taXVtLWRhaWx5iEYEEBECAAYFAknOwV0ACgkQ9rPTxuzZSv0f2QCeLjemEkq5tYjI
xtFpw3F11szeakYAoKsBZcl3Az08cYEd9UNZjQE1j4YtiEYEEBECAAYFAknS5Z8ACgkQrZOR
ep7Yx+qZ8wCfZYBABDkYO0Ulrivpxn6hARmgLxEAn0SeWaGjVQ4UE3zpNESguf+t9K1xiLYE
EwECACAFAkmkj7QCGwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAKCRBam/O7Tl4XtV/2BACs
/RTpEWB/NUlluJmp1e6iFoyyfbT+HOD3hg35aQMzbdcmijsAiY9MvIfZ0YKWyqNUdGpDj5n0
bUNO0IcvKBBkOn5o4CiBsMp4DJHdrgJU4S00nAJK00E8I/yAv+x4C9uOacW3yrzSHs7Hv/vG
6Z1Jh+1JrabK13hdhwOL8+aY6Q==
=9P6G
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	remmina =
	{
		ppaRepo = "ppa:llyzs/ppa",
		listEntry = "deb http://ppa.launchpad.net/llyzs/ppa/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/llyzs/ppa/ubuntu "..distro:lower().." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0EStwwGQEEANZbC0HylrJgQ9CjbpoUWomZ7UcIJyS74afTfaT9GYKb3j+BHsLtnBanFNQ0
l7UVA1JH2Dr1ky1x7QI5zymBfn7hAq7FQ2lqx52nKWsWFZVmGZqEb7uvOhi+cNs8TS+hKXt6
zYkd5y2NZcc66k/ipjMfDFHJIswq9A4byLex7M1TABEBAAG0EUxhdW5jaHBhZCBSZW1taW5h
iLYEEwECACAFAkrcMBkCGwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAKCRDXJguPWg+o8TtU
A/9MA5Z2PSOv4qzm+Hudcj8j6YH6WTYi/vgYPUn3F6D/32yh49+fbKq7167P4IB+4CmvxSGy
rcx+1d04yUg8ZazMZxVODu3z4M2kytOcXvonpkIG1S0MA9LJITMJLvJqC8jMAPDUCgqJkM29
VCLpcDE8yPw6I1SeT0nQRm//yDFgUg==
=CP/S
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	byobu =
	{
		ppaRepo = "ppa:byobu/ppa",
		listEntry = "deb http://ppa.launchpad.net/byobu/ppa/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/byobu/ppa/ubuntu "..distro:lower().." main",
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

	["awn-testing"] =
	{
		ppaRepo = "ppa:awn-testing/ppa",
		listEntry = "deb http://ppa.launchpad.net/awn-testing/ppa/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/awn-testing/ppa/ubuntu "..distro:lower().." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ESXS1/wEEALis4to4JdgrkdRunmSTfB2tYRq99Cdcgdh9up4HzAf1yTZU1EtmETPP1Uy2
vnAFf/cCunL5VRywNJB3QOxiHdvNlijbdsa0H/fT/ulq+A4iDljUEfsaJug+dAB5uEJE0BzZ
agRjgLbFvRYtsKf3BwZizbo4XtWSAm3JSjZCGZKTABEBAAG0IkxhdW5jaHBhZCBQUEEgZm9y
IEF3biBUZXN0aW5nIFRlYW2IRgQQEQIABgUCSXqnWgAKCRBBf7ZCSCH+JPZMAJ4xW7gbpuA+
yedehvDQWdJHHUgseQCgy6NOmAyXqRKrIXWERkXw6h9TsRuIRgQQEQIABgUCSZQmIAAKCRDZ
S0hfw6VdfffwAJ4n9DnPkv9lEBKBRXXOB/XicTj/TgCgxMmuYalY6LyFqzBRj3VThdx06ICI
RgQQEQIABgUCSdLknAAKCRD2s9PG7NlK/fnGAKDZgIE8ALyl435hYvEsTLSODM65VgCeK/NI
7SuT8DQSMNmtNKbTNShwknqIRgQQEQIABgUCSdLlowAKCRCtk5F6ntjH6u9lAJ9yp2XhA2Lq
LeOad69gnSgsMSAt5ACfS5izZBI+GxzT1JUXN6vefzELxLqItgQTAQIAIAUCSXS1/wIbAwYL
CQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEH0seiO/gQzVpSID/0FXxTSLtxPHrT7IE9eif5qJ
vjOjzcmOCXe9/3G0ctV8IfYHx0VynddjxgTqJ9WuEjMLVHRgXvK1Rw1XMlik+MeyyHrr9EWQ
DUFbUs+Yc2usRyZY8pVe2Uwy2x7lFsi6VBfo0k9jVsu1l1qBU9BhANJDUTHjR15aPYiUJiZa
13CZ
=IvZS
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	rjmyst3 =
	{
		ppaRepo = "ppa:rjmyst3/ppa",
		listEntry = "deb http://ppa.launchpad.net/rjmyst3/ppa/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/rjmyst3/ppa/ubuntu "..distro:lower().." main",
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

	virtualbox =
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
	},

	["ubuntu-tweak"] =
	{
		ppaRepo = "ppa:tualatrix/ppa",
		listEntry = "deb http://ppa.launchpad.net/tualatrix/ppa/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/tualatrix/ppa/ubuntu "..distro.." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ESXTUHwEEAMtdNPmcgQcoPN3JcUcRrmdm1chJSmX6gj28OamOgE3Nxp3XgkDdg/vLFPv6
Tk8zIMxQnvuSpuG1YGp3x8atcKlQAlEHncAo27Vlio6pk8jG+qipDBKq7X7FyXE6X9Peg/k7
t7eXMLwH6ZJFN6IEmvPRTsiiQEd/dXRRuIRhPHirABEBAAG0G0xhdW5jaHBhZCBQUEEgZm9y
IFR1YWxhdHJpWIheBBARCAAGBQJL6UvCAAoJEPySDzP/xnPEIjwA/jqEp/TNbIbmPut3iHEr
Ewmd8ofm/Y+AXvH7lMu68mUqAP9SNPgYQSLKYaTY1EIfS3gB9s8ty92QkntTKY2t3H3IHIhe
BBARCAAGBQJMc4FNAAoJEOvvgzFXGVgwm18BAIdCCSrg7mFThVWVeX5WOEhpjlRTwaO8h5jJ
z+BsyXr/AQCeuc+3tUmQK97jJ6ulqHjkNGo3afrjgnF6odCMb5B/OIi2BBMBAgAgBQJJdNQf
AhsDBgsJCAcDAgQVAggDBBYCAwECHgECF4AACgkQavDhlAYkoiC8mAQAmaxr4Kw/R2WZKde7
MfbTPy7O9YoL/NQeThYGwxX6ICVr0IZUj9nxFQ/vtmhZ59p53bpdR8jpPXjdDwjZIIlxTf72
Fky6Ri3/zsC4YRD6idS4c4L50dTy74W6IabCt8GQLtJy5YASlEp5OGwRNptRSFxVE59LuOPR
o2kvLIAa0Dc=
=FoK5
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	unetbootin =
	{
		ppaRepo = "ppa:gezakovacs/ppa",
		listEntry = "deb http://ppa.launchpad.net/gezakovacs/ppa/ubuntu "..distro:lower().." main\ndeb-src http://ppa.launchpad.net/gezakovacs/ppa/ubuntu "..distro.." main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0ESXZ0aQEEAJuOMpfa92ZgqoLkBTKjN1D3zplRbxCkfCJ7vo5O+lEx5lM8x3K1QU3AY1Vs
LGPMpTVbl9kdFnOIKc0MD166l3yPPjuEmb7a+odpBJHhfcKPhpHc5kVBSrD+7/LnVRFISQZI
IbrN+v3CNU0ZqIJ1FbJpkaqPRKKYhGGaFXTWoKl3ABEBAAG0HUxhdW5jaHBhZCBQUEEgZm9y
IEdlemEgS292YWNziLYEEwECACAFAkl2dGkCGwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAK
CRDUXfLo/JGufqS+A/9+5ZIaV3QuW/gEecvZafnYchgF3ZgG82UDflyvptl5KjVEprYcn3Ey
UAiYCHIu7tiJL2e8Wq3uEp5sGbqdIOqAeAANlvAKJbv1P6tePGPhTRRvWwULnU+xfGzk3HeL
SVKYjJboojJ/ntFqP0vrr4FIKgzXbKNSVjoOMsHRvpeoaA==
=c5Rb
-----END PGP PUBLIC KEY BLOCK-----]=],
	},
}

function AddExtraAptSources()
	local file = io.output( "/etc/apt/sources.list.d/pkg-install-additional.list" )
	file:write( "# This file was created by a script, don't edit this by hand.\n# Any changes made will be lost.\n\n" )

	for ppa, value in pairs( aptDetails ) do
		print( ">>", "Adding '" .. ppa .. "' PPA" )
		if value.ppaRepo ~= nil then
			-- Add key using add-apt-repository.
			os.execute( "sudo add-apt-repository " .. value.ppaRepo )
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
	-- Diffuse diff tool
	local diffuseFilename = "diffuse_0.4.3-1_all.deb"
	os.execute( string.format( "wget --output-document=%s http://sourceforge.net/projects/diffuse/files/diffuse/0.4.3/%s/download", diffuseFilename, diffuseFilename ) )
	-- Install
	os.execute( "dpkg -i " .. diffuseFilename )
	-- Cleanup
	os.remove( diffuseFilename )

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

	-- VirtualBox 4.x Extension Pack (gives USB2.0 support)
	local virtualBoxExtensionFilename	= "Oracle_VM_VirtualBox_Extension_Pack-4.0.2-69518.vbox-extpack"
	os.execute( string.format( "wget --no-check-certificate --output-document=%s http://download.virtualbox.org/virtualbox/4.0.2/%s", virtualBoxExtensionFilename, virtualBoxExtensionFilename ) )
	-- Install
	os.execute( "VBoxManage extpack install " .. virtualBoxExtensionFilename )
	-- Cleanup
	os.remove( virtualBoxExtensionFilename )
end

function main()
	print( appName .. " v" .. appVer .. " - Script to get your machine up and running quickly after a fresh install." )
	print( ">>", #generalPackages + #develPackages + #libraryPackages + 1 .. " packages to install" )

	-- Check if script is being ran as root.
	local username = os.getenv( "USER" )
	if username ~= "root" then
		error( "Please run this as root. Use 'sudo' to run this as root" )
	end

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

	print( ">>", "Finished installing packages..." )
end

main()
