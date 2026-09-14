# Run on DC01 as Administrator. Copies local Splunk forwarder configs into a staging folder.
$Dest = "$env:USERPROFILE\Desktop\enterprise-soc-dc01-export"
New-Item -ItemType Directory -Path "$Dest\configs" -Force | Out-Null

Copy-Item "C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf" "$Dest\configs\dc01-inputs.conf" -ErrorAction SilentlyContinue
Copy-Item "C:\Program Files\SplunkUniversalForwarder\etc\system\local\outputs.conf" "$Dest\configs\dc01-outputs.conf" -ErrorAction SilentlyContinue

Write-Host "Exported DC01 artifacts to $Dest"
Write-Host "Open the configs before GitHub upload and remove any secrets/tokens if present."
