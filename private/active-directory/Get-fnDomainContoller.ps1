function Get-fnDomainController {
    [CmdletBinding()]
    param()
    

    try {
        Write-Verbose "Getting Domain Controller Names"
        return @((Get-ADDomainController -Filter *).Hostname)
     } catch {
         Write-Warning "Get-fnDomainControler failed: $($_.Exception.Message) "
         continue
     }
}
# Get-fnDomainController -Verbose
