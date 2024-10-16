
# import functions

# $VerbosePreference = "continue"
# $VerbosePreference = "silentlycontinue"

<# using config file #>
# $conf = Get-fnConfig
# $conf.Domain
# $email = Get-fnEmailConfig
# $email.helpdesk



<# Export employee roster #>
# Export-fnEmployeeToDialMy -Verbose
# Export-fnLatestEmployeeRosterToRave -Verbose

<# group-policy #>
# Get-fnGPOMetaData #| Format-Table -AutoSize *
# Get-fnGpoContent
