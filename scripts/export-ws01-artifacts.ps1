# Run on WS01 as Administrator. Copies local lab evidence/configs into a staging folder.
$Dest = "$env:USERPROFILE\Desktop\enterprise-soc-ws01-export"
New-Item -ItemType Directory -Path $Dest -Force | Out-Null
New-Item -ItemType Directory -Path "$Dest\configs" -Force | Out-Null
New-Item -ItemType Directory -Path "$Dest\attacks" -Force | Out-Null

Copy-Item "C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf" "$Dest\configs\ws01-inputs.conf" -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\SplunkUniversalForwarder\etc\system\local\outputs.conf" "$Dest\configs\ws01-outputs.conf" -ErrorAction SilentlyContinue
Copy-Item "C:\Lab\attacks\execution-log.csv" "$Dest\attacks\execution-log.csv" -ErrorAction SilentlyContinue

Write-Host "Exported WS01 artifacts to $Dest"
Write-Host "Open the configs before GitHub upload and remove any secrets/tokens if present."
