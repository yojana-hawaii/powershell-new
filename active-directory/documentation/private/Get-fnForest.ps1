function Get-fnForest {
[CmdletBinding()]
param()
    Write-Verbose -Message "Getting all information about the forest"
    try{
        return Get-ADForest -erroraction stop
    } catch {
        Write-Warning "Get-fnForest failed: $($_.Exception.Message)."
        continue
    }
}
# Get-fnAdForest -Verbose
