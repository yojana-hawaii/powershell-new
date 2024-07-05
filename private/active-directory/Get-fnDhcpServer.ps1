function Get-fnDhcpServer {
    [CmdletBinding()]
    param()
    

    try {
        Write-Verbose "Getting DHCP Names"
        return @((Get-DhcpServerInDC).dnsname)
     } catch {
         Write-Warning "Get-fnDhcpServer failed: $($_.Exception.Message) "
         continue
     }
}
# Get-fnDhcpServer -Verbose
