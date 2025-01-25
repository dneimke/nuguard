BeforeAll {
    $modulePath = Join-Path $PSScriptRoot "../../../src/Modules/Nuguard/Nuguard.psd1"
    Import-Module $modulePath -Force -Verbose

    # Verify function is loaded
    Write-Verbose "Available functions:"
    Get-Command -Module Nuguard | ForEach-Object { Write-Verbose $_.Name }
}

Describe "Get-PubVulnerabilities" {
    Context "YAML Parsing" {
        BeforeAll {
            $testYaml = @"
name: test_app
description: A test Flutter application
version: 1.0.0

dependencies:
  flutter:
    sdk: flutter

  # A widely used package for making HTTP requests
  http: ^1.1.0

  # A popular state management library
  provider: ^6.0.5

  # Cupertino (iOS-style) widgets (you might not need this if you're only targeting Android)
  cupertino_icons: ^1.0.2
"@
            $testPath = "TestDrive:\pubspec.yaml"
            Set-Content -Path $testPath -Value $testYaml

            Mock -ModuleName Nuguard Get-OsvVulnerabilities { return @() }
        }

        It "Should parse string version dependencies" {

            $result = Get-PubVulnerabilities -ProjectPath "TestDrive:\"

            Should -Invoke -ModuleName "Nuguard" -CommandName "Get-OsvVulnerabilities" -ParameterFilter {
                $Package -eq 'http' -and $Version -eq '^1.1.0'
            }
        }

        It "Should parse SDK dependencies" {

            $result = Get-PubVulnerabilities -ProjectPath "TestDrive:\"

            Should -Invoke -ModuleName "Nuguard" -CommandName "Get-OsvVulnerabilities" -ParameterFilter {
                $Package -eq 'flutter'
            }
        }

        It "Should handle missing pubspec.yaml" {
            $result = Get-PubVulnerabilities -ProjectPath "TestDrive:\NonExistent"
            $result | Should -Be $null
        }

        It "Should throw an exception when YAML is invalid" {
            Set-Content -Path $testPath -Value "invalid: yaml: content:"
            { Get-PubVulnerabilities -ProjectPath "TestDrive:\" } | Should -Throw
        }
    }
}
