function Get-fnGpoXmlParseMetadata{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [XML] $xmlContent,
        [Parameter(Mandatory)]
        [Microsoft.GroupPolicy.GPO]$GPO,
        [Parameter()]
        [string] $splitter = [System.Environment]::NewLine
    )
    
    $GpoSysvolPath = "\\$($GPO.DomainName)\sysvol\$($GPO.DomainName)\Policies\{$($GPO.ID)}"
    $sysvol = Get-fnGpoXmlSysvolPath -GpoSysvolPath $GpoSysvolPath
    $gpf = $sysvol.GpfFileExists

    $xmlLinksTo = Get-fnGpoXmlLinkTo -xmlLinksTo $xmlContent.GPO.LinksTo
    $computerGpo = Get-fnGpoXmlUserAndComputer -gpoExtension $xmlContent.GPO.Computer
    $userGpo = Get-fnGpoXmlUserAndComputer -gpoExtension $xmlContent.GPO.User

    $securityDescriptor = $xmlContent.GPO.SecurityDescriptor
    $acl = Get-fnGpoXmlAcl -securityDescriptor $securityDescriptor

    $xmlGpoOutput = [PSCustomObject]@{
        DisplayName             = $GPO.DisplayName
        DomainName              = $GPO.DomainName
        GUID                    = $GPO.Id
        Owner                   = $xmlContent.GPO.SecurityDescriptor.Owner.Name.'#text'
        OwnerSid                = $xmlContent.GPO.SecurityDescriptor.Owner.SID.'#text'
        Description             = $GPO.Description

        Created                 = $GPO.CreationTime
        LastModified            = [datetime]$xmlContent.GPO.ModifiedTime
        Days                    = (New-TimeSpan -Start ([datetime]$xmlContent.GPO.ModifiedTime) -End (Get-Date)).Days
        ReadTime                = [datetime]$xmlContent.GPO.ReadTime
        
        GpoDistinguishedName    = $GPO.Path
        GpoSysvolPath           = $GpoSysvolPath
        
        ComputerPolicies        = $xmlContent.GPO.Computer.ExtensionData.Name -join ','
        ComputerDirectoryVersion= $xmlContent.GPO.Computer.VersionDirectory
        ComputerSyvolVersion    = $xmlContent.GPO.Computer.VersionSysvol
        ComputerVersionMatch    = $xmlContent.GPO.Computer.VersionDirectory -eq $xmlContent.GPO.Computer.VersionSysvol
        ComputerSettings        = $xmlContent.GPO.Computer.ExtensionData.Extension
        ComputerEnabled         = $computerGpo.Enabled
        ComputerProblem         = $computerGpo.Problem
        ComputerOptimized       = $computerGpo.Optimized
        ComputerSettingsTypes   = $computerGpo.SettingsType
        ComputerSettingsAvailable=$computerGpo.SettingsAvailable 

        UserPolicies            = $xmlContent.GPO.User.ExtensionData.Name -join ','
        UserDirectoryVersion    = $xmlContent.GPO.User.VersionDirectory
        UserSyvolVersion        = $xmlContent.GPO.User.VersionSysvol
        UserVersionMatch        = $xmlContent.GPO.User.VersionDirectory -eq $xmlContent.GPO.User.VersionSysvol
        UserSettings            = $xmlContent.GPO.User.ExtensionData.Extension
        UserEnabled             = $userGpo.Enabled
        UserProblem             = $userGpo.Problem
        UserrOptimized          = $userGpo.Optimized
        UserSettingsTypes       = $userGpo.SettingsType
        UserSettingsAvailable   = $userGpo.SettingsAvailable

        Enabled                 = $userGpo.Enabled -and $computerGpo.Enabled
        NoSettings              = -not($computerGpo.SettingNotFull -or $userGpo.SettingNotFull)
        Problem                 = $userGpo.Problem -or $computerGpo.Problem
        Optimized               = $userGpo.Optimized -and $computerGpo.Optimized
        Empty                   = -not $computerGpo.SettingsAvailable -and -not $userGpo.SettingsAvailable -and -not $gpf.GpfFileExists

        OwnerType               = 'using some other function??'
        Exclude                 = 'No exclusion for now'
        
        Linked                  = $xmlLinksTo.Linked
        LinksCount              = $xmlLinksTo.LinksTotalCount
        LinksEnabledCount       = $xmlLinksTo.LinksEnabledCount
        LinksDisabledCount      = $xmlLinksTo.LinksDisabledCount
        Links                   = $xmlLinksTo.Links
        LinksObject             = $xmlLinksTo.LinksObject
        
        FileCount               = $sysvol.FileCount
        
        WMIFilter               = $GPO.WmiFilter.Name
        WMIFilterDescription    = $GPO.WmiFilter.Description
        
        GpoStatus               = $GPO.GpoStatus
        GpoObject               = $GPO
        
        SDDL                    = $xmlContent.GPO.SecurityDescriptor.SDDL.'#text' -join $splitter
        AuditingPresent         = $xmlContent.GPO.SecurityDescriptor.AuditingPresent.'#text'
        ApplyPermission         = Get-fnGpoXmlApplyPersmission -acl $acl
        ACL                     = $acl
    }
    return $xmlGpoOutput
}