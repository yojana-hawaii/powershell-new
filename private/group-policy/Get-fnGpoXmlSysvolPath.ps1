function Get-fnGpoXmlSysvolPath {
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