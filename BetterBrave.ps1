# BetterBrave: A PowerShell script to manage Brave browser policies
# Author: aaxyat
# Version: 0.1.0

param()

# Function to display help information and command usage
function Show-Help {
    Write-Host "Usage: .\BetterBrave.ps1 [OPTIONS]" -ForegroundColor White
    Write-Host "`nOptions:"
    Write-Host "  --help     Show this help message" -ForegroundColor Gray
    Write-Host "  --dry-run  Show what changes would be made without applying them" -ForegroundColor Gray
    Write-Host "  --revert   Revert policies to Brave browser defaults" -ForegroundColor Gray
    Write-Host "  --default  Remove all policy settings completely" -ForegroundColor Gray
    Write-Host "`nExamples:" -ForegroundColor White
    Write-Host "  .\BetterBrave.ps1              # Apply restrictive policies" -ForegroundColor Gray
    Write-Host "  .\BetterBrave.ps1 --dry-run    # Show what changes would be made" -ForegroundColor Gray
    Write-Host "  .\BetterBrave.ps1 --revert     # Restore default settings" -ForegroundColor Gray
    Write-Host "  .\BetterBrave.ps1 --default    # Remove all policies" -ForegroundColor Gray
    exit 0
}

# Function to handle self-elevation
function Start-ElevatedSession {
    param([string[]]$Arguments)
    
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        try {
            $argList = $Arguments -join " "
            Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $argList"
            exit
        }
        catch {
            Write-Host "Error: Failed to elevate privileges. Please run as Administrator." -ForegroundColor Red
            exit 1
        }
    }
}

# Parse command line arguments first
$revert = $false
$default = $false
$dryRun = $false
$invalidFlag = $false
$invalidFlagName = ""

foreach ($arg in $args) {
    switch ($arg) {
        "--revert" { $revert = $true }
        "--default" { $default = $true }
        "--dry-run" { $dryRun = $true }
        "--help" { Show-Help }
        default {
            if ($arg.StartsWith("--")) {
                $invalidFlag = $true
                $invalidFlagName = $arg
            }
        }
    }
}

# Check for elevation if not in dry-run mode
if (-not $dryRun) {
    Start-ElevatedSession $args
}

# Display ASCII art logo and welcome message
Write-Host @"
 ____     ___ ______  ______    ___  ____       ____   ____  __ __    ___ 
