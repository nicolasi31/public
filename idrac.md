**IDRAC Tips and Tricks**

[[_TOC_]]


# Usefull links
- ftp://ftp.dell.com/Manuals/all-products/esuprt_electronics/esuprt_software/esuprt_remote_ent_sys_mgmt/dell-remote-access-cntrllr-5-v1.40-with-dell-openmanage-5.5_user%27s%20guide_fr-fr.pdf
- https://www.slac.stanford.edu/grp/cd/soft/unix/EnableConsoleAccessViaSsh.htm
- http://dev.gnali.org/?p=435
- https://github.com/Cizin/Idrac-cheat-sheet

```shell
racadm getconfig -g cfgUserAdmin -i 2 -v

racadm config -g cfgServerInfo -o cfgServerBootOnce 1
racadm config -g cfgServerInfo -o cfgServerFirstBootDevice VCD-DVD

racadm config -g cfgRacVirtual -o cfgVirtualBootOnce

console com2
or
connect com2

racadm serveraction powercycle

racadm  racreset
```

# IDRAC 5

```shell
$ racadm getsysinfo

RAC Information:
RAC Date/Time           = Wed Feb 28 14:35:01 2013
Firmware Version        = 1.45
Firmware Build          = 09.01.16
Last Firmware Update    = NA
Hardware Version        = A04
Current IP Address      = 192.168.0.120
Current IP Gateway      = 192.168.0.1
Current IP Netmask      = 255.255.255.128
DHCP Enabled            = 0
MAC Address             = 00:26:b9:12:34:56
Current DNS Server 1    = 0.0.0.0
Current DNS Server 2    = 0.0.0.0
DNS Servers from DHCP   = 0
Register DNS RAC Name   = 0
DNS RAC Name            = srv01
Current DNS Domain      = mydomain.org

System Information:
System Model            = PowerEdge 2970
System Revision         = [N/A]
System BIOS Version     = 3.0.3
BMC Firmware Version    = 2.36
Service Tag             = C8ZM84K
Host Name               = srv01
OS Name                 =
Power Status            = ON

Watchdog Information:
Recovery Action         = None
Present countdown value = 15 seconds
Initial countdown value = 15 seconds
```

```shell
$ racadm help
 help [subcommand] -- display usage summary for a subcommand
 arp             -- display the networking ARP table
 clearasrscreen  -- clear the last ASR (crash) screen
 clrraclog       -- clear the RAC log
 clrsel          -- clear the System Event Log (SEL)
 config          -- modify RAC configuration properties
 coredump        -- display the last RAC coredump
 coredumpdelete  -- delete the last RAC coredump
 fwupdate        -- update the RAC firmware
 getconfig       -- display RAC configuration properties
 getniccfg       -- display current network settings
 getraclog       -- display the RAC log
 getractime      -- display the current RAC time
 getsel          -- display records from the System Event Log (SEL)
 getssninfo      -- display session information
 getsvctag       -- display service tag information
 getsysinfo      -- display general RAC and system information
 gettracelog     -- display the RAC diagnostic trace log
 ifconfig        -- display network interface information
 netstat         -- display routing table and network statistics
 ping            -- send ICMP echo packets on the network
 racdump         -- display RAC diagnostic information
 racreset        -- perform a RAC reset operation
 racresetcfg     -- restore the RAC configuration to factory defaults
 serveraction    -- perform system power management operations
 setniccfg       -- modify network configuration properties
 sslcertview     -- view SSL certificate information
 sslcsrgen       -- generate a certificate CSR from the RAC
 testemail       -- test RAC e-mail notifications
 testtrap        -- test RAC SNMP trap notifications
 version         -- display the version info of RACADM
 vmdisconnect    -- disconnect virtual media connections
 vmkey           -- perform virtual media key operations
 usercertview    -- view user certificate information
```

```shell
$ racadm racreset
RAC reset operation initiated successfully. It may take up to a minute
for the RAC to come back online again.
```

# IDRAC 6

