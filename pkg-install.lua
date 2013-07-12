#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your machine up and running quickly after a fresh install.
-- Author:	Ryan Pusztai
-- Date:	05/29/2013
-- Notes:	Built against Ubuntu 13.04 (Raring Ringtail).
--			Assumes root privileges.
--
-- Changes:
--	05/29/2013 (13.04-01) - Initial Release
--	05/29/2013 (13.04-02) - Added fix for RabbitVCS and nautilus-python.
--	                        Removed installing diffuse from a download.
--	                        Moved the install of likewiseopen to the domain setup script.
--	                        Removed installing the fuse-exfat support it does not work as of creation of this script.
--	06/18/2013 (13.04-03) - Only install the virtualbox guest addtions if a vm
--	07/12/2013 (13.04-04) - Added smbnetfs and rake
-- ----------------------------------------------------------------------------

-- General Setup
local distro = "Raring"
local appName = "pkg-install"
local appVer = "13.04-04"

-- General Applications
local generalPackages =
{
	"aptitude",
	"synaptic",
	"gdebi",
	"alacarte",
	"chromium-browser",
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
	"compizconfig-settings-manager",
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
	"libboost1.53-all-dev",
	"libboost1.53-dbg",
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

--[===[
	["chromium-stable"] =
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
]===]
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
--[===[
	getdeb =
	{
		listEntry = "deb http://archive.getdeb.net/ubuntu "..distro:lower().."-getdeb apps",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.9 (GNU/Linux)

mQINBEoN6uABEADGJQBv6TJubjMfaPfT8WGKta5KuFXHgyjuDINE3GDEu9V/L6hD
OjpNUblSGtkRvljjkp+HvBphrIrFtg7/T1YH/jhG1mngJEayXUrWKwcQBwxHVJlJ
8+S5FCXa31RyCmdd0DhMdLMJf7tfN0MxsmcK9MtbxVdONSWRqaC1+4Voqk/VuVIv
qdQUJu/7H1WdBmLELrjtL0khfX85AblYphbuPsQfx/9k7cT+JnjcT5hR8Fl7/rpf
1H9AUHv/nAxbj28kpIi7Xgpa7JFrklqujyjLhjS504dHXriYILM1ZC4neVg2j+kc
IBvRoT3Uvb5BGZ2k+hh5MOG0V+Xpxb5HLjtez2jjiujE7EbaLiax2pVTcGKmc0ae
HEDXjGfBgoCKl7emDf6huJnmiVcdHxuVFGJEsmKSHSUsAtOkCkKqK6K4C0VC2+Rf
TN8EOLaDejFRTPKBDsULjM6eDF45+Aqnqg98NvA/CIUftCZ5MmUPy7+j8cbh7QIy
Y7rGKVHoZv5BZHnTydMbaOe34clJmxJ+JEcInEVR50GN3g3OjiiCBa+P7DQdV7ff
bCOmssB5+Fcaa85CSmjMbmwFvNQvAmpNPVOdRNy9Ct6iJ+9mLWxfhKzac8gGy+Cm
ZrXe3xLxZIlogoVX/NLEuJwEWLCya/f4sAbNuOZqGhqX2I8BaiT2eTeJfQARAQAB
tDlHZXREZWIgQXJjaGl2ZSBBdXRvbWF0aWMgU2lnbmluZyBLZXkgPGFyY2hpdmVA
Z2V0ZGViLm5ldD6JAjcEEwEIACEFAkoN6uACGwMFCwkIBwMFFQoJCAsFFgIDAQAC
HgECF4AACgkQqKUV8EbX588I3w/+MLMjIDB3HPOTucaxuUWfsFKm4RB7nkVIhPuW
6rdsFH4eqFgivMS47oNTi8QmviPsU7TXBchtNfGrIWZUP4CGiLYSwResbN+UMB9f
JRx/FNp6VwjeRYPJObk0q/EukNDaiT/UItrQz08laLlj7QScxoh7u3NGZnCGvacd
dzNcOwfmkh1N5tzyXMae3Zv2L0VG3v4ZP/yPWB6W9ziUsFVI65oiFkHHvjZgLOp0
2pB54YcjUz91z6Fq2RVgDk+p7T6YTo8ZInptb/Blfu4+uSp1Pcloe2eyGMDMy5fp
mrtIWfDqVYkZGFU2w+GpaJMPe3ZKlAOUBxiTmB4AqKj1K1sQ3PMUzrQaWdbuWZz4
w+rQCeF3BPOolIyudGhHis6oXQykOZwYBA2/AQAKlfdJDqnKqULKjFe5UTiy32Od
r/3dWnNZGJ0dY+6G/bTtpMIHzZkfdd3tgqybtQjX3sTMtG7g7PZdg0awXlfvbo7N
QoqkzaQhpqDajQ7kigFQ6ZAcvUio58ePehWkwiHsdrrK80Zhy69azDJpgN2zGRBA
1RFv1x7YetjSfUyGv3632UcOcpGagA4BwEDYB5Tgav5Vz/QRgjlkh/UQP11eq3BD
aOR5ibezxThk9Ukuba7U1Nbqr6YUvxuVMFz14okaw9FlhCwB9PMiZT+sp3/Ygxdr
I+LZoJw=
=35Cn
-----END PGP PUBLIC KEY BLOCK-----]=],
	},
]===]

