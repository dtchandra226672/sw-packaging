$ErrorActionPreference = "Stop"

# Define the API URL to fetch the latest Chrome stable version (JSON File)
$Link = "https://versionhistory.googleapis.com/v1/chrome/platforms/win/channels/stable/versions"
$SoftwareName = 'Google Chrome'
$Regex = '(\d+\.\d)\.(\d+)\.(\d+)'
# Send a request to the API and Get the latest version
$WebResult = Invoke-RestMethod -Uri $Link
$VersionName = $WebResult.versions[0].version
# Define filename for storing version history
$txtFileName = 'C:\Users\Darryl Chandra\tutorials\utils\chrome-latest-ver.txt'

if ($VersionName -match $Regex) {
    $Version = $Matches[0]
    $MajorRelease = $Matches[1]
    $MinorRelease = [int]$Matches[2]
    $BugFixRelease = [int]$Matches[3]
} 
else {
    Write-Error "Cannot Parse $SoftwareName Version!"
}

if (-Not (Test-Path "$txtFileName")) {
    New-Item "$txtFileName"
    Write-Host 'New File Successfully Created! Now Proceeding...'
    Add-Content -Path "$txtFileName" -Value "$SoftwareName Update History"
    
    $content = Get-Content "$txtFileName"
}
else {
    $content = Get-Content "$txtFileName"

    # Check file header as for correct data formatting
    if (($content | Select-Object -Index 0) -eq "$SoftwareName Update History") {
        Write-Host 'Required File Found! Now Proceeding...' -ForegroundColor Green
        Write-Host "Checking latest version of $SoftwareName..." -ForegroundColor Green
    }
    else {
        Write-Error "Wrong File! Pls delete $txtFileName and try again!"
    }
}

$Empty = ($content | Select-Object -Index (2..12))
$today = (Get-Date).ToString('yyyy-MM-dd')

# Check if file is empty (only containing header)
if (!($Empty)) {
    Add-Content `
        -Path "$txtFileName" `
        -Value "Last Update`n`t$today`nLatest Version Number`n`t$Version`nMajor Release`n`t$MajorRelease`nMinor Release `n`t$MinorRelease`nBugFix Release`n`t$BugFixRelease`nComment`n`tInitial Commit`n`nHistory Logs..."
} 
else {
    # Otherwise, compare version from date and release numbers, update history logs if there are updates
    $lastDate = [datetime]::parseexact(($content | Select-Object -Index (2)).Replace("`t", ""), 'yyyy-MM-dd', $null)
    $lastVersion = ($content | Select-Object -Index (4)).Replace("`t", "")
    $lastMajor = [int]($content | Select-Object -Index (6)).Replace('.', '')
    $lastMinor = [int]($content | Select-Object -Index (8))
    $lastBugFix = [int]($content | Select-Object -Index (10))

    if (((Get-Date).Date - $lastDate).Days -lt 1) {
        Write-Host 'Time to short! Come back again tomorrow!' -ForegroundColor Red
    }
    elseif ([int]$MajorRelease.Replace('.', '') -gt [int]$lastMajor) {
        Write-Host 'Major Release Available!'
        $content[2] = "`t$today"
        $content[4] = "`t$Version"
        $content[6] = "`t$MajorRelease"
        $content[8] = "`t$MinorRelease"
        $content[10] = "`t$BugFixRelease"
        $content[12] = "`tMajor Release Available!"
        $content[14] += "`n$today`tMajor Release from $lastVersion to $Version"
        $content | Set-Content "$txtFileName"
    }
    elseif ($MinorRelease -gt $lastMinor) {
        Write-Host 'Minor Release Available!'
        $content[2] = "`t$today"
        $content[4] = "`t$Version"
        # $content[6] = "`t$MajorRelease"
        $content[8] = "`t$MinorRelease"
        $content[10] = "`t$BugFixRelease"
        $content[12] = "`tMinor Release Available!"
        $content[14] += "`n$today`tMinor Release from $lastVersion to $Version"
        $content | Set-Content "$txtFileName"
    }
    elseif ($BugFixRelease -gt $lastBugFix) {
        Write-Host 'Bug Fix Release Available!'
        $content[2] = "`t$today"
        $content[4] = "`t$Version"
        # $content[6] = "`t$MajorRelease"
        # $content[8] = "`t$MinorRelease"
        $content[10] = "`t$BugFixRelease"
        $content[12] = "`tBug Fix Release Available!"
        $content[14] += "`n$today`tBug Fix Release from $lastVersion to $Version"
        $content | Set-Content "$txtFileName"
    }
    else {
        Write-Host 'No Available Update!' -ForegroundColor Red
        $content[2] = "`t$today"
        $content[12] = "`tNo Available Update!"
        $content[14] += "`n$today`tCommitted Update Check! No Available Update from $lastVersion"
        $content | Set-Content "$txtFileName"
    }
}