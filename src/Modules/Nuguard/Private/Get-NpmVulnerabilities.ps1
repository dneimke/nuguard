function Get-NpmVulnerabilities {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectPath,
        [ValidateSet('Critical', 'High', 'Moderate', 'Low', 'All')]
        [string]$MinimumSeverity = 'All'
    )

    try {
        # Run npm audit and capture JSON output
        $auditOutput = npm audit --json --prefix $ProjectPath 2>$null
        $auditReport = $auditOutput | ConvertFrom-Json

        # Parse vulnerabilities
        $vulnerabilities = @()

        if ($auditReport.vulnerabilities) {
            foreach ($vuln in $auditReport.vulnerabilities.PSObject.Properties) {
                $vulnerability = @{
                    Name = $vuln.Name
                    Version = $vuln.Value.version
                    Vulnerabilities = @(
                        @{
                            Severity = $vuln.Value.severity
                            Description = $vuln.Value.title
                            Advisory = $vuln.Value.url
                        }
                    )
                }
                $vulnerabilities += $vulnerability
            }
        }

        # Filter by severity
        if ($MinimumSeverity -ne 'All') {
            $severityLevels = @('Critical', 'High', 'Moderate', 'Low')
            $minimumIndex = $severityLevels.IndexOf($MinimumSeverity)

            $vulnerabilities = $vulnerabilities | Where-Object {
                $severityIndex = $severityLevels.IndexOf($_.Vulnerabilities[0].Severity)
                $severityIndex -le $minimumIndex
            }
        }

        return $vulnerabilities
    }
    catch {
        Write-Error "Error scanning for NPM vulnerabilities: $_"
        return $null
    }
}

Export-ModuleMember -Function Get-NpmVulnerabilities