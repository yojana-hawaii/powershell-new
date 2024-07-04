function Get-fnForestSiteLinks {
    [CmdletBinding()]
    param()
    return Get-ADReplicationSiteLink -Filter * -Properties * | 
            Select-Object Name, Cost, ReplicationFrequencyInMinutes, ReplInterval, ReplicationSchedule, `
                Created, Modified, Deleted, InterSiteTransportProrocol, DistinguishedName, ProtectedFromAccidentalDeletion
}