```shell
/admin1-> racadm  getsysinfo

RAC Information:
RAC Date/Time           = 02/28/2018 12:20:46
Firmware Version        = 1.85
Firmware Build          = 03
Last Firmware Update    = 05/09/2012 21:57:48
Hardware Version        = 0.01
MAC Address             = d4:ae:52:12:34:56

Common settings:
Register DNS RAC Name   = 1
DNS RAC Name            = srv01
Current DNS Domain      = mydomain.org
Domain Name from DHCP   = 0

IPv4 settings:
Enabled                 = 1
Current IP Address      = 192.168.0.124
Current IP Gateway      = 192.168.0.1
Current IP Netmask      = 255.255.255.0
DHCP Enabled            = 0
Current DNS Server 1    = 8.8.8.8
Current DNS Server 2    = 8.8.8.8
DNS Servers from DHCP   = 0

IPv6 settings:
Enabled                 = 0
Current IP Address 1    = ::
Current IP Gateway      = ::
Autoconfig              = 1
Link Local IP Address   = ::
Current IP Address 2    = ::
Current IP Address 3    = ::
Current IP Address 4    = ::
Current IP Address 5    = ::
Current IP Address 6    = ::
Current IP Address 7    = ::
Current IP Address 8    = ::
Current IP Address 9    = ::
Current IP Address 10   = ::
Current IP Address 11   = ::
Current IP Address 12   = ::
Current IP Address 13   = ::
Current IP Address 14   = ::
Current IP Address 15   = ::
DNS Servers from DHCPv6 = 0
Current DNS Server 1    = ::
Current DNS Server 2    = ::

System Information:
System Model            = PowerEdge R710
System Revision         = II
System BIOS Version     = 6.1.0
Service Tag             = 8Y51C5K
Express Svc Code        = 17301123456
Host Name               = srv01
OS Name                 =
Power Status            = ON

Embedded NIC MAC Addresses:
NIC1 Ethernet           = d4:ae:52:12:34:01
     iSCSI              = d4:ae:52:12:34:02
NIC2 Ethernet           = d4:ae:52:12:34:03
     iSCSI              = d4:ae:52:12:34:04
NIC3 Ethernet           = d4:ae:52:12:34:05
     iSCSI              = d4:ae:52:12:34:06
NIC4 Ethernet           = d4:ae:52:12:34:07
     iSCSI              = d4:ae:52:12:34:08

Watchdog Information:
Recovery Action         = None
Present countdown value = 15 seconds
Initial countdown value = 15 seconds

/admin1-> racadm help
 help [subcommand]    -- display usage summary for a subcommand
 arp                  -- display the networking ARP table
 clearasrscreen       -- clear the last ASR (crash) screen
 closessn             -- close a session
 clrraclog            -- clear the RAC log
 clrsel               -- clear the System Event Log (SEL)
 config               -- modify RAC configuration properties
 coredump             -- display the last RAC coredump
 coredumpdelete       -- delete the last RAC coredump
 fwupdate             -- update the RAC firmware
 getconfig            -- display RAC configuration properties
 getled               -- Get the state of the LED on a module.
 getniccfg            -- display current network settings
 getraclog            -- display the RAC log
 getractime           -- display the current RAC time
 getsel               -- display records from the System Event Log (SEL)
 getssninfo           -- display session information
 getsvctag            -- display service tag information
 getsysinfo           -- display general RAC and system information
 gettracelog          -- display the RAC diagnostic trace log
 getversion           -- Display the current version details
 getuscversion        -- display the current USC version details
 ifconfig             -- display network interface information
 kmcselfsignedcertgen -- generate self signed certificate for KMC Server
 netstat              -- display routing table and network statistics
 ping                 -- send ICMP echo packets on the network
 ping6                -- send ICMP echo packets on the network
 racdump              -- display RAC diagnostic information
 racreset             -- perform a RAC reset operation
 racresetcfg          -- restore the RAC configuration to factory defaults
 remoteimage          -- make a remote ISO image available to the server
 serveraction         -- perform system power management operations
 setniccfg            -- modify network configuration properties
 setled               -- Set the state of the LED on a module.
 sshpkauth            -- manage SSH PK authentication keys on the RAC
 sslcertview          -- view SSL certificate information
 sslcsrgen            -- generate a certificate CSR from the RAC
 sslresetcfg          -- resets the web certificate to default and restarts the web server.
 testemail            -- test RAC e-mail notifications
 testkmsconnectivity  -- test KMSConnectivity
 testtrap             -- test RAC SNMP trap notifications
 usercertview         -- view user certificate information
 vflashpartition      -- manage partitions on the vFlash SD card
 vflashsd             -- perform vFlash SD Card initialization
 vmdisconnect         -- disconnect Virtual Media connections
 vmkey                -- perform vFlash operations


racadm getconfig -h
racadm getconfig -g idRacInfo
racadm getconfig -g cfgLanNetworking
racadm getconfig -g cfgRemoteHosts
racadm getconfig -g cfgUserAdmin
racadm getconfig -g cfgEmailAlert
racadm getconfig -g cfgKmsProfile
racadm getconfig -g cfgSessionManagement
racadm getconfig -g cfgSerial
racadm getconfig -g cfgNetTuning
racadm getconfig -g cfgOobSnmp
racadm getconfig -g cfgRacTuning
racadm getconfig -g ifcRacManagedNodeOs
racadm getconfig -g cfgRacSecurityData
racadm getconfig -g cfgRacVirtual
racadm getconfig -g cfgActiveDirectory
racadm getconfig -g cfgLDAP
racadm getconfig -g cfgLdapRoleGroup
racadm getconfig -g cfgLogging
racadm getconfig -g cfgStandardSchema
racadm getconfig -g cfgIpmiSerial
racadm getconfig -g cfgIpmiSol
racadm getconfig -g cfgIpmiLan
racadm getconfig -g cfgIpmiPef
racadm getconfig -g cfgIpmiPet
racadm getconfig -g cfgIPv6LanNetworking
racadm getconfig -g cfgIPv6URL
racadm getconfig -g cfgServerPower
racadm getconfig -g cfgServerPowerSupply
racadm getconfig -g cfgVFlashSD
racadm getconfig -g cfgVFlashPartition
racadm getconfig -g cfgUserDomain
racadm getconfig -g cfgSmartCard
racadm getconfig -g cfgIpmiPetIPv6
racadm getconfig -g cfgServerInfo
racadm getconfig -g cfgSensorRedundancy
```

