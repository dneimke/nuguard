function Initialize-NuguardDependencies {
    [CmdletBinding()]
    param()

    $requiredModules = @(
        @{
            Name = "powershell-yaml"
            MinimumVersion = "0.4.2"
        }
    )

    foreach ($module in $requiredModules) {
        if (-not (Get-Module -ListAvailable -Name $module.Name)) {
            Write-Host "Installing required module: $($module.Name)..."
            Install-Module -Name $module.Name -Scope CurrentUser -Force -MinimumVersion $module.MinimumVersion
        }
    }
}

Export-ModuleMember -Function Initialize-NuguardDependencies
