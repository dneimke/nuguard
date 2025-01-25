# Using NuGuard in Azure Pipelines

This guide demonstrates how to integrate NuGuard vulnerability scanning into your Azure DevOps pipelines.

## Pipeline Example

```yaml
// filepath: azure-pipelines.yml
trigger:
  - main

pool:
  vmImage: 'windows-latest'

variables:
  solution: '**/*.sln'
  buildPlatform: 'Any CPU'
  buildConfiguration: 'Release'

steps:
- task: PowerShell@2
  displayName: 'Install and Run NuGuard'
  inputs:
    targetType: 'inline'
    script: |
      # Clone NuGuard repository
      git clone https://github.com/dneimke/nuguard.git

      # Import module
      Import-Module .\nuguard\src\Modules\Nuguard\Nuguard.psm1 -Force

      # Scan solution for vulnerabilities
      $vulnerabilities = Get-PackageVulnerabilities -ProjectPath "$(System.DefaultWorkingDirectory)" -MinimumSeverity "High"

      # Fail build if critical/high vulnerabilities found
      if ($vulnerabilities) {
        Write-Host "##vso[task.LogIssue type=error;]Critical or High severity vulnerabilities found!"
        Write-Host "##vso[task.complete result=Failed;]"
      }

- task: PublishPipelineArtifact@1
  inputs:
    targetPath: '$(System.DefaultWorkingDirectory)/vulnerability-report.json'
    artifact: 'VulnerabilityReport'
    publishLocation: 'pipeline'# Using NuGuard in Azure Pipelines
```

## Usage Instructions

### 1. Add the Pipeline

- Create a new pipeline in Azure DevOps
- Choose "Azure Repos Git" as your source
- Select your repository
- Choose "Existing Azure Pipelines YAML file"
- Select the path to your pipeline YAML

### 2. Configure Variables (Optional)

```yaml
variables:
  minimumSeverity: 'High'  # Can be Critical, High, Moderate, Low, or All
  projectPath: '**/*.csproj'  # Path pattern to scan
```

### 3. Advanced Configuration

You can enhance the pipeline by adding custom conditions or thresholds:

```yaml
steps:
- task: PowerShell@2
  inputs:
    targetType: 'inline'
    script: |
      # Set error threshold
      $maxAllowedVulnerabilities = 0

      # Import and run NuGuard
      Import-Module .\nuguard\src\Modules\Nuguard\Nuguard.psm1 -Force
      $vulnerabilities = Get-PackageVulnerabilities -ProjectPath "$(projectPath)" -MinimumSeverity "$(minimumSeverity)"

      # Export results
      $vulnerabilities | ConvertTo-Json | Out-File "vulnerability-report.json"

      # Fail if threshold exceeded
      if ($vulnerabilities.Count -gt $maxAllowedVulnerabilities) {
        Write-Host "##vso[task.LogIssue type=error;]Vulnerability threshold exceeded!"
        Write-Host "##vso[task.complete result=Failed;]"
      }
```

## Pipeline Variables

| Variable | Description | Default Value | Required |
|----------|-------------|---------------|----------|
| `System.DefaultWorkingDirectory` | Root directory on build agent | _Set by Azure_ | No |
| `solution` | Solution file pattern to scan | `**/*.sln` | No |
| `buildPlatform` | Target build platform | `Any CPU` | No |
| `buildConfiguration` | Build configuration | `Release` | No |
| `minimumSeverity` | Minimum vulnerability severity | `High` | No |
| `nuguardVersion` | Version of NuGuard to use | `latest` | No |
| `failOnFindings` | Whether to fail build on findings | `true` | No |
| `reportPath` | Path to save vulnerability report | `$(Build.ArtifactStagingDirectory)` | No |

## Usage Example

```yaml
// filepath: azure-pipelines.yml
variables:
  minimumSeverity: 'Critical'  # Only fail on Critical vulnerabilities
  failOnFindings: true         # Fail pipeline if vulnerabilities found
  reportPath: '$(Build.ArtifactStagingDirectory)/security/nuguard-report.json'
```

## Error Codes

- Exit Code 0: No vulnerabilities found
- Exit Code 1: Vulnerabilities found
- Exit Code 2: Scan error
