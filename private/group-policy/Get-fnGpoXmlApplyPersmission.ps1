function Get-fnGpoXmlApplyPersmission {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Object]$acl
    )
    $applyPermission = $false
    if($acl){
        foreach($user in $acl){
            if($user.Permissions -eq 'Apply Group Policy'){
                $applyPermission = $true
            }
        }
    }
    return $applyPermission
}