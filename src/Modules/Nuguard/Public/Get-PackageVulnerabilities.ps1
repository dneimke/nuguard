
function Get-DotnetVulnerabilities {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectPath,
        [ValidateSet('Critical', 'High', 'Moderate', 'Low', 'All')]
        [string]$MinimumSeverity = 'All'
    )

    try {
        # Run dotnet list package --vulnerable and capture output
        $vulnerabilityReport = dotnet list $ProjectPath package --vulnerable | Out-String



        # If no vulnerabilities found, return early
        if ($vulnerabilityReport -match "has no vulnerable packages given the current sources") {
            Write-Host $vulnerabilityReport -ForegroundColor Green
            return $null
        }

        # Parse the vulnerability report
        $vulnerabilities = @()
        $currentPackage = $null
        $lines = $vulnerabilityReport -split "`n"

        foreach ($line in $lines) {
            if ($line -match '>\s*(.*?)\s*\[(.*?)\]') {
                $currentPackage = @{
                    Name = $matches[1].Trim()
                    Version = $matches[2].Trim()
                    Vulnerabilities = @()
                }
                $vulnerabilities += $currentPackage
            }
            elseif ($line -match '\s*\[(.+?)\]\s*(.+?)\s*\((.*?)\)') {
                if ($currentPackage) {
                    $currentPackage.Vulnerabilities += @{
                        Severity = $matches[1].Trim()
                        Description = $matches[2].Trim()
                        Advisory = $matches[3].Trim()
                    }
                }
            }
        }

        # Filter by minimum severity if specified
        if ($MinimumSeverity -ne 'All') {
            $severityLevels = @('Critical', 'High', 'Moderate', 'Low')
            $minimumIndex = $severityLevels.IndexOf($MinimumSeverity)

            $vulnerabilities = $vulnerabilities | ForEach-Object {
                $package = $_
                $package.Vulnerabilities = $package.Vulnerabilities | Where-Object {
                    $severityIndex = $severityLevels.IndexOf($_.Severity)
                    $severityIndex -le $minimumIndex
                }
                if ($package.Vulnerabilities.Count -gt 0) {
                    $package
                }
            } | Where-Object { $_ -ne $null }
        }

        # Format and display the report
        if ($vulnerabilities.Count -gt 0) {
            Write-Host "❌ Vulnerable packages found:" -ForegroundColor Red
            foreach ($package in $vulnerabilities) {
                Write-Host "`nPackage: $($package.Name) [$($package.Version)]" -ForegroundColor Yellow
                foreach ($vuln in $package.Vulnerabilities) {
                    $severityColor = switch ($vuln.Severity) {
                        'Critical' { 'Red' }
                        'High' { 'DarkRed' }
                        'Moderate' { 'Yellow' }
                        'Low' { 'DarkYellow' }
                        default { 'White' }
                    }
                    Write-Host "  [$($vuln.Severity)] $($vuln.Description)" -ForegroundColor $severityColor
                    Write-Host "   └─ Advisory: $($vuln.Advisory)" -ForegroundColor Gray
                }
            }
        }

        return $vulnerabilities
    }
    catch {
        Write-Error "Error scanning for vulnerabilities: $_"
        return $null
    }
}

# Export the function
Export-ModuleMember -Function Get-DotnetVulnerabilities
