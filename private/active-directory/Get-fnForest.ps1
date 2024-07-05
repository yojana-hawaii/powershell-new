function Get-fnForest {
[CmdletBinding()]
param()
    try{
        Write-Verbose -Message "Getting information about the forest"
        return Get-ADForest -erroraction stop
    } catch {
        Write-Warning "Get-fnForest failed: $($_.Exception.Message)."
        continue
    }
}
# Get-fnForest -Verbose