--[===[
	["syspeek-old"] =
	{
		--ppaRepo = "ppa:vicox/syspeek",
		listEntry = "deb http://ppa.launchpad.net/vicox/syspeek/ubuntu oneiric main\ndeb-src http://ppa.launchpad.net/vicox/syspeek/ubuntu oneiric main",
		key = [=[-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.0.10

mI0EScK9mwEEAMz00TJgdmc1pBUUIOti5rRILpl/DMcNhLQW3BtKHQkeW9udmNv+rPShFReG
lsER3mq3NSNqLbpodwYFsDL3RKXouStIzgVePGOUF6RGcJPPJJO6NGgEocGH6mBu1+ghFQRy
/dHIhQrvZwspfkyFDigA2mnROUFPoxJX1rP6Zcy5ABEBAAG0H0xhdW5jaHBhZCBQUEEgZm9y
IEdlb3JnIFNjaG1pZGyItgQTAQIAIAUCScK9mwIbAwYLCQgHAwIEFQIIAwQWAgMBAh4BAheA
AAoJEN9229RT/8woxwUEAMqCliAhdje0taw0Hrjk5vhqzgPQRE0krV22b+e5/mjuxTk8Z1/H
LHhIzjtxzhkGPUBeIJpWEXHILdcwVYDfPzpWJJgs93bWD3ggip6QAvBZ9ZJdGkzLXsLOgCj+
c7bCfuPeZ8n1hVzL1pjjKStTrdq5YeNfDbsnCVZB9RDgfXce
=R59j
-----END PGP PUBLIC KEY BLOCK-----]=],
	},
]===]

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
	local file = io.open( "/etc/lightdm/lightdm.conf", "a+" )
	if file then
		print( ">>", "Making manual user login possible..." )

		-- Make a backup
		os.execute( "cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak" )

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
	os.execute( "ln -s /usr/lib/x86_64-linux-gnu/libpython2.7.so.1.0 /usr/lib/libpython2.7.so.1.0" )
	os.execute( "ln -s /usr/lib/x86_64-linux-gnu/libpython2.7.so.1.0 /usr/lib/x86_64-linux-gnu/libpython2.7.so" )

	-- Build the packages into a string.
	local allPackages = table.concat( generalPackages, " " ).." "
	allPackages = allPackages..table.concat( develPackages, " " ).." "
	allPackages = allPackages..table.concat( libraryPackages, " " ).." "
	if IsRunningInVm() then
		allPackages = allPackages.." virtualbox-guest-dkms"
	else
		allPackages = allPackages.." nvidia-current-updates"
	end

	print( ">>", "Full list of packages to be installed..." )
	print( allPackages )

	-- Install all packages
	print( ">>", "Installing packages..." )
	local cmd = "apt-get -y install "..allPackages
	os.execute( cmd )

	print( ">>", "Installing packages that don't have any APT repository..." )
	InstallNonAptApplications()

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
