function Add-fnOrganizationalUnit {
    $organizationalUnits = Get-fnOrganizationalUnit -Verbose

    foreach($ou in $organizationalUnits)
    {
        Add-spOrganizationalUnit -organizational_unit $ou -Verbose
        foreach($acl in $ou.ExtendedAcl){
            Add-spOrganizationalUnitAcl -acl $acl -guid $ou.ObjectGuid
        }
    }

}

# Add-fnOrganizationalUnit -verbose