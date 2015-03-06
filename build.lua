-- -----------------------------------------------------------------------
-- Simple script to make a simple single file out of all of pkg-install
-- and it's plugins
-- -----------------------------------------------------------------------
-- Build the amag cache file
local command = [[lua -e "package.path = package.path .. ';support/?.lua'" -l amalg pkg-install.lua]]
print( command ); io.stdout:flush()
os.execute( command )
-- Compile to a single file using the generated cache
os.execute( "lua support/amalg.lua -d -c -s pkg-install.lua -o bin/pkg-install.lua" )
