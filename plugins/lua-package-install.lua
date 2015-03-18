local _M =
{
	name		= "Lua",
	description	= "Install Lua batteries",
	_VERSION	= "1.0",
	packages	=
	{
	},
	rocks =
	{
		{ "busted", version = "1.11.1-1" },		-- Version specified because the latest RC2 has a bug
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
		{ "lualogging", version = "1.2.0-1" },	-- the current latest stable (1.3.0-1) seems to be corrupt, so i am pinning the version.
		"luaposix",
		{ "luasec", options = { OPENSSL_LIBDIR = "/lib/x86_64-linux-gnu" } },
		"luasocket",
		{ "luasql-postgres", options = { PGSQL_INCDIR = "/usr/include/postgresql", POSTGRES_INCDIR = "/usr/include/postgresql" } },
		{ "luasql-sqlite3", version = "cvs-1", from = "http://rocks.moonscript.org/dev" },
		"luazip",
		{ "lzlib", options = { ZLIB_LIBDIR = "/usr/lib/x86_64-linux-gnu" } },
		"markdown",
		"md5",
		"orbit",
		"penlight",
		"rings",
		"struct",
		{ "wsapi-xavante", version = "cvs-1", from = "http://rocks.moonscript.org/dev" },
		--"lunary",
	},
	PreInstall	= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PreInstall() called..." ) end
		os.execute( "wget http://luarocks.org/releases/luarocks-2.2.0.tar.gz" )
		os.execute( "tar zxpf luarocks-2.2.0.tar.gz" )
		os.execute( "cd luarocks-2.2.0; ./configure; sudo make bootstrap" )
	end,
	Install		= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "Install() called..." ) end
		-- Update LuaRocks
		os.execute( "luarocks --from=http://rocks.moonscript.org install luarocks" )
		--os.execute( "apt-get remove -y luarocks" )	-- Seems to break the updated installation, so leaving it

		-- Install rocks one at a time because LuaRocks doen't support lists
		for _, rock in pairs( self.rocks ) do
			local cmd = ("luarocks %s install %s")
			if "table" == type( rock ) then
				local options = {}
				options[1 + #options] = "--from=" .. ( rock.from or "http://rocks.moonscript.org" )
				if rock.options then
					for name, value in pairs( rock.options ) do
						options[1 + #options] = ("%s=%s"):format( name, value )
					end
				end
				print( ("[%s] %s"):format( rock[1], string.rep( "-", 20 ) ) )
				--print( cmd:format( table.concat( options, " " ), ("%s %s"):format( rock[1], rock.version or ""  ) ) )
				os.execute( cmd:format( table.concat( options, " " ), ("%s %s"):format( rock[1], rock.version or ""  ) ) )
			else
				print( ("[%s] %s"):format( rock, string.rep( "-", 20 ) ) )
				os.execute( cmd:format( "--from=http://rocks.moonscript.org", rock ) )
			end
		end
	end,
	PostInstall = function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PostInstall() called..." ) end
	end
}

return function( options )
	return _M
end