|    \   /  _]      ||      |  /  _]|    \     |    \ |    \|  |  |  /  _]
|  o  ) /  [_|      ||      | /  [_ |  D  )    |  o  )|  D  )  |  | /  [_ 
|     ||    _]_|  |_||_|  |_||    _]|    /     |     ||    /|  |  ||    _]
|  O  ||   [_  |  |    |  |  |   [_ |    \     |  O  ||    \|  :  ||   [_ 
|     ||     | |  |    |  |  |     ||  .  \    |     ||  .  \\   / |     |
|_____||_____| |__|    |__|  |_____||__|\_|    |_____||__|\_| \_/  |_____|
                                                                          
"@ -ForegroundColor Cyan

Write-Host "BetterBrave: Brave like it should have been" -ForegroundColor Yellow
Write-Host "Version 0.1.0`n" -ForegroundColor Gray

# Handle invalid flags and mutually exclusive options
if ($invalidFlag) {
    Write-Host "Error: Invalid flag '$invalidFlagName'" -ForegroundColor Red
    Write-Host "Use --help to see available options" -ForegroundColor Yellow
    exit 1
}

if ($revert -and $default) {
    Write-Host "Error: Cannot use both --revert and --default flags together" -ForegroundColor Red
    exit 1
}

# Define default policy values (used when reverting changes)
$defaultPolicies = @{
    "BraveRewardsDisabled" = 0      # Enable Brave Rewards
    "BraveWalletDisabled" = 0       # Enable Crypto Wallet
    "BraveVPNDisabled" = 0          # Enable Brave VPN
    "BraveAIChatEnabled" = 1        # Enable AI features
    "PasswordManagerEnabled" = 1     # Enable password manager
    "HttpsUpgradesEnabled" = 1      # Enable HTTPS upgrades
    "BraveAdsEnabled" = 1           # Enable Brave Ads
    "BuiltInDnsClientEnabled" = 0   # Use system DNS
    "DnsOverHttpsMode" = "off"      # Disable DNS over HTTPS
    "DnsOverHttpsTemplates" = ""    # Clear DNS templates
}

# Define restrictive policy settings for enhanced privacy
$policies = @{
    "BraveRewardsDisabled" = 1      # Disable cryptocurrency rewards
    "BraveWalletDisabled" = 1       # Disable cryptocurrency wallet
    "BraveVPNDisabled" = 1          # Disable built-in VPN service
    "BraveAIChatEnabled" = 0        # Disable AI chat features
    "PasswordManagerEnabled" = 0     # Disable built-in password manager
    "HttpsUpgradesEnabled" = 0      # Disable automatic HTTPS upgrades
    "BraveAdsEnabled" = 0           # Disable Brave Ads
    "BuiltInDnsClientEnabled" = 1   # Use Brave's DNS client
    "DnsOverHttpsMode" = "secure"   # Force secure DNS mode
    "DnsOverHttpsTemplates" = '[{"providers":[{"template":"https://cloudflare-dns.com/dns-query"}]}]'  # Use Cloudflare DNS
}

# Registry path for Brave browser policies
$policyPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

# Handle dry run mode - show changes without applying
if ($dryRun) {
    Write-Host "DRY RUN MODE - No changes will be made" -ForegroundColor Yellow
    Write-Host "The following changes would be made:" -ForegroundColor Yellow
    if ($default) {
        Write-Host "Would remove all policies from: $policyPath"
    } elseif ($revert) {
        Write-Host "Would revert policies to default values:"
        foreach ($policy in $defaultPolicies.GetEnumerator()) {
            Write-Host "Would set: $($policy.Key) to $($policy.Value)"
        }
    } else {
        foreach ($policy in $policies.GetEnumerator()) {
            Write-Host "Would set: $($policy.Key) to $($policy.Value)"
        }
    }
    exit
}

# Main execution logic
if ($default) {
    # Remove all policy settings
    Write-Host "Removing all Brave policies..." -ForegroundColor Yellow
    if (Test-Path $policyPath) {
        try {
            Remove-Item -Path $policyPath -Recurse -Force
            Write-Host "`nAll policies have been removed successfully." -ForegroundColor Green
        }
        catch {
            Write-Host "Error removing policies: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "No policies found to remove." -ForegroundColor Yellow
    }
}
elseif ($revert) {
    # Revert to default Brave settings
    Write-Host "Reverting all policies to default values..." -ForegroundColor Yellow
    
    if (-not (Test-Path $policyPath)) {
        New-Item -Path $policyPath -Force | Out-Null
    }

    foreach ($policy in $defaultPolicies.GetEnumerator()) {
        try {
            if ($policy.Key -in @("DnsOverHttpsMode", "DnsOverHttpsTemplates")) {
                Set-ItemProperty -Path $policyPath -Name $policy.Key -Value $policy.Value -Type String -ErrorAction Stop
            } else {
                Set-ItemProperty -Path $policyPath -Name $policy.Key -Value $policy.Value -Type DWORD -ErrorAction Stop
            }
            Write-Host "Reverted policy: $($policy.Key) to default value: $($policy.Value)"
        }
        catch {
            Write-Host "Error reverting policy $($policy.Key): $_" -ForegroundColor Red
        }
    }
    Write-Host "`nAll policies have been reverted to default values." -ForegroundColor Green
}
else {
    # Apply restrictive policy settings
    if (-not (Test-Path $policyPath)) {
        New-Item -Path $policyPath -Force | Out-Null
        Write-Host "Created new policy directory"
    }

    foreach ($policy in $policies.GetEnumerator()) {
        try {
            $existing = Get-ItemProperty -Path $policyPath -Name $policy.Key -ErrorAction SilentlyContinue

            if ($null -eq $existing) {
                if ($policy.Key -in @("DnsOverHttpsMode", "DnsOverHttpsTemplates")) {
                    New-ItemProperty -Path $policyPath -Name $policy.Key -Value $policy.Value -PropertyType String -Force | Out-Null
                } else {
                    New-ItemProperty -Path $policyPath -Name $policy.Key -Value $policy.Value -PropertyType DWORD -Force | Out-Null
                }
                Write-Host "Created new policy: $($policy.Key) = $($policy.Value)"
            } else {
                Set-ItemProperty -Path $policyPath -Name $policy.Key -Value $policy.Value
                Write-Host "Updated existing policy: $($policy.Key) = $($policy.Value)"
            }
        }
        catch {
            Write-Host "Error setting policy $($policy.Key): $_" -ForegroundColor Red
        }
    }

    Write-Host "`nPolicy settings have been applied. Please restart Brave browser for changes to take effect." -ForegroundColor Green
}

# Wait for user input before exit
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')