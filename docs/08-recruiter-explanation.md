# Recruiter and Interview Explanation

## 30-second explanation

I built a small enterprise SOC lab using a Windows Server domain controller, a Windows 11 domain workstation, and Splunk running on Ubuntu. I configured Windows auditing, PowerShell logging, Sysmon, and Splunk Universal Forwarders so security logs from the Windows hosts were sent into Splunk. Then I ran controlled ATT&CK-style simulations for PowerShell execution, LSASS credential access, Kerberoasting, scheduled-task persistence, and log clearing. I wrote SPL and Sigma detections, validated them against my own telemetry, and documented the activity as a simulated incident investigation.

## Simple explanation

I built a fake company network, attacked it in controlled ways, collected the logs, searched the evidence in Splunk, and wrote detections and an investigation report like a SOC analyst would.

## What each machine did

- **DC01**: Windows Server domain controller. It handled Active Directory, domain users, DNS, and Kerberos-related activity.
- **WS01**: Windows 11 workstation joined to the domain. This was the main attack target.
- **SPL01**: Ubuntu server running Splunk Enterprise. It collected and searched logs from the Windows hosts.
- **Kali01**: Optional attacker machine. Most tests were executed from WS01 using Atomic Red Team.

## What Splunk did

Splunk acted as the SIEM. Instead of opening Event Viewer manually on each Windows machine, logs were forwarded into Splunk and separated into indexes:

- `win` for Windows event logs
- `sysmon` for Sysmon telemetry
- `pwsh` for PowerShell logs

## What Sysmon did

Sysmon gave deeper process-level telemetry than default Windows logs. The lab used Sysmon heavily for process creation and suspicious tool activity, including ProcDump during the LSASS test.

## What Atomic Red Team did

Atomic Red Team provided controlled ATT&CK-mapped simulations. This let me test whether my logging and detections actually worked instead of only writing theoretical rules.

## How to explain LSASS honestly

The LSASS dump did not fully succeed. Defender blocked the ProcDump attempt with Access Denied, but Sysmon still captured ProcDump-related telemetry. That is a realistic endpoint-defense outcome and was documented as a blocked credential-access attempt, not a successful dump.

## How to explain log clearing honestly

Atomic Red Team did not include the T1070.001 YAML file in the installed atomics folder, so I manually generated equivalent security-log-clearing behavior with `wevtutil cl Security`. The goal was to validate Event ID 1102 or Sysmon process telemetry for log clearing.

## Strong interview answer

The hardest part was not installing Splunk. The hard part was proving the telemetry chain worked end-to-end. A detection query is worthless if logging is not enabled, if the forwarder is not sending, or if the search is looking in the wrong index. I validated each step from Windows logging to Sysmon to Splunk indexes before writing detections.
