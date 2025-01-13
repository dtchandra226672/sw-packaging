# Define the regex pattern
$pattern = '<h2 id="version[^"]+">Version ([\d\.]+)'
$Link = 'https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-stable-channel'
$SoftwareName = 'Microsoft Edge'
$WebResult = Invoke-WebRequest -Uri $Link | Select-Object Content

# Function to read file and extract versions
function Extract-VersionsFromFile {
    param (
        [string]$filePath
    )

    try {
        # Check if file exists
        if (Test-Path -Path $filePath) {
            # Read the file content
            $content = Get-Content -Path $filePath -Raw
            # Apply regex pattern to find matches
            $match = [regex]::Matches($WebResult, $pattern)
            
            # if ($matches.Count -gt 0) {
                # Write-Output "Found version numbers:"
                # foreach ($match in $matches) {
                    # Output the captured version number
                    Write-Output $match.Groups[1].Value
                # }
            # }
            # else {
            #     Write-Output "No version numbers found."
            # }
        }
        else {
            Write-Output "File not found: $filePath"
        }
    }
    catch {
        Write-Output "An error occurred: $_"
    }
}

# Prompt for file path input
$filePath = 'C:/Users/Darryl Chandra/tutorials/bin/history.txt'
Extract-VersionsFromFile -filePath $filePath