
function Get-fnOrganizationalUnit {
    [CmdletBinding()]
    param()

    $cnt = 0
    try{
        $NetBiosName = (Get-fnDomain).NetBiosName
        $ouDetails = [ordered]@{}
        $OUs = Get-ADOrganizationalUnit -Filter * -Properties * 
        foreach($ou in $OUs){
            Write-Verbose "Working on $($ou)"
            
            $acl = Get-fnOrganizationalUnitAcl -DistinguishedName $ou.DistinguishedName -NetBiosName $NetBiosName
    
            $ouDetails.CanonicalName                    = $ou.CanonicalName
            $ouDetails.ProtectedFromAccidentalDeletion  = $ou.ProtectedFromAccidentalDeletion
            $ouDetails.Description                      = $ou.Description
            $ouDetails.Created                          = $ou.Created
            $ouDetails.Modified                         = $ou.Modified
            $ouDetails.Deleted                          = $ou.Deleted
            $ouDetails.DistinguishedName                = $ou.DistinguishedName
            $ouDetails.ManagedBy                        = $ou.ManagedBy
            $ouDetails.ObjectGuid                       = $ou.ObjectGuid
            $ouDetails.Owner                            = $acl.Owner
            $ouDetails.Group                            = $acl.Group
            $ouDetails.AreAccessRulesProtected          = $acl.AreAccessRulesProtected
            $ouDetails.AreAuditRulesProtected           = $acl.AreAuditRulesProtected
            $ouDetails.AreAccessRulesCanonical          = $acl.AreAccessRulesCanonical
            $ouDetails.AreAuditRulesCanonical           = $acl.AreAuditRulesCanonical
            $ouDetails.ExtendedAcl                      = $acl.Extended
            $ouDetails.ExtendedAclCount                 = $acl.ExtendedCount
            
            if($cnt -eq 3){
                break
            }
            $cnt++
        }
        
    
        return $ouDetails
    } catch {
        Write-Error "Failed getting Get-fnOrganizationalUnit: $($_.Exception.Message)"
    }
    
}

# (Get-fnOrganizationalUnit)#.ExtendedAcl[1]