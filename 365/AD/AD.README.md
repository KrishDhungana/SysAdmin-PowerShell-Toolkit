
Active Directory remains a critical component for identity and access management in many organizations. These scripts help automate common tasks such as:
- User and group provisioning
- Password policy audits
- GPO exports
- Fine-Grained Password Policy (FGPP) checks
- AD health and replication status reports

---

## On-Prem AD Prerequisites
Before running these scripts, ensure:
- **Domain Controller** is installed and configured.
- **DNS** is properly set up (AD relies heavily on DNS).
- **Forest and Domain Functional Level** meet your requirements (usually Windows Server 2016 or higher for modern features).
- **Active Directory PowerShell Module** is installed:
  ```powershell
  Import-Module ActiveDirectory
