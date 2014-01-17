#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your machine up and running quickly after a fresh install.
-- Author:	Ryan P. <rjpcomputing@gmail.com>
-- Date:	12/06/2013
-- Notes:	Built against Ubuntu 13.10 (Saucy Salamander).
--			Assumes root privileges.
--
-- Changes:
--	12/06/2013 (13.10-01) - Initial Release
--	01/06/2014 (13.10-02) - Switched to using Google Chrome instead of Chromium
--	01/07/2014 (13.10-03) - Fixed lighdm greeter configuration
--	                      - Removed the automatic install of nvidia drivers
--	                        because it was causing to many problems
--	01/16/2014 (13.10-04) - Updated to wxAdditioiins 3.0
-- ----------------------------------------------------------------------------

-- General Setup
local distro = "Saucy"
local appName = "pkg-install"
local appVer = "13.10-04"

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
	"icedtea-7-plugin",
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
	"codelite",
	"meld",
	"diffuse",
	"ghex",
	"wxformbuilder",
	"wxfb-wxadditions",
	"doxygen",
	"graphviz",
	"xavante",
	"luarocks",
	"lua-bitop*",
	"lua-copas",
	"lua-cosmo",
	"lua-coxpcall",
	"lua-curl*",
	"lua-dbi-*",
	"lua-doc",
	"lua-expat*",
	"lua-filesystem*",
	"lua-json",
	"lua-logging",
	"lua-lpeg*",
	"lua-markdown",
	"lua-md5*",
	"lua-orbit",
	"lua-penlight*",
	"lua-posix*",
	"lua-rex-*",
	"lua-rings*",
	"lua-sec*",
	"lua-socket*",
	"lua-sql-*",
	"lua-zip*",
	"lua-zlib*",
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
	"libboost1.54-all-dev",
	"libboost1.54-dbg",
	"liblua5.1-0-dev",
	"liblua5.1-0-dbg",
	"libsvn-dev",
	"libneon27-gnutls-dev",
	"libpq-dev",
	"libmysqlclient-dev",
	"libsqlite3-dev",
	"libncurses5-dev",
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

	kupfer =
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
		},

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

	wxwidgets =
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

	syspeek =
	{
		--ppaRepo = "ppa:emptythevoid/syspeeknew",
		listEntry = "deb http://ppa.launchpad.net/emptythevoid/syspeeknew/ubuntu quantal main\ndeb-src http://ppa.launchpad.net/emptythevoid/syspeeknew/ubuntu quantal main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.1.4
Comment: Hostname: keyserver.ubuntu.com

mI0EUI9MHQEEAN6pIGqrOfIV4/lj+Yf5Sct8CulM1nnvwfwkKkm2HlP7oj49rJ/eZpF0zL7X
/KwRVYBfjGGsqEDpuaBL/1txL6LUtUoDlE1dFe4lrSBYXAihGNA80Vmmg4FNAUTFZf7ndxvc
jAn1q7zrDE05LmYAyQEECJsHjs3mZkjNmhIB2/lpABEBAAG0HkxhdW5jaHBhZCBQUEEgZm9y
IGVtcHR5dGhldm9pZIi4BBMBAgAiBQJQj0wdAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIX
gAAKCRAHyGRjeAgdFdAhBADQ9o23ykZSA/0jkb4s8hSzsuSt/fFgGxihzyq9EgSM6d9BCLqA
QmsU0L1TnP7lWcX3yztBMf8OkEsSdVHILeJ+3Rt1jQ05W2BlDJzhjVFJTiWb3QdtKYmKOxfS
uy1pABBlTj2tiUpI2RKTjAsvJHGuYEYiBHNnfjEUYkMLthjwNw==
=imbP
-----END PGP PUBLIC KEY BLOCK-----]=],
	},

	exfat =
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
	},

	--[===[unetbootin =
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
	},]===]
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
	-- Diffuse diff tool
	--local diffuseFilename = "diffuse_0.4.6-1_all.deb"
	--os.execute( string.format( "wget --output-document=%s http://sourceforge.net/projects/diffuse/files/diffuse/0.4.6/%s/download", diffuseFilename, diffuseFilename ) )
	-- Install
	--os.execute( "dpkg -i " .. diffuseFilename )
	-- Cleanup
	--os.remove( diffuseFilename )

	-- Penlight Lua module
	--local penlightFilename	= "penlight-latest.zip"
	--os.execute( string.format( "wget --no-check-certificate --output-document=%s http://github.com/stevedonovan/Penlight/zipball/master", penlightFilename ) )
	-- Extract
	--os.execute( string.format( "unzip -oj %s *lua/* -d pl", penlightFilename ) )
	-- Create directories if don't exist
	--os.execute( "sudo mkdir -p /usr/share/lua/5.1/")
	-- Move to location
	--os.execute( "sudo mv pl/ /usr/share/lua/5.1/")
	-- Cleanup
	--os.remove( penlightFilename )

	-- VirtualBox 4.x Extension Pack (gives USB2.0 support)
	local virtualBoxExtensionFilename	= "Oracle_VM_VirtualBox_Extension_Pack-4.2.2-81494.vbox-extpack"
	os.execute( string.format( "wget --no-check-certificate --output-document=%s http://download.virtualbox.org/virtualbox/4.2.2/%s", virtualBoxExtensionFilename, virtualBoxExtensionFilename ) )
	-- Install
	os.execute( "VBoxManage extpack install " .. virtualBoxExtensionFilename )
	-- Cleanup
	os.remove( virtualBoxExtensionFilename )
end

function AddManualUserLogin()
	local file = io.open( "/etc/lightdm/lightdm.conf.d/50-unity-greeter.conf", "a+" )
	if file then
		print( ">>", "Making manual user login possible..." )

		-- Make a backup
		os.execute( "cp /etc/lightdm/lightdm.conf.d/50-unity-greeter.conf /etc/lightdm/50-unity-greeter.conf.bak" )

		-- Check to see if it has been added already
		local lineToAdd = "greeter-show-manual-login=true"
		if nil == string.find( file:read( "*a" ), lineToAdd:gsub( "-", "%%-" ) ) then
			file:write( ("%s\n"):format( lineToAdd ) )
		end

		file:close()
	end
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

	-- FIX: RabbitVCS is broken in 13.04 so these symlinks are needed.
	--os.execute( "ln -s /usr/lib/x86_64-linux-gnu/libpython2.7.so.1.0 /usr/lib/libpython2.7.so.1.0" )
	--os.execute( "ln -s /usr/lib/x86_64-linux-gnu/libpython2.7.so.1.0 /usr/lib/x86_64-linux-gnu/libpython2.7.so" )

	-- Build the packages into a string.
	local allPackages = table.concat( generalPackages, " " ).." "
	allPackages = allPackages..table.concat( develPackages, " " ).." "
	allPackages = allPackages..table.concat( libraryPackages, " " ).." "
	if IsRunningInVm() then
		allPackages = allPackages.." virtualbox-guest-dkms"
	end
	
	print( ">>", "Full list of packages to be installed..." )
	print( allPackages )

	-- Install all packages
	print( ">>", "Installing packages..." )
	local cmd = "apt-get -y install "..allPackages
	os.execute( cmd )

	print( ">>", "Installing packages that don't have any APT repository..." )
	InstallNonAptApplications()
	
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
