# Import the module
Import-Module .\src\Modules\Nuguard\Nuguard.psm1

# Run scan using config file
$results = Invoke-NuguardScan -ConfigPath "nuguard-config.json"

# Run scan with custom output path
# $results = Invoke-NuguardScan -ConfigPath "nuguard-config.json" -OutputPath "custom-reports"

# Add summary at the end
if ($results) {
    $totalVulnerabilities = ($results | ForEach-Object { $_.Vulnerabilities.Count } | Measure-Object -Sum).Sum
    Write-Host "`n📊 Summary:" -ForegroundColor Cyan
    Write-Host "Total vulnerable packages: $($results.Count)" -ForegroundColor Yellow
    Write-Host "Total vulnerabilities: $totalVulnerabilities" -ForegroundColor Yellow
}
