-- ----------------------------------------------------------------------------
--	Test pkg-install plugin syste,
--	Author:	R. Pusztai <rjpcomputing@gmail.com>
--	Date:	03/09/2015
-- ----------------------------------------------------------------------------
require( "pl" )
local plugins = require( "plugins" )

local function main()
	local loadedPlugins = plugins.Load()

	print( pretty.write( loadedPlugins ) )
end

main()
