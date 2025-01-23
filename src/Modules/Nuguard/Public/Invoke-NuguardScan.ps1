function Invoke-NuguardScan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$ConfigPath = "nuguard-config.json",

        [Parameter(Mandatory = $false)]
        [string]$OutputPath = $null
    )

    # Validate and load config
    if (-not (Test-Path $ConfigPath)) {
        throw "Configuration file not found at: $ConfigPath"
    }

    $config = Get-Content $ConfigPath | ConvertFrom-Json

    # Create results collection
    $results = @{
        scanDate = (Get-Date).ToString('o')
        projects = @()
    }

    # Process each project
    foreach ($project in $config.projectPaths) {
        Write-Host "Scanning project: $($project.name)" -ForegroundColor Cyan

        $severity = if ($project.minimumSeverity) {
            $project.minimumSeverity
        } else {
            $config.defaultSettings.minimumSeverity
        }

        $vulnerabilities = Get-PackageVulnerabilities `
            -ProjectPath $project.path `
            -MinimumSeverity $severity

        $results.projects += @{
            name = $project.name
            path = $project.path
            severity = $severity
            vulnerabilities = $vulnerabilities
        }
    }

    # Determine output path
    $outputPath = if ($OutputPath) {
        $OutputPath
    } else {
        $config.defaultSettings.outputPath
    }

    # Ensure output directory exists
    if (-not (Test-Path $outputPath)) {
        New-Item -Path $outputPath -ItemType Directory -Force
    }

    # Save results
    $outputFile = Join-Path $outputPath "nuguard-scan-results.json"
    $results | ConvertTo-Json -Depth 10 | Out-File $outputFile

    return $results
}

Export-ModuleMember -Function Invoke-NuguardScan