function Get-fnGpoXmlAcl {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Object]$securityDescriptor
    )
    return @(
        [PSCustomObject]@{
            Name            = $securityDescriptor.Owner.Name.'#text'
            SID             = $securityDescriptor.Owner.SID.'#text'
            PermissionsType = 'Allow'
            Inherited       = $false
            Permissions     = 'Owner'
        }
        $securityDescriptor.Permissions.TrusteePermissions | ForEach-Object -Process {
            if($_){
                [PSCustomObject]@{
                    Name            = $_.trustee.name.'#text'
                    SID             = $_.trustee.SID.'#text'
                    PermissionsType = $_.type.PermissionType
                    Inherited       = $_.Inherited
                    Permissions     = $_.Standard.GPOGroupedAccessEnum
                }
            }
        }
    )
}