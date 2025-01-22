$projectRoot = Split-Path -Parent $PSScriptRoot
$folders = @(
    'src/Modules/Nuguard/Public',
    'src/Modules/Nuguard/Private',
    'tests/Unit',
    'tests/Integration',
    'docs',
    'build',
    '.github/workflows'
)

foreach ($folder in $folders) {
    $path = Join-Path -Path $projectRoot -ChildPath $folder
    if (!(Test-Path -Path $path)) {
        New-Item -Path $path -ItemType Directory -Force
        Write-Host "Created directory: $path" -ForegroundColor Green
    }
}