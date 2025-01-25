# Adding a New Scanning Source

This guide explains how to add a new scanning source to the NuGuard project using a real-world example.

## Overview

A scanning source is responsible for fetching and analyzing security vulnerabilities from different providers or data sources. Let's walk through creating one using the NPM vulnerabilities scanner as an example.

## Implementation Steps

1. Create a new PowerShell function in `src/Modules/Nuguard/Private/`
2. Implement the vulnerability scanning logic
3. Add proper error handling and severity filtering
4. Export the function for module use

## Step-by-Step Guide

### 1. Create Scanner Function

Create a new PowerShell file (e.g., `Get-MyVulnerabilities.ps1`) in `src/Modules/Nuguard/Private/` with this structure:

```powershell
function Get-MyVulnerabilities {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectPath,
        [ValidateSet('Critical', 'High', 'Moderate', 'Low', 'All')]
        [string]$MinimumSeverity = 'All'
    )

    try {
        # Your scanning logic here
        $vulnerabilities = @()

        # Return standardized vulnerability objects
        return $vulnerabilities
    }
    catch {
        Write-Error "Error scanning for vulnerabilities: $_"
        return $null
    }
}

Export-ModuleMember -Function Get-MyVulnerabilities
```

### 2. Implement Required Interface

Your scanner should return vulnerabilities in this format:

```powershell
@{
    Name = "package-name"
    Version = "1.0.0"
    Vulnerabilities = @(
        @{
            Severity = "High"
            Description = "Vulnerability description"
            Advisory = "URL to advisory"
        }
    )
}
```

### 3. Error Handling and Filtering

Use the standard error handling pattern:
- Wrap main logic in try/catch
- Use Write-Error for error reporting
- Return $null on failure
- Support severity filtering using Test-VulnerabilitySeverity

## Example Implementation

See `Get-NpmVulnerabilities.ps1` for a complete reference:

```powershell
# Key implementation points:
# 1. Uses standard parameter validation
# 2. Executes external tool (npm audit)
# 3. Parses JSON output into standard format
# 4. Handles errors gracefully
# 5. Supports severity filtering
```

## Best Practices

- Use Parameter attributes for input validation
- Return standardized vulnerability objects
- Implement proper error handling
- Support minimum severity filtering
- Add detailed error messages
- Use Write-Error for error reporting
- Export your function using Export-ModuleMember

## Testing

1. Test your scanner with:
   - Valid project paths
   - Invalid project paths
   - Different severity levels
   - Error conditions
2. Verify output format matches the standard vulnerability object structure
3. Verify error handling works as expected
