function Get-fnSubets {
    [CmdletBinding()]
    param ()

    try {
        Write-Verbose "Getting subnets"

        $subnets = Get-ADReplicationSubnet -Filter * -Properties * | Select-Object Name, DisplayName, Description, Site, ProtectionFromAccientalDeletion, Created, Modified, Deleted
    
        foreach($subnet in $subnets){
            $forestSubnets = [PSCustomObject]@{
                Name        = $subnet.Name
                Description = $subnet.Description
                Protected   = $subnet.ProtectionFromAccientalDeletion
                Modified    = $subnet.Modified
                Created     = $subnet.Created
                Deleted     = $subnet.Deleted
                Site        = $subnet.Site
            }
        }
        return $forestSubnets
     } catch {
         Write-Warning "Get-fnSubets failed: $($_.Exception.Message) "
         continue
     }
}