# Project Completion Status

This repository is packaged with the screenshots that were actually available in the chat/uploaded files. One screenshot (`01-splunk-sysmon-hosts.png`) was visible in the user's local folder screenshot but was not uploaded as its own image file, so it must be copied from the local folder before publishing.

## Evidence captured in this package

- `02-splunk-windows-hosts.png` — Windows index receiving host data.
- `03-splunk-powershell-hosts.png` — PowerShell index receiving host data.
- `04-active-directory-ou-tree.png` — AD OU structure under `corp.northgate.local`.
- `05-domain-users.png` — service account / `svc_sql` evidence.
- `05B-service-account-svc-sql.png` — duplicate explicit service-account proof.
- `06-ws01-domain-joined.png` — WS01 joined to `corp.northgate.local`.
- `07-atomic-powershell-4104.png` — PowerShell Script Block Logging evidence.
- `08-atomic-powershell-sysmon.png` — Sysmon process creation evidence for PowerShell activity.
- `09-lsass-access.png` — ProcDump/LSASS related Sysmon telemetry.
- `10-kerberoasting-4769.png` — Kerberos Event ID 4769 activity on DC01.
- `11-scheduled-task.png` — Scheduled-task related Sysmon/PowerShell telemetry.
- `12-security-log-cleared.png` — Security log cleared event.
- `13-soc-dashboard.png` — Final Splunk SOC dashboard.

## Copy from local folder before publishing

- `01-splunk-sysmon-hosts.png` — the file exists in the user's local screenshot folder but was not available as a standalone upload in this chat batch.

## Attack status

| Technique | Status | Evidence |
|---|---|---|
| T1059.001 PowerShell | Complete | PowerShell 4104 + Sysmon Event 1 |
| T1003.001 LSASS Memory | Complete / blocked by Defender | ProcDump telemetry + Defender block |
| T1558.003 Kerberoasting | Complete | DC01 EventCode 4769 |
| T1053.005 Scheduled Task | Complete | Sysmon scheduled-task/powershell telemetry |
| T1070.001 Security Log Clearing | Complete manually | EventCode 1102 + Sysmon `wevtutil` telemetry |

## Still required before making the repo public

1. Copy `01-splunk-sysmon-hosts.png` from your local screenshot folder into `screenshots/`.
2. Export and sanitize config files:
   - `configs/ws01-inputs.conf`
   - `configs/ws01-outputs.conf`
   - `configs/dc01-inputs.conf`
   - `configs/dc01-outputs.conf`
   - `configs/sysmonconfig-export.xml`
3. In Splunk, either import the included Splunk app or manually save the five reports/alerts.
4. Create the GitHub repository and push/upload this project.

## Publishing rule

Do not publish the repository until config files have been checked for secrets. Screenshots are safe enough for a lab repo, but configs can expose tokens, credentials, or environment-specific values if you are careless.
