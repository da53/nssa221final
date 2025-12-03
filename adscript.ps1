#
# Interactive Windows PowerShell script for AD DS Deployment (Windows Server 2025)
#

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   Windows Server 2025 - Active Directory   " -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

# 1. Prompt for Domain Name
$DomainName = Read-Host "Please enter the FQDN for the new domain (e.g., esd3997.com)"

# 2. Prompt for NetBIOS Name (and force it to UpperCase)
$NetbiosName = Read-Host "Please enter the NetBIOS name (e.g., ESD3997)"
$NetbiosName = $NetbiosName.ToUpper()

# 3. Prompt for Paths (Press Enter to accept defaults)
$DbPathIn = Read-Host "Database Path [Default: C:\WINDOWS\NTDS]"
if ([string]::IsNullOrWhiteSpace($DbPathIn)) { $DbPath = "C:\WINDOWS\NTDS" } else { $DbPath = $DbPathIn }

$LogPathIn = Read-Host "Log Path [Default: C:\WINDOWS\NTDS]"
if ([string]::IsNullOrWhiteSpace($LogPathIn)) { $LogPath = "C:\WINDOWS\NTDS" } else { $LogPath = $LogPathIn }

$SysvolPathIn = Read-Host "Sysvol Path [Default: C:\WINDOWS\SYSVOL]"
if ([string]::IsNullOrWhiteSpace($SysvolPathIn)) { $SysvolPath = "C:\WINDOWS\SYSVOL" } else { $SysvolPath = $SysvolPathIn }

# 4. Review Configuration
Write-Host "----------------------------------------------" -ForegroundColor Green
Write-Host "Review your settings:"
Write-Host "Domain Name:  $DomainName"
Write-Host "NetBIOS Name: $NetbiosName"
Write-Host "Forest Mode:  Win2025"
Write-Host "Database:     $DbPath"
Write-Host "----------------------------------------------" -ForegroundColor Green

$confirmation = Read-Host "Type 'Y' to continue with installation and REBOOT, or 'N' to cancel"

if ($confirmation -eq 'Y') {
    
    Write-Host "Importing ADDSDeployment Module..."
    Import-Module ADDSDeployment

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