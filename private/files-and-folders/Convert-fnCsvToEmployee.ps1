

function Convert-fnCsvToEmployee{
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$sourceFile,
        [Parameter()]
        [string]$org2,
        [Parameter()]
        [string]$sourceFileHeader
    )

    <# convert string to string[]. For some reason only works if variable is different name #>
    # $csvHeader0 = ($dialMy.sourceFileHeader) -replace '"', ""
    $csvHeader = $sourceFileHeader -split ","

    $employees = Read-fnCsvAddCustomHeader -csvFile $sourceFile -csvHeader $csvHeader

    foreach($employee in $employees){
        Write-Verbose "Name $($employee.first) $($employee.last)"

        <# simple hash table for location and department. Parameter long name of the location or department. Returns short name  #>
        $newLocation      = Convert-fnLocationMapping -location $employee.location
        $newDepartment    = Convert-fnDepartmentMapping -department $employee.department
        <# organization can be differentiated using department #>
        $organizationGroup  = Convert-fnOrganizationMapping -departmentGroup $newDepartment
        <# staff from all orgnizations #>
        $allGroup           = Convert-fnAllOrgGroup


        $isOrg2 = $newDepartment -eq $org2
        <# Separate first name & last name. compare it to active directory and get email / username. If it not found, name in AD & CSV does not match #>
        $userEmail          = Convert-fnLastnameCommaFirstnameToEmailMapping -lastCommaFirstName "$($employee.last), $($employee.first)" -isOrg2 $isOrg2
        $managerEmail       = Convert-fnLastnameCommaFirstnameToEmailMapping -lastCommaFirstName $employee.manager -isOrg2 $isOrg2
        


        $orgGroup           = ("$newLocation,$organizationGroup,$allGroup") 
        $dialGroup          = ("$newLocation`$`$`$$organizationGroup`$`$`$$allGroup") 

        $employee.department    = $newDepartment
        $employee.location      = $newLocation
        $employee.staffEmail    = $userEmail
        $employee.managerEmail  = $managerEmail
        $employee.orgGroup      = $orgGroup
        $employee.dialGroup     = $dialGroup
    }
    return $employees
}