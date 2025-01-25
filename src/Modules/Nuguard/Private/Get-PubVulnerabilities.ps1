function Get-PubVulnerabilities {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectPath,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Critical', 'High', 'Moderate', 'Low', 'All')]
        [string]$MinimumSeverity = 'All'
    )

    $vulnerabilities = @()
    $pubspecPath = Join-Path $ProjectPath "pubspec.yaml"

    if (-not (Test-Path $pubspecPath)) {
        Write-Warning "pubspec.yaml not found at: $pubspecPath"
        return $vulnerabilities
    }

    try {
        $content = Get-Content $pubspecPath -Raw
        $yaml = ConvertFrom-Yaml $content

        if ($yaml.dependencies) {
            foreach ($dep in $yaml.dependencies.GetEnumerator()) {
                $packageName = $dep.Name
                $version = if ($dep.Value -is [string]) { $dep.Value } else { $dep.Value.version }

                # Query OSV database for vulnerabilities
                $osvVulns = Get-OsvVulnerabilities -Package $packageName -Version $version -Ecosystem "Pub"

                foreach ($vuln in $osvVulns) {
                    if ((Test-VulnerabilitySeverity -Severity $vuln.severity -MinimumSeverity $MinimumSeverity)) {
                        $vulnerabilities += @{
                            package = $packageName
                            version = $version
                            severity = $vuln.severity
                            description = $vuln.description
                            advisory = $vuln.advisory_url
                        }
                    }
                }
            }
        }
    }
    catch {
        Write-Error "Error scanning Pub packages: $_"
    }

    return $vulnerabilities
}

Export-ModuleMember -Function Get-PubVulnerabilities
