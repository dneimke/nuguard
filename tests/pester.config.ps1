@{
    Run = @{
        Path = "./tests"
        Exit = $true
        PassThru = $true
    }
    Filter = @{
        Tag = ''
        ExcludeTag = ''
    }
    CodeCoverage = @{
        Enabled = $true
        Path = './src/*.ps1'
        OutputFormat = 'JaCoCo'
        OutputPath = './coverage/coverage.xml'
        CoveragePercentTarget = 80
    }
    TestResult = @{
        Enabled = $true
        OutputFormat = 'NUnitXml'
        OutputPath = './testResults/tests.xml'
    }
    Output = @{
        Verbosity = 'Detailed'
        StackTraceVerbosity = 'Full'
        CIFormat = 'Auto'
    }
    Debug = @{
        ShowNavigationMarkers = $false
    }
}
