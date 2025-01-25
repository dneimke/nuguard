# Testing Guide

This project uses Pester for PowerShell testing. All tests are located in the `tests` directory.

## Configuration

Tests are configured using `/tests/pester.config.ps1`, which sets up:
- Test execution paths and behavior
- Code coverage reporting (JaCoCo format)
- Test results output (NUnit XML format)
- Debugging options

## Running Tests

To run all tests:

```powershell
Invoke-Pester -Configuration (. ./tests/pester.config.ps1)
```

To run specific test files:

```powershell
Invoke-Pester ./tests/MySpecificTest.Tests.ps1 -Configuration (. ./tests/pester.config.ps1)
```

## Test Results

Test results are saved to:
- Test results: `./testResults/tests.xml`
- Code coverage: `./coverage/coverage.xml`

The configuration requires 80% code coverage minimum.

## Writing Tests

Place test files in the `tests` directory with the naming convention `*.Tests.ps1`. Example:

```powershell
Describe "My Function" {
    It "Should do something" {
        $result = My-Function
        $result | Should -Be "Expected Result"
    }
}
```
