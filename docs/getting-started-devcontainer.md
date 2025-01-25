# Getting Started with Development Containers

This project uses Development Containers (devcontainers) to provide a consistent development environment for all contributors.

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker](https://www.docker.com/get-started)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Container Features

Our devcontainer comes preconfigured with:

- Node.js and npm
- Git
- Common development tools and utilities
- Project-specific extensions and settings

## Getting Started

1. Clone the repository:

   ```pwsh
   git clone https://github.com/dneimke/nuguard.git
   cd nuguard
   ```

2. Open in VS Code:

   ```pwsh
   code .
   ```

3. When prompted, click "Reopen in Container" or use the command palette (F1):
   - Select "Dev Containers: Reopen in Container"

The first time you open the project, VS Code will build the development container. This may take a few minutes.

## Container Configuration

The devcontainer configuration is defined in `.devcontainer/devcontainer.json`. This includes:

- Base Docker image
- VS Code extensions to be installed
- Environment variables
- Port forwarding
- Mount points

## Common Tasks

### Rebuilding the Container

If you need to rebuild the container:

1. Open the command palette (F1)
2. Select "Dev Containers: Rebuild Container"

### Terminal Access

The integrated terminal in VS Code will automatically run inside the container.

### Installing Dependencies

Run npm commands as usual in the integrated terminal:

```pwsh
npm install
```

## Troubleshooting

If you encounter issues:

1. Check Docker is running
2. Try rebuilding the container
3. Verify your Docker resource settings
4. Check the VS Code Dev Containers extension is installed

For more information, see the [official Dev Containers documentation](https://code.visualstudio.com/docs/remote/containers).
