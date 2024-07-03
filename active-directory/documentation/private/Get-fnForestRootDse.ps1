function Get-fnForestRootDse {
    [CmdletBinding()]
    param()

    try {
       Get-ADRootDSE -Properties *
    } catch {
        Write-Warning "Get-fnForestRootDse failed: $($_.Exception.Message) "
    }
}

# Get-fnAdRootDse -Verbose