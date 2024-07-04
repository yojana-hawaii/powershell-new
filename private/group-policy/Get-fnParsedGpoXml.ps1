function fnlocal_GetLinks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Object] $xmlLinksTo
    )
    
    # Links count and related OU of each GPO
    if($xmlLinksTo){
        $linkSplit = ([Array] $xmlLinksTo).Where( { $_.Enabled -eq $true }, 'split')

        $linked = $linksEnabledCount -gt 0
        $linksEnabledCount = ([Array] $linkSplit[0]).Count
        $linksDisabledCount = ([Array] $linkSplit[1]).Count
        $linksTotalCount = ([array] $xmlLinksTo).Count
        
        $links = @(
            $xmlLinksTo | ForEach-Object -Process {
                if($_){
                    $_.SOMPath
                }
            }
        ) -join $splitter
        
        $linksObject = $xmlLinksTo | ForEach-Object -Process {
            if($_){
                [PSCustomObject]@{
                    ConanicalName   = $_.SOMPath
                    Enabled         = $_.Enabled
                    NoOverRide      = $_.NoOverRide 
                }   

            }
        }
        
    } else {
        $linked             = $false
        $linksEnabledCount  = 0
        $linksDisabledCount = 0
        $linksTotalCount    = 0
        $links              = $null
        $linksObject        = $null
    }

    return [PSCustomObject]@{
                Linked = $linked
                LinksEnabledCount   = $linksEnabledCount
                LinksDisabledCount  = $linksDisabledCount
                LinksTotalCount     = $linksTotalCount
                Links               = $links
                LinksObject         = $linksObject
            }
}
function fnLocal_FileCheck {
    <#
        GPF files are special files that are used to store settings for some applications (mainly Citrix)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$GpoSysvolPath
    )
    $GpfFile = $false
    $fileCount = 0
    Get-ChildItem -LiteralPath $GpoSysvolPath -Recurse -ErrorAction SilentlyContinue -File | ForEach-Object {
        if($_.Extension -eq '.gpf'){
            #cannot avoid warning when variable is not used within script
            $GpfFile = $true
            
        }
        $fileCount++
    }
    return [PSCustomObject]@{
                FileCount = $fileCount
                GpfFileExists = $GpfFile
            }
}
function fnLocal_GpoBoolDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Object]$gpoExtension
    )
    $enabled            = $gpoExtension.Enabled
    $settingsNotNull    = -not($null -eq $gpoExtension.ExtensionData)
    
    foreach($extensionType in $gpoExtension.ExtensionData.Extension){
        if($extensionType){
            $gpoExtensionTypeSplit = $extensionType.type -split ':' # q1:RegistrySetting split
            try{
                $keys = $extensionType | Get-Member -MemberType Properties -ErrorAction Stop | Where-Object { $_.Name -notin 'type', $gpoExtensionTypeSplit[0] -and $_.Name -notin @('Blocked') }
            } catch {
                Write-Warning "Get-fnParsedGPOXml error on [$DisplayName]: $($_.Exception.Message)"
                continue
            }
        }
    }
    
    return [PSCustomObject]@{
        Enabled             = $enabled
        SettingNotFull      = $settingsNotNull
        Problem             = $settingsNotNull -and -not $enabled
        Optimized           = $settingsNotNull -xor $enabled
        SettingsType        = $keys.Name -join ", "
        SettingsAvailable   = $keys.count -gt 0
    } 
}
function fnLocal_GetGpoAcl {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Object]$securityDescriptor
    )
    return @(
        [PSCustomObject]@{
            Name            = $securityDescriptor.Owner.Name.'#text'
            SID             = $securityDescriptor.Owner.SID.'#text'
            PermissionsType = 'Allow'
            Inherited       = $false
            Permissions     = 'Owner'
        }
        $securityDescriptor.Permissions.TrusteePermissions | ForEach-Object -Process {
            if($_){
                [PSCustomObject]@{
                    Name            = $_.trustee.name.'#text'
                    SID             = $_.trustee.SID.'#text'
                    PermissionsType = $_.type.PermissionType
                    Inherited       = $_.Inherited
                    Permissions     = $_.Standard.GPOGroupedAccessEnum
                }
            }
        }
    )
}
function fnLocal_ApplyPermission {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Object]$acl
    )
    $applyPermission = $false
    if($acl){
        foreach($user in $acl){
            if($user.Permissions -eq 'Apply Group Policy'){
                $applyPermission = $true
            }
        }
    }
    return $applyPermission
}
function Get-fnParsedGpoXml{
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
    $sysvol = fnLocal_FileCheck -GpoSysvolPath $GpoSysvolPath
    $gpf = $sysvol.GpfFileExists

    $xmlLinksTo = fnlocal_GetLinks -xmlLinksTo $xmlContent.GPO.LinksTo
    $computerGpo = fnLocal_GpoBoolDetails -gpoExtension $xmlContent.GPO.Computer
    $userGpo = fnLocal_GpoBoolDetails -gpoExtension $xmlContent.GPO.User

    $securityDescriptor = $xmlContent.GPO.SecurityDescriptor
    $acl = fnLocal_GetGpoAcl -securityDescriptor $securityDescriptor

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
        ApplyPermission         = fnLocal_ApplyPermission -acl $acl
        ACL                     = $acl
    }
    return $xmlGpoOutput
}