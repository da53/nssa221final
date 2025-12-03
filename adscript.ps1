#
# Interactive Windows PowerShell script for AD DS Deployment (Windows Server 2025)
#

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   Windows Server 2025 - AD installer frfr  " -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

# 1. Prompt for Domain Names
$DomainName = Read-Host "Please enter the FQDN for the new domain (e.g., esd3997.com)"

$NetbiosName = Read-Host "Please enter the NetBIOS name (e.g., ESD3997)"
$NetbiosName = $NetbiosName.ToUpper()

# 2. Set Defaults for Paths (No prompts)
$DbPath     = "C:\WINDOWS\NTDS"
$LogPath    = "C:\WINDOWS\NTDS"
$SysvolPath = "C:\WINDOWS\SYSVOL"

# 3. Review Configuration
Write-Host "----------------------------------------------" -ForegroundColor Green
Write-Host "Review your settings:"
Write-Host "Domain Name:  $DomainName"
Write-Host "NetBIOS Name: $NetbiosName"
Write-Host "Forest Mode:  Win2025"
Write-Host "Paths:        Default (C:\Windows\NTDS & SYSVOL)"
Write-Host "----------------------------------------------" -ForegroundColor Green

$confirmation = Read-Host "Type 'Y' to continue with installation and REBOOT, or 'N' to cancel"

if ($confirmation -eq 'Y') {
    
    Write-Host "Importing ADDSDeployment Module..."
    Import-Module ADDSDeployment

    # Note: The command will automatically prompt you for the Safe Mode Password
    $ADParams = @{
        CreateDnsDelegation  = $false
        DatabasePath         = $DbPath
        DomainMode           = "Win2025"
        DomainName           = $DomainName
        DomainNetbiosName    = $NetbiosName
        ForestMode           = "Win2025"
        InstallDns           = $true
        LogPath              = $LogPath
        NoRebootOnCompletion = $false
        SysvolPath           = $SysvolPath
        Force                = $true
    }

    Write-Host "Starting Installation... The server will reboot automatically." -ForegroundColor Cyan
    
    # Run the command
    Install-ADDSForest @ADParams

} else {
    Write-Host "Installation Cancelled." -ForegroundColor Red
}