# <li><a href="/en-US/firefox/all/desktop-release/win64/">Windows 64-bit</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/">Windows 64-bit MSI</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win64-aarch64/">Windows ARM64/AArch64</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win/">Windows 32-bit</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win-msi/">Windows 32-bit MSI</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/osx/">macOS</a></li>

$regex = '(?<=desktop-release\/)([^\/">]+).*?(?<=">)([^<]+)'

$platList = Get-Content .\platform.txt

if (-Not (Test-Path .\platform-sorted.txt)) {
    New-Item .\platform-sorted.txt
    Write-Host 'Sorted platform txt file created successfully! Now appending platform...' -ForegroundColor Green

    foreach ($name in $platList) {
        if ($name -match $regex) {
            $platCode = $Matches[1]
            $platform = $Matches[2]
        
            Add-Content .\platform-sorted.txt -Value "$platCode`t$platform"
        }
        else {
            Add-Content .\platform-sorted.txt -Value '### ERROR! Cannot Parse Platform! ###'
        }
    }
}
else {
    Write-Host 'Sorted platform txt file already exist! Program will not run!' -BackgroundColor Red
}