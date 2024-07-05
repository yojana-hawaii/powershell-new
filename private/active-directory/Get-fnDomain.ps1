function Get-fnDomain {
    [CmdletBinding()]
    param()
    try {
        Write-Verbose -Message "Getting information about the domain"
        Get-ADDomain -ErrorAction Stop

    } catch {
        Write-Warning "Get-fnDomain failed: $($_.Exception.Message)."
        continue
    }
}
# Get-fnDomain -Verbose

