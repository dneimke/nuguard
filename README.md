# Nuguard

[![Build Status](https://github.com/dneimke/nuguard/actions/workflows/test.yml/badge.svg)](https://github.com/dneimke/nuguard/actions/workflows/test.yml)
[![License](https://img.shields.io/github/license/dneimke/nuguard)](https://github.com/dneimke/nuguard/blob/main/LICENSE)

A powerful PowerShell module for scanning projects for vulnerable package dependencies across multiple ecosystems. While starting with .NET/NuGet, Nuguard provides a unified interface for vulnerability scanning across npm, NuGet, and other package providers. Get rich reporting, filtering, and integration features with a consistent experience regardless of your project type.

## Features

- 🔍 Deep scan for vulnerable NuGet packages across solution or project files
- 🎯 Customizable severity filtering (Critical, High, Moderate, Low)
- 🎨 Clear, colorized console output
- 📊 Detailed vulnerability reports with advisory links
- 🔄 Structured data output for CI/CD integration
- ⚡ Fast parallel scanning for solutions with multiple projects

## Quick Start

### Option 1: Using DevContainer (Recommended)

The fastest way to get started is using our pre-configured development container:

1. Install [VS Code](https://code.visualstudio.com/) and the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Clone and open the repository:
   ```bash
   git clone https://github.com/dneimke/nuguard.git
   code nuguard
   ```
3. Click "Reopen in Container" when prompted, or run `Ctrl/Cmd + Shift + P` → "Dev Containers: Reopen in Container"

The container comes with:

- .NET SDK pre-installed
- PowerShell and required modules
- Pre-configured VS Code settings
- All dependencies ready to go

### Option 2: Traditional Installation

If you prefer not to use DevContainers:

1. Ensure prerequisites are installed:

   ```powershell
   dotnet --version     # Should be 6.0 or higher
   $PSVersionTable.PSVersion  # Should be 5.1 or higher
   ```

2. Install Nuguard:
   ```powershell
   Install-Module -Name Nuguard -Scope CurrentUser
   ```

### Running Your First Scan

```powershell
# Scan current directory
Invoke-NuguardScan .

# Or scan with minimum severity
Invoke-NuguardScan . -MinimumSeverity High
```

## Common Usage Examples

```powershell
# Scan a specific solution
Invoke-NuguardScan -ProjectPath "./MySolution.sln"

# Export results to JSON
Invoke-NuguardScan . | ConvertTo-Json > vulnerabilities.json

# Pipeline integration example
$vulns = Invoke-NuguardScan -MinimumSeverity Critical
if ($vulns.Count -gt 0) {
    throw "Critical vulnerabilities found!"
}
```

## Troubleshooting

Common issues and solutions:

- **Error: Package source not found**
  Make sure you have access to nuget.org or your private feed

- **Scan taking too long**
  Use `-SkipRestore` if packages are already restored

- **No vulnerabilities shown**
  Check if `-MinimumSeverity` matches your expectations

## Configuration

Create `nuguard-config.json` in your project root to customize behavior:

```json
{
  "version": "1.0",
  "projectPaths": [
    {
      "name": "MyDotNetApp",
      "path": "src/MyDotNetApp",
      "type": "dotnet",
      "minimumSeverity": "Moderate"
    },
    {
      "name": "MyNodeApp",
      "path": "src/MyNodeApp",
      "type": "npm",
      "minimumSeverity": "High"
    }
  ],
  "defaultSettings": {
    "minimumSeverity": "High",
    "outputPath": "reports",
    "failOnFindings": true
  }
}
```

## Documentation

- [Getting Started Guide](docs/quick-start.md)
- [CI/CD Integration](docs/azure-devops-pipeline.md)
- [Advanced Configuration](docs/configuration.md)

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md).

## License

MIT License - See [LICENSE](LICENSE) for details.
