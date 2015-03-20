#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your server machine up and running quickly after a fresh install.
-- Author:	Ryan Pusztai
-- Date:	03/16/2015
-- Notes:
--
-- Changes:
--	03/16/2015 (1.0-01) - Initial Release
-- ----------------------------------------------------------------------------
local _M =
{
	name		= "Domain Setup",
	description	= "Install PowerBroker Identity Services and join the domain",
	_VERSION	= "1.0",
	packages	=
	{
	},
	PreInstall	= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PreInstall() called..." ) end
	end,
	Install		= function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "Install() called..." ) end
		-- Install  PowerBroker Identity Services
		local url = "http://download.beyondtrust.com/PBISO/8.2.1/linux.deb.x64/pbis-open-8.2.1.2979.linux.x86_64.deb.sh"
		local filename = url:gsub( "\\", "/" ):match( "([^/]-[^%.]+)$" )
		os.execute( ("wget %s"):format( url ) )
		os.execute( ("chmod +x %s"):format( filename ) )
		os.execute( ("./%s -- --no-legacy --dont-join install"):format( filename ) )
		-- Cleanup
		os.execute( "rm -rf pbis-open-*" )

		-- Join the domain
		os.execute( "/opt/pbis/bin/domainjoin-cli join GENTEX.COM compadd g3n_ADD" )

		-- Fix an Ubuntu 14.04 bug where it doesn't allow a login to finish and start X11/Unity
		if options.distributor_id:lower() == "ubuntu" and options.release == "14.04" then
			FixPAM1404()
		end

		-- Set the proper user domain prefix
		os.execute( "/opt/pbis/bin/config UserDomainPrefix WONDERLAN" )
		-- Change the "HomeDirTemplate" setting to have the value of "%H/%D/%U"
		os.execute( '/opt/pbis/bin/config HomeDirTemplate "%H/%D/%U"' )
		-- Make the default shell bash. This is what is the norm for Ubuntu.
		os.execute( "/opt/pbis/bin/config LoginShellTemplate /bin/bash" )
		-- Make sure to use the default domain so that the user does not need to login using DomainName\username.
		os.execute( "/opt/pbis/bin/config AssumeDefaultDomain true" )
	end,
	PostInstall = function( self, options )
		if options.debug then print( "[DEBUG]", self.name, "PostInstall() called..." ) end
		MakeUserAdmin()
	end
}

local function MakeUserAdmin()
	print( "Do you want to add a user as admin? [yN]" )
	local shouldAddUser = io.stdin:read():lower() == "y"
	if shouldAddUser then
		print( "Please enter the username to add as administrator and press <Enter>" )
		local username = io.stdin:read()

		print( ("Adding %q as an administrator of this machine"):format( username ) )
		local groupFilename = "/etc/group"

		-- Add user to these specified groups
		local groups = { "adm", "cdrom", "sudo", "dip", "plugdev", "lpadmin", "sambashare", "dialout" }
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

local function FixPAM1404()
	-- Read the file contents
	local commonSession = io.input( "/etc/pam.d/common-session" )
	local commonSessionContents = commonSession:read( "*all" )
	commonSession:close()

	-- Change the contents to fix the bug
	commonSessionContents = commonSessionContents:gsub( "session%s-sufficient%s-pam_lsass.so", "session [success=ok default=ignore] pam_lsass.so" )

	-- Write the modified contents to the file.
	commonSession = io.output( "/etc/pam.d/common-session" )
	commonSession:write( commonSessionContents )
	commonSession:close()
end

return function( options )
	return _M
end
