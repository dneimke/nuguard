<#
.SYNOPSIS
    Performs security vulnerability scanning across projects based on configuration.

.DESCRIPTION
    Invoke-NuguardScan reads a JSON configuration file to scan one or more projects
    for security vulnerabilities. It supports customizable severity thresholds per project
    and generates a detailed JSON report of findings.

.PARAMETER ConfigPath
    Path to the JSON configuration file containing project and scan settings.
    Defaults to "nuguard-config.json" in the current directory.

.PARAMETER OutputPath
    Optional custom output path for scan results. If not specified, uses the path
    from the configuration file.

.EXAMPLE
    PS> Invoke-NuguardScan
    Scans projects using default config file (nuguard-config.json)

.EXAMPLE
    PS> Invoke-NuguardScan -ConfigPath "custom-config.json" -OutputPath "results"
    Scans projects using custom config file and outputs results to specified directory

.NOTES
    File Name      : Invoke-NuguardScan.ps1
    Prerequisite   : PowerShell 5.1 or later
    Copyright      : MIT License

.OUTPUTS
    System.Collections.Hashtable
    Returns a hashtable containing scan results including scan date and project vulnerabilities
#>

# Main function to perform security vulnerability scanning across .NET projects
function Invoke-NuguardScan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateScript({
            if (Test-Path $_) { $true }
            else { throw "Configuration file not found at: $_" }
        })]
        [string]
        [Parameter(HelpMessage = "Path to the JSON configuration file containing project and scan settings")]
        $ConfigPath = "nuguard-config.json",

        [Parameter(Mandatory = $false)]
        [string]
        [Parameter(HelpMessage = "Optional custom output path for scan results. If not specified, uses the path from config file")]
        $OutputPath = $null
    )

    # Load and parse JSON configuration
    $config = Get-Content $ConfigPath | ConvertFrom-Json

    # Initialize results object with scan metadata
    $results = @{
        scanDate = (Get-Date).ToString('o')  # ISO 8601 format for timestamp
        projects = @()                        # Array to store per-project results
    }

    # Iterate through each project defined in configuration
    foreach ($project in $config.projectPaths) {
        Write-Host "Scanning project: $($project.name)" -ForegroundColor Cyan

        # Determine severity threshold - use project-specific or fall back to default
        $severity = if ($project.minimumSeverity) {
            $project.minimumSeverity
        } else {
            $config.defaultSettings.minimumSeverity
        }

        # Determine project type - defaults to 'dotnet' if not specified
        $projectType = if ($project.type) { $project.type } else { 'dotnet' }

        # Execute vulnerability scan for current project
        $vulnerabilities = Invoke-VulnerabilityScanner `
            -ProjectPath $project.path `
            -ProjectType $projectType `
            -MinimumSeverity $severity

        # Add scan results to the collection
        $results.projects += @{
            name = $project.name
            path = $project.path
            severity = $severity
            vulnerabilities = $vulnerabilities
        }
    }

    # Determine output location - use parameter or fall back to config setting
    $outputPath = if ($OutputPath) {
        $OutputPath
    } else {
        $config.defaultSettings.outputPath
    }

    # Ensure output directory exists
    if (-not (Test-Path $outputPath)) {
        New-Item -Path $outputPath -ItemType Directory -Force
    }

    # Save results to JSON file
    $outputFile = Join-Path $outputPath "nuguard-scan-results.json"
    $results | ConvertTo-Json -Depth 10 | Out-File $outputFile

    # Return results object for potential further processing
    return $results
}

# Export the function for module usage
Export-ModuleMember -Function Invoke-NuguardScan