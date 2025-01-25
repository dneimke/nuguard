@{
    RootModule = 'Nuguard.psm1'
    ModuleVersion = '0.1.0'
    GUID = 'f1b1b3b4-0b3b-4b3b-8b3b-0b3b0b3b0b3b'
    Author = 'Darren Neimke'
    Description = 'A PowerShell module for scanning .NET projects for vulnerable NuGet packages'
    PowerShellVersion = '5.1'
    FunctionsToExport = '*'
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