# Quick Start Guide

## Installation

```powershell
Install-Module Nuguard
```

## Basic Setup

1. Create a configuration file `nuguard-config.json` in your project root:

```json
{
    "version": "1.0",
    "projectPaths": [
        {
            "name": "MyApp",
            "path": "src/MyApp/MyApp.csproj",
            "type": "dotnet"
        }
    ],
    "defaultSettings": {
        "minimumSeverity": "High",
        "outputPath": "reports",
        "failOnFindings": true
    }
}
```

## Usage Examples

### Scanning Multiple Projects

```json
{
    "version": "1.0",
    "projectPaths": [
        {
            "name": "WebAPI",
            "path": "src/WebAPI/WebAPI.csproj",
            "type": "dotnet"
        },
        {
            "name": "Frontend",
            "path": "src/client",
            "type": "npm"
        }
    ]
}
```

### Running Scans

```powershell
# Run security scan
Start-NuguardScan

# Run with detailed logging
Start-NuguardScan -Verbose
```

## Common Issues & Troubleshooting

### Configuration Not Found
Make sure your `nuguard-config.json` is in the project root directory.

### Scan Not Working
- Verify project paths are correct
- Check if minimum severity levels are appropriate
- Run with verbose logging:
  ```powershell
  Start-NuguardScan -Verbose
  ```

## Next Steps

- Review [configuration options](./configuration.md) for detailed settings
- Check [supported project types](./configuration.md#project-types)
- Learn about [severity levels](./configuration.md#default-settings)
