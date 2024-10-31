$ErrorActionPreference = "Stop"

$DownloadLink = 'https://download.mozilla.org/?product=firefox-msi-latest-ssl'
$SoftwareName = 'Mozilla Firefox'
$Regex = '(?<=releases\/)([^\/]+)'
$Regex = '(\d+\.)(\d+\.)(\d+)'
$WebResult = Invoke-WebRequest -Uri $DownloadLink -MaximumRedirection 0 -ErrorAction Ignore
$VersionName = $WebResult.Headers.Location
$txtFileName = 'C:\Users\Darryl Chandra\tutorials\utils\firefox-latest-ver.txt'

if ($VersionName -match $Regex) {
    $VerRelease = $Matches[0]
    $MajorRelease = [int]$Matches[1]
    $MinorRelease = [int]$Matches[2]
    $BugFixRelease = [int]$Matches[3]
    # Write-Host $MajorRelease, $MinorRelease, $BugFixRelease
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

<# Example of Correct Text File

0 Firefox Update History
1 Last Update
2 `t(Get-Date).Date
3 Lastest Version Number
4 `t$Matches[0]
5 Major Release
6 `t[int]$Matches[1]
7 Minor Release
8 `t[int]$Matches[2]
9 BugFix Release
10 `t[int]$Matches[3]
11 Comment
12 MAJOR/MINOR/BUGFIX UPDATE
13 
14 History...

#>

$Empty = ($content | Select-Object -Index (2..12))
$today = (Get-Date).ToString('yyyy-MM-dd')

# Check if file is empty (only containing header)
if (!($Empty)) {
    Add-Content `
        -Path "$txtFileName" `
        -Value "Last Update`n`t$today`nLatest Version Number`n`t$VerRelease`nMajor Release`n`t$MajorRelease`nMinor Release `n`t$MinorRelease`nBugFix Release`n`t$BugFixRelease`nComment`n`tInitial Commit`n`nHistory Logs..."
} 
else {
    # Otherwise, compare version from date and release numbers, update history logs if there are updates
    $lastDate = [datetime]::parseexact(($content | Select-Object -Index (2)).Replace("`t", ""), 'yyyy-MM-dd', $null)
    $lastVersion = ($content | Select-Object -Index (4)).Replace("`t", "")
    $lastMajor = [int]($content | Select-Object -Index (6))
    $lastMinor = [int]($content | Select-Object -Index (8))
    $lastBugFix = [int]($content | Select-Object -Index (10))

    if (((Get-Date).Date - $lastDate).Days -lt 1) {
        Write-Host 'Time to short! Come back again tomorrow!' -ForegroundColor Red
    }
    elseif ($MajorRelease -gt $lastMajor) {
        Write-Host 'Major Release Available!'
        $content[2] = "`t$today"
        $content[4] = "`t$VerRelease"
        $content[6] = "`t$MajorRelease"
        $content[8] = "`t$MinorRelease"
        $content[10] = "`t$BugFixRelease"
        $content[12] = "`tMajor Release Available!"
        $content[14] += "`n$today`tMajor Release from $lastVersion to $VerRelease"
        $content | Set-Content "$txtFileName"
    }
    elseif ($MinorRelease -gt $lastMinor) {
        Write-Host 'Minor Release Available!'
        $content[2] = "`t$today"
        $content[4] = "`t$VerRelease"
        # $content[6] = "`t$MajorRelease"
        $content[8] = "`t$MinorRelease"
        $content[10] = "`t$BugFixRelease"
        $content[12] = "`tMinor Release Available!"
        $content[14] += "`n$today`tMinor Release from $lastVersion to $VerRelease"
        $content | Set-Content "$txtFileName"
    }
    elseif ($BugFixRelease -gt $lastBugFix) {
        Write-Host 'Bug Fix Release Available!'
        $content[2] = "`t$today"
        $content[4] = "`t$VerRelease"
        # $content[6] = "`t$MajorRelease"
        # $content[8] = "`t$MinorRelease"
        $content[10] = "`t$BugFixRelease"
        $content[12] = "`tBug Fix Release Available!"
        $content[14] += "`n$today`tBug Fix Release from $lastVersion to $VerRelease"
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