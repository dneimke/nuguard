# Nuguard

A PowerShell module for scanning .NET projects for vulnerable NuGet packages. Provides enhanced reporting and filtering capabilities over the standard `dotnet list package --vulnerable` command.

## Features

- 🔍 Scan .NET projects for vulnerable NuGet packages
- 🎯 Filter vulnerabilities by severity level
- 🎨 Colorized console output for better readability
- 📊 Summary reports of findings
- 🔄 Returns structured data for pipeline integration

## Prerequisites

- .NET SDK 6.0 or later
- PowerShell 5.1 or later

## Installation

1. Clone this repository:

```powershell
git clone https://github.com/dneimke/nuguard.git
cd nuguard
```

2. Import the module:

```powershell
Import-Module ./NuguardModule
```

## Usage

### Using the PowerShell Module Directly

```powershell
# Scan current project for all vulnerabilities
Get-PackageVulnerabilities -ProjectPath .

# Scan specific project for only Critical and High severity vulnerabilities
Get-PackageVulnerabilities -ProjectPath "C:\path\to\project" -MinimumSeverity High
```

### Using the Convenience Script

```powershell
# Basic scan of current directory
.\Scan-Project.ps1

# Scan specific project
.\Scan-Project.ps1 -ProjectPath "C:\path\to\project"

# Scan for only high and critical vulnerabilities
.\Scan-Project.ps1 -MinimumSeverity High

# Combine both options
.\Scan-Project.ps1 -ProjectPath "C:\path\to\project" -MinimumSeverity Critical
```

## Severity Levels

The module supports the following severity levels (from highest to lowest):

- Critical
- High
- Moderate
- Low
- All (default)

## Example Output

```powershell
🔍 Scanning project for vulnerabilities...
Project path: C:\path\to\project
Minimum severity: High

❌ Vulnerable packages found:

Package: Newtonsoft.Json [12.0.2]
  [Critical] Remote Code Execution Vulnerability (CVE-2024-XXXXX)
   └─ Advisory: https://github.com/advisories/...

Package: System.Text.RegularExpressions [4.3.0]
  [High] Denial of Service (CVE-2024-XXXXX)
   └─ Advisory: https://github.com/advisories/...

📊 Summary:
Total vulnerable packages: 2
Total vulnerabilities: 2
```

## Integration

The `Get-PackageVulnerabilities` function returns structured data that can be used in pipelines or scripts:

```powershell
$results = Get-PackageVulnerabilities -ProjectPath .
if ($results) {
    $criticalVulnerabilities = $results |
        ForEach-Object { $_.Vulnerabilities } |
        Where-Object { $_.Severity -eq 'Critical' }
}
```

## Documentation

Detailed documentation is available in the `/docs` directory:

- [Project Structure](docs/project-structure.md) - Overview of the codebase organization
- [Azure Pipeline Usage](docs/azure-pipeline-usage.md) - Guide for integrating with Azure DevOps
- [Configuration Guide](docs/configuration.md) - Details on `nuguard-config.json` settings

For configuration examples and best practices, see the [example configurations](docs/configuration.md#examples).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
