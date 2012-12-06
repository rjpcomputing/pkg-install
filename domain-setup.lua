#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your server machine up and running quickly after a fresh install.
-- Author:	Ryan Pusztai
-- Date:	10/26/2012
-- Notes:	Built against Ubuntu 12.10 (Quantal).
--
-- Changes:
--	10/26/2012 (12.10-01) - Initial Release
-- ----------------------------------------------------------------------------

local function MakeUserAdmin()
	print( "Do you want to add a user as admin? [yN]" )
	local shouldAddUser = io.stdin:read():lower() == "y"
	if shouldAddUser then
		print( "Please enter the username to add as administrator and press <Enter>" )
		local username = io.stdin:read()
		
		print( ("Adding %q as an administrator of this machine"):format( username ) )
		local groupFilename = "/etc/group"
		
		-- Add user to these specified groups
		local groups = { "adm", "cdrom", "sudo", "dip", "plugdev", "lpadmin", "sambashare" }
		local groupLines = {}
		for line in io.lines( groupFilename ) do
			local addUsername = false
			-- Search for lines starting with specific group
			for _, group in ipairs( groups ) do
				if string.find( line, ("^%s:"):format( group ) ) then
					addUsername = true
					break	-- It can only be found once per line
				end
			end
			
			if addUsername == true then
				groupLines[#groupLines + 1] = line .. "," .. username
			else
				groupLines[#groupLines + 1] = line
			end
		end
		
		-- Backup group file
		os.execute( ("mv %s %s.bak"):format( groupFilename, groupFilename ) )
		
		-- Write it to disk
		local groupFileOut = io.output( groupFilename )
		groupFileOut:write( table.concat( groupLines, "\n" ) )
		groupFileOut:write( "\n" )	-- Add a newline to the end of the file
		groupFileOut:close()
	end
end

local function DomainSetup()
	-- Join the domain
	os.execute( "domainjoin-cli join GENTEX.COM compadd g3n_ADD" )

	-- Set the proper user domain prefix
	os.execute( "lwconfig UserDomainPrefix WONDERLAN" )
	-- Change the "HomeDirTemplate" setting to have the value of "%H/%D/%U"
	os.execute( 'lwconfig HomeDirTemplate "%H/%D/%U"' )
	-- Make the default shell bash. This is what is the norm for Ubuntu.
	os.execute( "lwconfig LoginShellTemplate /bin/bash" )
	-- Make sure to use the default domain so that the user does not need to login using DomainName\username.
	os.execute( "lwconfig AssumeDefaultDomain true" )
	
	MakeUserAdmin()
end

return DomainSetup

