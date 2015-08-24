local _M =
{
	name		= "Lua",
	description	= "Install Lua batteries",
	_VERSION	= "1.1",
	packages	=
	{
	},
	rocks =
	{
		{ "busted" },
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
		"luasocket",
		{ "luasql-postgres", options = { PGSQL_INCDIR = "/usr/include/postgresql", POSTGRES_INCDIR = "/usr/include/postgresql" } },
		{ "luasql-sqlite3", version = "cvs-1", from = "http://rocks.luarocks.org/dev" },
		"luazip",
		{ "lzlib", options = { ZLIB_LIBDIR = "/usr/lib/x86_64-linux-gnu" } },
		"markdown",
		"md5",
		{ "orbit", version = "cvs-3", from = "http://rocks.luarocks.org/dev" },
		"penlight",
		"rings",
		"struct",
		{ "wsapi-xavante", version = "cvs-1", from = "http://rocks.luarocks.org/dev" },
		--"lunary",
	},
	PreInstall	= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PreInstall() called..." ) end
		os.execute( options.installCommand .. " liblua5.1-0-dev libldap2-dev luajit build-essential" )
		os.execute( "wget http://luarocks.org/releases/luarocks-2.2.1.tar.gz" )
		os.execute( "tar zxpf luarocks-2.2.1.tar.gz" )
		os.execute( "cd luarocks-2.2.1; ./configure; sudo make bootstrap" )
	end,
	Install		= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "Install() called..." ) end
		-- Update LuaRocks
		os.execute( "luarocks --from=http://rocks.luarocks.org install luarocks" )
		--os.execute( "apt-get remove -y luarocks" )	-- Seems to break the updated installation, so leaving it

		-- Install rocks one at a time because LuaRocks doen't support lists
		for _, rock in pairs( self.rocks ) do
			local cmd = ("luarocks %s install %s")
			if "table" == type( rock ) then
				local options = {}
				options[1 + #options] = "--from=" .. ( rock.from or "http://rocks.luarocks.org" )
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
				os.execute( cmd:format( "--from=http://rocks.luarocks.org", rock ) )
			end
		end
	end,
	PostInstall = function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PostInstall() called..." ) end
	end
}

return function( options )
	if options.distributor_id:lower() == "ubuntu" then
		table.insert( _M.rocks, 1, { "luasec", options = { OPENSSL_LIBDIR = "/lib/x86_64-linux-gnu" } } )
		table.insert( _M.rocks, { "lualdap", options = { LIBLDAP_LIBDIR = "/usr/lib/x86_64-linux-gnu" } } )
	else
		table.insert( _M.rocks, 1, "luasec" )
		table.insert( _M.rocks, "lualdap" )
	end
	return _M
end
