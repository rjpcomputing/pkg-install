local plugin = require( "plugins.interface" )

local _M =
{
	name		= "Debian Core",
	description	= "Packages installed on all Debian based systems",
	_VERSION	= "1.0",
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
		"curl",
		"sqlite3",
		--
		-- Development --
		--
		"build-essential",
		"gdb",
		"clang",
		"linux-source",
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
		"libqt4-dev",
		"libqt4-dbg",
		"qt4-dev-tools",
		"libgtk2.0-dev",
		"libgtk2.0-0-dbg",
		"libboost-all-dev",
		"libboost-dbg",
		"liblua5.1-0-dev",
		"liblua5.1-0-dbg",
		"libsvn-dev",
		"libssl-dev",
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
		--
		-- General --
		--
		"alacarte",
		"synaptic",
		"google-chrome-stable",
		"geany",
		"pinta",
		"gimp",
		"kupfer",
		"guake",
		"pidgin",
		"dkms",
		"synergy",
		--"icedtea-plugin",
		--
		-- Development --
		--
		"codelite",
		"meld",
		"diffuse",
		"ghex",
		--
		-- Libraries --
		--
	},
	PreInstall	= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PreInstall() called..." ) end
		-- Update apt.
		print( ">>", "Updating APT..." )
		os.execute( "apt-get update" )

		-- Upgrade all packages
		print( ">>", "Upgrading packages..." )
		os.execute( "apt-get -y dist-upgrade" )

		if options.desktop then
			-- Make sure Google Chrome does not add Googles repo during the install, because this script does it already.
			os.execute( "touch /etc/default/google-chrome" )
		end
	end,
	Install		= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "Install() called..." ) end
	end,
	PostInstall = function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PostInstall() called..." ) end
		if options.desktop and not options.runningAsVm then
			InstallVirtualBoxExtensionPack()
		end

		-- Upgrade all packages again. In case there was a failure during install.
		print( ">>", "Finish with a full system package upgrate..." )
		os.execute( "apt-get -y dist-upgrade" )
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
	end

	if options.desktop and not options.runningAsVm then
		table.insert( _M.desktopPackages, "virtualbox" )
		table.insert( _M.desktopPackages, "virtualbox-dkms" )
	end

	return plugin.new( _M )
end
