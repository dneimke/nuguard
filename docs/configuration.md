# Configuration

NuGuard uses a `nuguard-config.json` configuration file to specify project settings and scanning behavior.

## Configuration File Location

Place the `nuguard-config.json` file in your repository's root directory.

## Configuration Structure

The configuration file contains the following main sections:

- `version`: The configuration schema version
- `projectPaths`: Array of projects to scan
- `defaultSettings`: Default settings applied to all projects

### Basic Example

```json
{
    "version": "1.0",
    "projectPaths": [
        {
            "name": "MyApp",
            "path": "src/MyApp/MyApp.csproj"
        }
    ],
    "defaultSettings": {
        "minimumSeverity": "High",
        "outputPath": "reports",
        "failOnFindings": true
    }
}
```

## Configuration Options

### Project Paths

Each project entry in `projectPaths` can include:

- `name`: Friendly name for the project
- `path`: Relative path to project file or directory
- `type`: Project type (`dotnet` or `npm` or `pub`), defaults to `dotnet`
- `minimumSeverity`: Override severity level for this project

### Project Types

NuGuard supports scanning different types of projects:

- `dotnet`: .NET projects (*.csproj, *.sln)
- `npm`: Node.js projects (package.json)
- `pub`: Dart/Flutter projects (pubspec.yaml)

### Default Settings

- `minimumSeverity`: Minimum severity level to report ("Low", "Medium", "High", "Critical")
- `outputPath`: Directory for scan reports
- `failOnFindings`: Whether to fail the build on security findings

### Advanced Example

```json
{
    "version": "1.0",
    "projectPaths": [
        {
            "name": "WebAPI",
            "path": "src/WebAPI/WebAPI.csproj",
            "type": "dotnet",
            "minimumSeverity": "Critical"
        },
        {
            "name": "Frontend",
            "path": "src/client",
            "type": "npm",
            "minimumSeverity": "High"
        },
        {
            "name": "MobileApp",
            "path": "src/mobile",
            "type": "pub",
            "minimumSeverity": "Medium"
        }
    ],
    "defaultSettings": {
        "minimumSeverity": "Medium",
        "outputPath": "security-reports",
        "failOnFindings": true
    }
}
```

## Usage

1. Create a nuguard-config.json file in your repository root
2. Add project paths to scan
3. Configure default settings
4. Run NuGuard to analyze projects based on configuration

NuGuard will use these settings to determine which projects to scan and how to handle security findings.
