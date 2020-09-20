**Windows Tips and Tricks**

[[_TOC_]]
# Usefull links
- [https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v "Enable HyperV on Windows 10 pro")
- [https://docs.microsoft.com/en-us/windows/wsl/install-win10](https://docs.microsoft.com/en-us/windows/wsl/install-win10 "Enable WSL2 (Windows Subsystem For Linux #2) on Windows 10 pro")

# Windows features management
```shell
# Get available Windows features
Get-WindowsOptionalFeature -Online

# Enable HyperV on Win 10 pro
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# Enable WSL2 on Win 10 pro
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2
```

# netsh
```shell
netsh interface ipv4 show subinterfaces

netsh interface ip set address name="Connexion au réseau local" source=dhcp
netsh interface ip set address "Connexion au réseau local" static 10.0.0.1 255.0.0.0
netsh routing ip add rtmroute 192.168.0.0 255.255.255.0 "Connexion au réseau local"
route ADD 192.168.0.0 MASK 255.255.255.0 10.0.0.254
route DELETE 192.168.0.0 MASK 255.255.255.0 10.0.0.254
net start telnetd

netsh interface ip set address "Réseau local" static 192.168.0.3 255.255.255.0 192.168.0.1 1

netsh routing ip add persistentroute 192.168.0.0 255.255.255.0 "Réseau local"

netsh interface ipv4 show subinterfaces
netsh interface ipv4 set subinterface “Ethernet” mtu=1518 store=persistent
```

# Retrieve Windows key from Linux
```shell
wmic path SoftwareLicensingService get OA3xOriginalProductKey

apt install chntpw

# To look into the relevant registry file mount the Windows disk and open it like so:
chntpw -e /media/windows/Windows/System32/config/SOFTWARE

# Now to get the decoded DigitalProductId enter this command:
dpi \Microsoft\Windows NT\CurrentVersion\DigitalProductId
```

# Hyper-V powershell management
- https://www.faqforge.com/powershell/create-virtual-machine-using-powershell/
```shell
Get-Command -Module Hyper-V
help New-VM

# vmtest1-start.ps1
New-VM -Name vmtest01 -MemoryStartupBytes 2048MB -NewVHDPath C:\Users\nicolas\Downloads\vmtest01.vhdx -NewVHDSizeBytes 20GB -Generation 2 -BootDevice NetworkAdapter -SwitchName WANNET
Set-VMFirmware vmtest01 -EnableSecureBoot Off
Set-VMNetworkAdapter -VMName vmtest01 -StaticMacAddress "00155d000202"
Start-VM -Name vmtest01
vmconnect localhost vmtest01

# vmtest1-delete.ps1 
Stop-VM -Name vmtest01 -Force
Remove-VM -Name vmtest01 -Force
del C:\Users\nicolas\Downloads\vmtest01.vhdx

Set-VMDvdDrive -VMName vmtest01 -ControllerNumber 1 -Path C:\Users\nicolas\Downloads\debian-10.4.0-amd64-netinst.iso

New-VHD -Path C:\Users\nicolas\Downloads\vmtest01.vhdx -SizeBytes 10GB -Dynamic
Add-VMHardDiskDrive -VMName vmtest01 -path "C:\Users\nicolas\Downloads\vmtest01.vhdx"
```
