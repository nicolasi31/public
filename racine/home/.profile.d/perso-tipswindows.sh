if [ ${PERSO_ENABLED} = 1 ] ; then
 tipswindows () {
  echo -e "Some Windows Tips:

### Registry ###
apt install chntpw

# To look into the relevant registry file mount the Windows disk and open it like so:
chntpw -e /media/windows/Windows/System32/config/SOFTWARE

# Now to get the decoded DigitalProductId enter this command:
dpi \Microsoft\Windows NT\CurrentVersion\DigitalProductId

wmic path SoftwareLicensingService get OA3xOriginalProductKey

### NetSH ###
netsh interface ipv4 show subinterfaces
       MTU  État détect supp O entrant  O sortant  Interface
----------  ---------------- ---------  ---------  -------------
4294967295                1          0       3380  Loopback Pseudo-Interface 1
      1500                1   84006150     579474  Ethernet
      1500                1          0       2855  vEthernet (Default Switch)

netsh interface ip set address name=\"Connexion au réseau local\" source=dhcp
netsh interface ip set address \"Connexion au réseau local\" static 10.0.0.1 255.0.0.0
netsh routing ip add rtmroute 192.168.0.0 255.255.255.0 \"Connexion au réseau local\"
route ADD 192.168.0.0 MASK 255.255.255.0 10.0.0.254
route DELETE 192.168.0.0 MASK 255.255.255.0 10.0.0.254
net start telnetd

netsh routing ip add persistentroute ?
netsh routing ip add rtmroute ?

netsh interface ipv4 set subinterface \"Ethernet\" mtu=1400 store=persistent
netsh interface ipv4 set subinterface \"vEthernet (Default Switch)\" mtu=1400 store=persistent

### URLs ###
https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
https://docs.microsoft.com/en-us/windows/wsl/install-win10


#############################################################

Hyper-V

https://www.faqforge.com/powershell/create-virtual-machine-using-powershell/

help New-VM
Get-Command -Module Hyper-V
Get-WindowsOptionalFeature -Online

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2


Stop-VM -Name vmtest01 -Force
Remove-VM -Name vmtest01 -Force
del C:\\\Users\\\user01\\\Downloads\\\vmtest01.vhdx

New-VM -Name vmtest01 -MemoryStartupBytes 4096MB -NewVHDPath C:\\\Users\\\user01\\\Downloads\\\vmtest01.vhdx -NewVHDSizeBytes 40GB -Generation 1 -BootDevice LegacyNetworkAdapter -SwitchName mon_reseau
Set-VMNetworkAdapter  -VMName vmtest01 -StaticMacAddress \"00155d000202\"
Set-VMDvdDrive -VMName vmtest01 -ControllerNumber 1 -Path C:\\\Users\\\user01\\\Downloads\\\debian-10.4.0-amd64-netinst.iso
Set-VMFirmware vmtest01 -EnableSecureBoot Off
Start-VM -Name vmtest01
vmconnect localhost vmtest01


#New-VHD -Path C:\\\Users\\\user01\\\Downloads\\\vmtest01.vhdx -SizeBytes 10GB -Dynamic
#Add-VMHardDiskDrive -VMName vmtest01 -path \"C:\\\Users\\\user01\\\Downloads\\\vmtest01.vhdx\"
"
 }
fi

