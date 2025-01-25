FROM mcr.microsoft.com/devcontainers/dotnet:7.0

# Install additional packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        git \
        curl \
        wget

# Install PowerShell modules
RUN pwsh -Command "Install-Module -Name Pester -Force -Scope AllUsers" \
    && pwsh -Command "Install-Module -Name powershell-yaml -Force -Scope AllUsers"

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
