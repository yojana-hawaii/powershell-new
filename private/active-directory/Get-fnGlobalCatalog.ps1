

function Get-fnGlobalCatalog {
    [CmdletBinding()]
    param()
    

    try {
        Write-Verbose "Getting global catalog server Names"
        return @((Get-ADDomainController -Filter {IsGlobalCatalog -eq $true}).Hostname)

     } catch {
         Write-Warning "Get-fnGlobalCatalog failed: $($_.Exception.Message) "
         continue
     }
}
# Get-fnGlobalCatalog -Verbose

