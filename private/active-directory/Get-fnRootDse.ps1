function Get-fnRootDse {
    [CmdletBinding()]
    param()

    try {
        Write-Verbose -Message "Getting information about the Root Dse"
        Get-ADRootDSE -Properties *
    } catch {
        Write-Warning "Get-fnRootDse failed: $($_.Exception.Message) "
        continue
    }
}

# Get-fnRootDse -Verbose