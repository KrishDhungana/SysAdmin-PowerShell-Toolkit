
# SysAdmin PowerShell Toolkit

!PowerShell
[CI
!License: MIT
!Issues

A curated collection of **battle‑tested PowerShell scripts** for system administrators. Focus areas include **Microsoft 365**, **Azure/Entra ID**, **Exchange Online**, **Intune**, **Windows Server**, and **Active Directory**—built for reliability, repeatability, and speed.

---

## Table of Contents

- Features
- Quick Start
- Repository Structure
- Prerequisites
- Usage Examples
- Configuration
- Best Practices
- Security Notes
- Contributing
- Code Style
- Roadmap
- Changelog
- License

---

## Features

- **M365/Entra ID**: License audits, user provisioning checks, MFA status, risky sign‑ins.
- **Exchange Online**: Mailbox health, GAL visibility, transport rules, shared mailbox automation.
- **Intune**: Device compliance, app deployments, autopilot status.
- **Windows/AD**: Fine‑grained password policies, GPO exports, user and group lifecycle.
- **Automation‑ready**: Consistent logging, idempotent operations, dry‑run modes.
- **Secure by default**: Least‑privilege tips, secrets via environment variables, safe error handling.

---

## Quick Start

```powershell
# 1) Clone the repo
git clone https://github.com/YOUR-ORG/YOUR-REPO.git
cd YOUR-REPO

# 2) Unblock scripts (Windows)
Get-ChildItem -Recurse *.ps1 | Unblock-File

# 3) Install required modules (you can pin versions in requirements.psd1)
pwsh -NoLogo -Command {
    $mods = @(
      'Microsoft.Graph',            # Graph SDK
      'ExchangeOnlineManagement',   # EXO
      'MicrosoftTeams',             # Teams admin
      'AzureAD'                     # Legacy; use Graph when possible
    )
    foreach ($m in $mods) { if (-not (Get-Module -ListAvailable $m)) { Install-Module $m -Scope CurrentUser -Force } }
}

# 4) Run something safely (dry-run when available)
.\Scripts\Exchange\Check-GALVisibility.ps1 -Identity user@contoso.com -Verbose

