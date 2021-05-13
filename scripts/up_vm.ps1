# Modules
# Install-Module -Name vmxtoolkit

# Variables
$vmrun = "E:\VMWare\vmrun.exe"
$vmware = "E:\VMware\vmware.exe"
$vm = "E:\Servers\Linux\vagrant-ansible\vagrant-ansible.vmx"
$ip = "192.168.0.33"
$port = "22"
$putty = "E:\Apps\Putty\putty.exe"

# Close SHH connectio
Write-Host "Kill SSH Connections" -BackgroundColor White -ForegroundColor Black
Get-Process -name putty -ErrorAction SilentlyContinue |
Stop-Process -ErrorAction SilentlyContinue >$null

# Power Off Virtual Machine
Write-Host "Power Off Virtual Machine: [$($vm)]" -BackgroundColor White -ForegroundColor Black
& $vmrun stop $vm >$null

# Down vmware if Running
Write-Host "Down Vmware Workstation in path: [$($vmware)]" -BackgroundColor White -ForegroundColor Black
Get-Process -name vmware -ErrorAction SilentlyContinue |
Stop-Process -ErrorAction SilentlyContinue >$null
Get-Process -name vmware-vmx -ErrorAction SilentlyContinue |
Stop-Process -ErrorAction SilentlyContinue >$null

# Set Memory
$vmxName = "vagrant-ansible"
$vmxConfig = (Get-VMX -VMXName $vmxName).Config
$memoryMB = "16384"
$processors = "6"
# SYNTAX: Set-VMXmemory [-VMXName <Object>] [-config <Object>] -MemoryMB <Int32> [<CommonParameters>]
Set-VMXmemory -VMXName $vmxName -config $vmxConfig -MemoryMB $memoryMB

# Set CPU
Set-VMXprocessor  -VMXName $vmxName -config $vmxConfig -Processorcount $processors

# Up vmware
Write-Host "Up Vmware Workstation in path: [$($vmware)]" -BackgroundColor White -ForegroundColor Black
& $vmware

# Power On Virtual Machine
Write-Host "Power On Virtual Machine: [$($vm)]" -BackgroundColor White -ForegroundColor Black
& $vmrun start $vm


# Check Status for SHH Connection
$tcp_test=$false
Write-Host "Check VM Status ..." -BackgroundColor White -ForegroundColor Black
While (!$tcp_test) {
    $tcp_test=(Test-NetConnection -ComputerName $ip -RemotePort $port).TcpTestSucceeded
    if ($tcp_test) {
        Write-Host "VM is Running!!!" -BackgroundColor White -ForegroundColor Green
        Start-Sleep 2
        break;
    }
    Else {
        Write-Host "VM in process of initialization...Waiting" -BackgroundColor White -ForegroundColor Black
        Start-Sleep 1
    }
}