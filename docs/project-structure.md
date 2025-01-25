# NuGuard Project Structure

## Directory Layout

```plaintext
📁 nuguard
├── 📁 src
│   └── 📁 Modules
│       └── 📁 Nuguard               # Main module folder
│           ├── Nuguard.psd1         # Module manifest
│           ├── Nuguard.psm1         # Module root
│           ├── 📁 Public            # Exported functions
│           └── 📁 Private           # Internal functions
├── 📁 build                         # Build scripts
├── 📁 tests
│   ├── 📁 Unit                      # Unit tests for private and public functions
├── 📁 docs                          # Documentation
└── 📁 .github
    └── 📁 workflows                # CI/CD pipelines
```
