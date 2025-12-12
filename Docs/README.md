# Documentation

Central guides for connecting to services and multi-module troubleshooting workflows. Use these before running scripts in ActiveDirectory, ExchangeOnline, Teams, etc.

## Available Guides

- **[CONNECTIVITY.md](CONNECTIVITY.md)** - Module connection scripts and credential setup
- **[WORKFLOWS.md](WORKFLOWS.md)** - Cross-platform troubleshooting (user health checks, hybrid sync)

## Prerequisites (All Guides)
- PowerShell 5.1+ or PowerShell 7+
- Execution Policy: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- GitHub repo cloned locally

## Quick Navigation
| Guide | Purpose | When to Use |
|-------|---------|-------------|
| CONNECTIVITY.md | Service connections | First time setup, new PowerShell session |
| WORKFLOWS.md | Multi-tool sequences | User lockout across AD/Entra/Exchange |

Copy these files into your `/docs/` folder. Each guide links back to specific module READMEs and Commands.md files.
