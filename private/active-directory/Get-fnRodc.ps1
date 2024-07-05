function Get-fnRodc {
    [CmdletBinding()]
    param()
    

    try {
        Write-Verbose "Getting RODC Names"
        return @((Get-ADDomainController -Filter {isreadonly -eq $true}).hostname)
     } catch {
         Write-Warning "Get-fnRodc failed: $($_.Exception.Message) "
         continue
     }
}
# Get-fnRodc -Verbose
