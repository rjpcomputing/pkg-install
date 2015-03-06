local _M =
{
	name		= "Ubuntu Core",
	description	= "Packages installed on all Ubnutu systems",
	_VERSION	= "1.0-dev",
	packages =
	{
		--
		-- General --
		--
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
		"openjdk-8-jdk",
		"curl",
		"sqlite3",
		--
		-- Development --
		--
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
		--"svnwcrev",
		"premake4",
		"valgrind",
		"debhelper",
		"rake",
		"doxygen",
		"graphviz",
		"exuberant-ctags",
		--
		-- Libraries --
		--
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
	},
	PreInstall	= function()
	end,
	Install		= function()
	end,
	PostInstall = function()
	end
}

return function( options )
	return _M
end
