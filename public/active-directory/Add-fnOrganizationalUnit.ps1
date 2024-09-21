function Add-fnOrganizationalUnit {
    $organizationalUnits = Get-fnOrganizationalUnit -Verbose

    $startTimer = Start-Timer
    foreach($ou in $organizationalUnits)
    {
        Add-spOrganizationalUnit -organizational_unit $ou -Verbose
        foreach($acl in $ou.ExtendedAcl){
            Add-spOrganizationalUnitAcl -acl $acl -guid $ou.ObjectGuid
        }
    }


    $totalTime = Stop-Timer -Start $startTimer
    Write-Verbose "Organizational Unit insert completed. It took $totalTime"
}

# Add-fnOrganizationalUnit -verbose