local _M =
{
	name		= "Debian Core",
	description	= "Packages installed on all Debian based systems",
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
		"libserf-dev",
		"libpq-dev",
		"libsqlite3-dev",
		"libncurses5-dev",
		"libcurl4-openssl-dev",
		"libzzip-dev",
		"zlib1g-dev",
		"libbz2-dev",
	},
	desktopPackages =
	{
		-- General
		-- Development
		-- Libraries
	},
	PreInstall	= function()
	end,
	Install		= function()
	end,
	PostInstall = function()
		if _M.desktop then
			InstallVirtualBoxExtensionPack()
		end
	end
}

local function InstallVirtualBoxExtensionPack()
	-- VirtualBox 4.x Extension Pack (gives USB2.0 support)
	local virtualBoxExtensionUrl = "http://download.virtualbox.org/virtualbox/4.3.10/Oracle_VM_VirtualBox_Extension_Pack-4.3.10-93012.vbox-extpack"
	local virtualBoxExtensionFilename = virtualBoxExtensionUrl:gsub( "\\", "/" ):match( "([^/]-[^%.]+)$" )
	os.execute( ("wget --no-check-certificate --output-document=%s %s"):format( virtualBoxExtensionFilename, virtualBoxExtensionUrl ) )
	-- Install
	os.execute( ("VBoxManage extpack install %s"):format( virtualBoxExtensionFilename ) )
	-- Cleanup
	os.remove( virtualBoxExtensionFilename )
end

return function( options )
	if options and options.desktop then
		_M.desktop = options.desktop or true

		for _, desktopPackage in ipairs( _M.desktopPackages ) do
			table.insert( _M.packages, desktopPackage )
		end
	end

	return _M
end
