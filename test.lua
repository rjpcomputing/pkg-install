-- ----------------------------------------------------------------------------
--	Test pkg-install plugin syste,
--	Author:	R. Pusztai <rjpcomputing@gmail.com>
--	Date:	03/09/2015
-- ----------------------------------------------------------------------------
require( "pl" )

-- Allow plugins to require other plugins
local homeDir	= os.getenv( "HOME" )
package.path	= package.path .. (";%s/.pkg-install/plugins/?.lua;%s/.pkg-install/plugins/?/init.lua;./plugins/?.lua;./?/init.lua;./plugins/?/init.lua"):format( homeDir, homeDir )
package.cpath	= package.cpath .. (";%s/.pkg-install/plugins/?.so;./plugins/?.so;%s/.pkg-install/plugins/?.dll;./plugins/?.dll;%s/.pkg-install/plugins/?/init.so;./plugins/?/init.so;./?/init.so;%s/.pkg-install/plugins/?/init.dll;./plugins/?/init.dll;./?/init.dll"):format( homeDir, homeDir, homeDir, homeDir)


local function OperatingSystemDetails()
	local lsbRelease = io.popen( "lsb_release -idrc" )
	local releaseInfo = lsbRelease:read( "*all" )
	lsbRelease:close()

	-- parse info
	local osDetails = {}
	for k, v in string.gmatch( releaseInfo, "([%w%s]+):%s(.-)%c" ) do
		osDetails[k:gsub(" ", "_"):lower()] = v
	end

	return osDetails
end
local options = OperatingSystemDetails()
options.desktop = arg[1] or true
print( pretty.write( options ) )
local plugins = require( "plugins" ).new( options )

local function main()
	local loadedPlugins = plugins:Load()

--	print( pretty.write( loadedPlugins ) )
end

main()
