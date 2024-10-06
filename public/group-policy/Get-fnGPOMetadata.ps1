function Get-fnGPOMetaData {

    <#
    .PARAMETER GpoName
    Specific GPO by name
    .PARAMETER GpoGuid
    Specific GPO by GUID
    .PARAMETER Type
    Specific type of GPO??
    .EXAMPLE
    $gpo=gnGet-GPO | Format-table DisplayName, Owner, OwnerSID, OwnerType
    
    #>

    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$GpoName,
        [Parameter()]
        [string]$GpoGuid,
        [Parameter()]
        [string]$Type
    )

    if($GpoName){
        $GetGpoParameter = @{
            Name        = $GpoName
            ErrorAction = 'SilentlyContinue'
        }
    } elseif($GpoGuid){
        $GetGpoParameter = @{
            id        = $GpoGuid
            ErrorAction = 'SilentlyContinue'
        }
    } else {
        $GetGpoParameter = @{
            All        = $true
            ErrorAction = 'SilentlyContinue'
        }
    } 

    $groupPolicies = Get-GPO @GetGpoParameter
    $cnt = $groupPolicies.Count
    $count = 0
    $gpoContent = @()
    foreach($gpo in $groupPolicies){
        $count++
        Write-Verbose "Get-fnGPOMetadata working on '$($GPO.DisplayName)' ($count of $cnt)" -Verbose
        try{
            $gpoXmlMetadata = Get-GPOReport -ID $gpo.ID -ReportType XML
            # Select-Xml -Xml $gpoXmlMetadata -XPath '/GPOS'
            $gpoContent += Get-fnGpoXmlParseMetadata -xmlContent $gpoXmlMetadata -GPO $gpo -splitter ','
        } catch {
            Write-Warning "Get-fnGPOMetadata failed on GPO report of  '$($GPO.DisplayName)' ($count of $cnt): $($_.Exception.Message). Skip"
            continue
        } 
        break
    }
    Write-Verbose "Get-fnGPOMetadata finished reading GPO content and parsed the return XML." -Verbose
    return $gpoContent
}
