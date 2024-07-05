function Get-fnDhcp {
    [CmdletBinding()]
    param()
    

    try {
        Write-Verbose "Getting DHCP Names"
        return @((Get-DhcpServerInDC).dnsname)
     } catch {
         Write-Warning "Get-fnDhcp failed: $($_.Exception.Message) "
         continue
     }
}
# Get-fnDhcp -Verbose
