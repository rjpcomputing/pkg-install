#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
-- Script to get your server machine up and running quickly after a fresh install.
-- Author:	Ryan Pusztai
-- Date:	05/17/2012
-- Notes:	Built against Ubuntu 12.04 (Precise).
--
-- Changes:
--	05/17/2012 (12.04-01) - Initial Release
-- ----------------------------------------------------------------------------

-- Join the domain
os.execute( "sudo domainjoin-cli join GENTEX.COM compadd g3n_ADD" )

-- Set the proper user domain prefix
os.execute( 'sudo lwconfig UserDomainPrefix WONDERLAN' )
-- Change the "HomeDirTemplate" setting to have the value of "%H/%D/%U"
os.execute( 'sudo lwconfig HomeDirTemplate "%H/%D/%U"' )
-- Make the default shell bash. This is what is the norm for Ubuntu.
os.execute( 'sudo lwconfig LoginShellTemplate /bin/bash' )
-- Make sure to use the default domain so that the user does not need to login using DomainName\username.
os.execute( 'sudo lwconfig AssumeDefaultDomain true' )
