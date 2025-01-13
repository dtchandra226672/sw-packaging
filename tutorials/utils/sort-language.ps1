# SOME EXAMPLE OF TEXT TO BE PROCESSED (put here for easy regex comparison)
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/en-US/">English (US) - English (US)</a></li>.
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/ach/">Acholi - Acholi</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/af/">Afrikaans - Afrikaans</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/sq/">Albanian - Shqip</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/ar/">Arabic - عربي</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/an/">Aragonese - aragonés</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/hy-AM/">Armenian - Հայերեն</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/ast/">Asturian - Asturianu</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/az/">Azerbaijani - Azərbaycanca</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/eu/">Basque - Euskara</a></li>
# <li><a href="/en-US/firefox/all/desktop-release/win64-msi/be/">Belarusian - Беларуская</a></li>

# $langCodeRegex = '(?<=\/win64-msi\/)([^\/]+)'
# $languageRegex = '(?<=">)([^<]+)'

$regex = '(?<=win64-msi\/)([^\/">]+).*?(?<=">)([^<]+)'

$langList = Get-Content .\language.txt

if (-Not (Test-Path .\language-sorted.txt)) {
    # Create the file if it does not exist
    New-Item .\language-sorted.txt
    Write-Host 'Sorted language txt file created successfully! Now appending language...' -ForegroundColor Green

    foreach ($name in $langList) {
        if ($name -match $regex) {
            $langCode = $Matches[1] # ex: en-US or da
            $language = $Matches[2] # ex: English(US) or Danish
            
            Add-Content -Path .\language-sorted.txt -Value "$langCode`t$language"
        }
        else {
            Add-Content -Path .\language-sorted.txt -Value '### ERROR! Cannot Parse Language! ###'
        }
    }
}
else {
    # File already exists
    Write-Host 'Sorted language txt file already exist! Program will not run!' -ForegroundColor Red
    
    exit
}