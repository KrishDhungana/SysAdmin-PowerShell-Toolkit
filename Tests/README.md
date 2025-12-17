# Tests Toolkit

Pester tests for validating all scripts across ActiveDirectory, ExchangeOnline, Microsoft365, and Teams modules. Ensures scripts work before production use.

## Prerequisites
- Pester module: `Install-Module Pester -Force`
- Mock environments configured in `/Tests/Mocks/`
- PowerShell 7+ recommended for cross-version testing

## Quick Start
```
# Run all tests
Invoke-Pester

# Run specific module tests
Invoke-Pester -Path "ActiveDirectory.Tests.ps1"

# CI/CD usage (GitHub Actions)
Invoke-Pester -Output Detailed -PassThru | Export-Junit -Path "test-results.xml"
```

## Test Files
- **ActiveDirectory.Tests.ps1** - UserQueries, GroupMembership, DomainHealth validation
- **ExchangeOnline.Tests.ps1** - MailboxStats, MessageTrace mocks
- **Microsoft365.Tests.ps1** - EntraUserSync, ConditionalAccess Graph mocks
- **Teams.Tests.ps1** - TeamSearch, UserPolicies validation
- **Utilities.Tests.ps1** - Cross-module helpers

## Usage Examples
```
# Test single script with mocks
Invoke-Pester "ActiveDirectory/UserQueries.Tests.ps1" -Verbose

# Generate coverage report
Invoke-Pester -CodeCoveragePath "../ActiveDirectory/*.ps1" -CoverageReport html -CoverageOut "coverage.html"

# Fail-fast for CI
Invoke-Pester -Exit $LASTEXITCODE
```

## Pro Tips
- Tests use `Mock` for safe production simulation (no real AD/EXO calls)
- `-WhatIf` parameter testing included for bulk operations
- GitHub Actions workflow auto-runs on PRs (`/.github/workflows/pester.yml`)
- Coverage targets: 80%+ per module

Run `Invoke-Pester` before every push to catch issues early.