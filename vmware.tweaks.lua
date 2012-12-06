-- ----------------------------------------------------------------------------
-- Tweaks to a VMWare server setup.
-- Author:	Ryan Pusztai
-- Date:	05/16/2012
-- Notes:	Built against Ubuntu 12.04 (Precise).
-- ----------------------------------------------------------------------------

-- General Setup
local distro = "Oneiric"    -- TODO: Update with the current release available by VMWare

local tweaks =
{
	_VERSION = "1.00",
	_APP_NAME = "VMWare Setup Tweaks",
	{
		name = "add_vmware_apt_rep",
		comment = "Add the VMWare apt repository",
		command =
		{
		"sudo apt-add-repository 'deb http://packages.vmware.com/tools/esx/4.1latest/ubuntu " .. distro:lower() .. " main restricted'",
		"sudo wget http://packages.vmware.com/tools/VMWARE-PACKAGING-GPG-KEY.pub -q -O- | sudo apt-key add -"
		}
	},
	{
		name = "vmware-open-vm-tools-kmod",
		comment = "Builds and installs the VMWare kernel module.",
		command =
		{
		"sudo apt-get install vmware-open-vm-tools-kmod-source",
		"sudo module-assistant prepare",
		"sudo module-assistant build vmware-open-vm-tools-kmod-source",
		"sudo module-assistant install vmware-open-vm-tools-kmod",
		}
	},
	{
		name = "vmware-open-vm-tools-nox",
		comment = "Installs VMWare Tools for headless system.",
		command = "sudo apt-get install vmware-open-vm-tools-nox"
	}
}

return tweaks
