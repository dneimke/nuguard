@{
    RootModule = 'Nuguard.psm1'
    ModuleVersion = '0.1.0'
    GUID = [System.Guid]::NewGuid().ToString()
    Author = 'Darren Neimke'
    Description = 'A PowerShell module for scanning .NET projects for vulnerable NuGet packages'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Get-DotnetVulnerabilities',
        'Get-NpmVulnerabilities',
        'Invoke-VulnerabilityScanner',
        'Invoke-NuguardScan'
    )
    CmdletsToExport = @()
    VariablesToExport = '*'
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('Security', 'NuGet', 'Vulnerability', 'Scanning')
            LicenseUri = 'https://github.com/dneimke/nuguard/blob/main/LICENSE'
            ProjectUri = 'https://github.com/dneimke/nuguard'
        }
    }
}