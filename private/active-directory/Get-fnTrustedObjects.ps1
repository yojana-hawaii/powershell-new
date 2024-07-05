function Get-fnTrustedObjects {
    [CmdletBinding()]
    param()
    try{
        Write-Verbose "getting trusted domain objects"
        return Get-ADTrust -Filter *
    } catch {
        Write-Warning "Get-fnTrustedObjects failed: $($_.Exception.Message) "
	    continue
    }
}

