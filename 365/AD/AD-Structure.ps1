
<# 
.SYNOPSIS
AD-Structure.ps1 – Quick discovery of on-prem Active Directory structure.

.DESCRIPTION
Outputs forest, domain, DCs, sites, OUs, trusts, and replication topology using core cmdlets:
Get-ADForest, Get-ADDomain, Get-ADDomainController, Get-ADReplication*, Get-ADOrganizationalUnit, Get-ADTrust, etc.
Each command includes a one-line explanation of what it does.

.PARAMETER Server
(Optional) A specific Domain Controller to target for queries (e.g., dc01.contoso.com).

.EXAMPLE
.\AD-Structure.ps1
.\AD-Structure.ps1 -Server dc01.contoso.com

.NOTES
Requires: RSAT + ActiveDirectory module
Author: Krish Dhungana
#>


# Get-ADForest – Displays forest-wide configuration (domains, sites, global catalogs, FSMO roles)
Get-ADForest | Select ForestMode, RootDomain, Domains, Sites, GlobalCatalogs

# Get-ADDomain – Shows domain-level details (functional level, DNS root, PDC/RID/Infra masters)
Get-ADDomain | Select Name, DomainMode, DnsRoot, PDCEmulator, RIDMaster

# Get-ADDomainController – Lists all domain controllers with site and role info
Get-ADDomainController -Filter * | Select HostName, Site, IPv4Address, IsGlobalCatalog

# Get-ADReplicationSite – Displays AD sites used for replication and service placement
Get-ADReplicationSite -Filter * | Select Name

# Get-ADReplicationSubnet – Lists subnets mapped to sites for client/DC location mapping
Get-ADReplicationSubnet -Filter * | Select Name, Site

# Get-ADReplicationSiteLink – Shows site links and replication costs/schedules
Get-ADReplicationSiteLink -Filter * | Select Name, SitesIncluded, Cost

# Get-ADRootDSE – Lists naming contexts (Schema, Configuration, Default)
Get-ADRootDSE | Select schemaNamingContext, configurationNamingContext, defaultNamingContext

# Get-ADOrganizationalUnit – Enumerates OUs (containers for objects and policy scoping)
Get-ADOrganizationalUnit -Filter * | Select Name, CanonicalName

# Get-ADTrust – Displays inter-domain/forest trust relationships
Get-ADTrust -Filter * | Select Name, Source, Target, Direction, TrustType

# Get-ADFineGrainedPasswordPolicy – Lists password settings objects (FGPP)
Get-ADFineGrainedPasswordPolicy -Filter * | Select Name, MinPasswordLength, MaxPasswordAge

