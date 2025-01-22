[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$ProjectPath = ".",

    [Parameter(Position = 1)]
    [ValidateSet('Critical', 'High', 'Moderate', 'Low', 'All')]
    [string]$MinimumSeverity = 'All'
)

# Ensure we're in the correct directory (where the script is located)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Import the Nuguard module
$modulePath = Join-Path $scriptPath "src/Modules/Nuguard/Nuguard.psm1"
if (Test-Path $modulePath) {
    Import-Module $modulePath -Force
}
else {
    Write-Error "Could not find NuguardModule.psm1. Ensure it exists in the same directory as this script."
    exit 1
}

Write-Host "🔍 Scanning project for vulnerabilities..." -ForegroundColor Cyan
Write-Host "Project path: $ProjectPath" -ForegroundColor Gray
Write-Host "Minimum severity: $MinimumSeverity" -ForegroundColor Gray
Write-Host ""

# Run the vulnerability scan
$results = Get-PackageVulnerabilities -ProjectPath $ProjectPath -MinimumSeverity $MinimumSeverity

# Add summary at the end
if ($results) {
    $totalVulnerabilities = ($results | ForEach-Object { $_.Vulnerabilities.Count } | Measure-Object -Sum).Sum
    Write-Host "`n📊 Summary:" -ForegroundColor Cyan
    Write-Host "Total vulnerable packages: $($results.Count)" -ForegroundColor Yellow
    Write-Host "Total vulnerabilities: $totalVulnerabilities" -ForegroundColor Yellow
}
