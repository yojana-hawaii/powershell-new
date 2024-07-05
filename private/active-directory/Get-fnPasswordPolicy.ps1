function Get-fnPasswordPolicy {
    [CmdletBinding()]
    param()
    

    try {
        Write-Verbose "Getting Password Policy"
        return Get-ADDefaultDomainPasswordPolicy | 
            Select-Object ComplexityEnabled, LockoutDuration, LockoutObservationWindow, LockoutThreshold, `
                MaxPasswordAge, MinPasswordAge, MinPasswordLength, PasswordHistoryCount, ReversibleEncryptionEnabled                

        
     } catch {
         Write-Warning "Get-fnPasswordPolicy failed: $($_.Exception.Message) "
     continue
     }
}
# Get-fnPasswordPolicy -Verbose