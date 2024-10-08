Write-Host "Author: @harytien"
# Get List Name Wifi on Windows
$wifiProfiles = netsh wlan show profiles | Select-String -Pattern ":\s*(.*)" | Where-Object { $_.Matches.Groups[1].Value.Trim() -ne "" } | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }

# Patch
$scriptDirectory = "C:\!WifiPasswords"
$fileName = "listWifiPasswords.txt"

# Create a directory if it does not exist
if (-not (Test-Path -Path $scriptDirectory)) {
    New-Item -Path $scriptDirectory -ItemType Directory | Out-Null
}

$passwordList = @()
# Get List Password with List Name Wifi
Write-Host "Getting list Wifi Passwords..."
foreach ($profile in $wifiProfiles) {
    $profileInfo = netsh wlan show profile name="$profile" key=clear
    $password = ($profileInfo[32] -split ": ")[-1].Trim()
    $passwordList += "${profile}:${password}"
}

if ($passwordList) {
    $passwordList | Out-File -FilePath "$scriptDirectory\$fileName"
    Write-Host "Path to list of saved Passwords: $scriptDirectory\$fileName"
    Invoke-Item "$scriptDirectory\$fileName"
}

Read-Host "Press Enter to exit"
exit
