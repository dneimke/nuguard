function Get-OsvVulnerabilities {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Package,

        [string]$Version,
        [Parameter(Mandatory = $true)]
        [string]$Ecosystem
    )

    $osvApiUrl = "https://api.osv.dev/v1/query"
    $body = @{
        package = @{
            name = $Package
            ecosystem = $Ecosystem
            version = $Version
        }
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $osvApiUrl -Method Post -Body $body -ContentType "application/json"
        return $response.vulns
    }
    catch {
        Write-Warning "Failed to query OSV database for $Package@$Version : $_"
        return @()
    }
}

Export-ModuleMember -Function Get-OsvVulnerabilities
