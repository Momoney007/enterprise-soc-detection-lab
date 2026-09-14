# IR-001 — Credential Access Investigation

## Executive Summary

This report documents a controlled multi-stage security simulation in the NORTHGATE lab. The scenario began with PowerShell execution on a domain workstation, followed by a blocked LSASS dump attempt, Kerberos service-ticket activity, scheduled-task style persistence telemetry, and Windows Security log clearing. The activity was generated in a lab environment to validate logging, Splunk ingestion, SPL detections, Sigma rules, and basic incident-response reasoning.

This was a controlled lab simulation, not a real compromise.

## Environment

| Host | Role | Notes |
|---|---|---|
| DC01 | Windows Server 2022 domain controller | Active Directory, DNS, DHCP, Kerberos event source |
| WS01 | Windows 11 domain workstation | Domain-joined endpoint and primary simulation target |
| SPL01 | Ubuntu / Splunk Enterprise | Central SIEM receiving forwarded logs |

Domain: `corp.northgate.local`  
NetBIOS: `NORTHGATE`  
Primary user context observed: `NORTHGATE\Administrator`  
Service account used for Kerberos testing: `svc_sql`

## Initial Detection

The first suspicious behavior in the scenario was PowerShell activity on WS01. PowerShell Operational Event ID 4104 showed script-block logging from the endpoint, and Sysmon Event ID 1 showed process creation telemetry related to PowerShell execution. This established that the endpoint logging pipeline was working before the later credential-access and defense-evasion tests.

## Scope

The investigation focused on WS01 and DC01. WS01 generated endpoint/process telemetry. DC01 generated Kerberos service-ticket telemetry. SPL01 was used only as the central search and correlation platform.

Systems reviewed:

- WS01: PowerShell Operational logs, Sysmon Operational logs, Windows Security logs
- DC01: Windows Security logs, especially Event ID 4769
- SPL01: Splunk indexes `win`, `sysmon`, and `pwsh`

## Timeline

| UTC Time | Host | User | Event | Evidence |
|---|---|---|---|---|
| 2026-09-12T18:46:52Z | WS01 | NORTHGATE\Administrator | Atomic PowerShell command execution test ran | `07-atomic-powershell-4104.png`, `08-atomic-powershell-sysmon.png` |
| 2026-09-12T18:56:15Z | WS01 | NORTHGATE\Administrator | ProcDump LSASS dump test attempted; Defender blocked completion | `09-lsass-access.png`, `09A-lsass-procdump-blocked-extra.png` |
| 2026-09-12T19:12:10Z | DC01 | NORTHGATE\Administrator | Kerberos service-ticket activity observed on DC01 | `10-kerberoasting-4769.png` |
| 2026-09-12T19:15:26Z | WS01 | NORTHGATE\Administrator | Scheduled-task related PowerShell/Sysmon telemetry observed | `11-scheduled-task.png` |
| 2026-09-13T21:07:36Z | WS01 | NORTHGATE\Administrator | Windows Security log clearing generated Event ID 1102 and `wevtutil` telemetry | `12-security-log-cleared.png`, `extra/wevtutil-command-extra.png` |

## Evidence Review

### PowerShell Execution

PowerShell execution was captured in two ways. PowerShell Operational Event ID 4104 showed script-block logging, while Sysmon Event ID 1 showed process creation telemetry. Together, those sources provide both command/script visibility and process context.

Main SPL used:

```spl
index=pwsh host=WS01 EventCode=4104 earliest=-60m
```

```spl
index=sysmon host=WS01 EventCode=1 powershell earliest=-4h
```

### LSASS / ProcDump Attempt

The LSASS simulation used Atomic Red Team test `T1003.001-1`, which attempts LSASS dumping through ProcDump. ProcDump was downloaded as a prerequisite, but the execution attempt was blocked with `Access is denied` and Microsoft Defender produced a threat notification.

This is still useful evidence. The correct conclusion is not “LSASS was successfully dumped.” The correct conclusion is that a credential-dumping attempt was executed, blocked by endpoint protection, and still produced useful Sysmon telemetry.

Main SPL used:

```spl
index=sysmon host=WS01 earliest=-30m (procdump OR lsass OR EventCode=10)
```

### Kerberos Service-Ticket Activity

Kerberos service-ticket activity was observed on DC01 with Windows Security Event ID 4769. In this lab, the `svc_sql` service account was used as the Kerberoasting-relevant service-account target.

Main SPL used:

```spl
index=win host=DC01 EventCode=4769 earliest=-30m
```

### Scheduled Task / Persistence Telemetry

Scheduled-task style telemetry was observed through Sysmon and PowerShell-related event data. The Windows Security scheduled-task event search may vary depending on audit policy and event generation, so the lab documents Sysmon command/process evidence as the practical detection source.

Main SPL used:

```spl
index=sysmon host=WS01 earliest=-30m (schtasks OR "Scheduled Task" OR powershell)
```

### Security Log Clearing

Atomic Red Team did not contain `T1070.001.yaml` in the installed atomics folder, so equivalent telemetry was generated manually using `wevtutil cl Security`. Splunk captured Windows Security Event ID 1102 showing the audit log was cleared, and Sysmon captured the `wevtutil.exe` process/command telemetry.

Main SPL used:

```spl
index=* earliest=-2h (EventCode=1102 OR event_id=1102 OR "audit log was cleared" OR "The audit log was cleared")
```

```spl
index=sysmon host=WS01 earliest=-2h (wevtutil OR "cl Security")
```

## MITRE ATT&CK Mapping

| Activity | ATT&CK Technique | Tactic |
|---|---|---|
| PowerShell command execution | T1059.001 | Execution |
| LSASS dump attempt using ProcDump | T1003.001 | Credential Access |
| Kerberos service-ticket activity | T1558.003 | Credential Access |
| Scheduled task activity | T1053.005 | Persistence / Execution |
| Security log clearing | T1070.001 | Defense Evasion |

## False-Positive Analysis

### PowerShell

PowerShell is common in legitimate administration, software deployment, and endpoint management. A raw search for Event ID 4104 can be noisy. Higher-confidence logic should focus on suspicious strings such as encoded commands, download cradles, `Invoke-Expression`, or unusual parent/child process context.

### LSASS / ProcDump

Not every LSASS access event is credential theft. EDR, antivirus, backup tools, and legitimate security products may access sensitive processes. In this lab, the event was more suspicious because it was tied to ProcDump and an Atomic Red Team LSASS test.

### Kerberos 4769

Event ID 4769 is normal in Active Directory environments. Kerberoasting detection becomes stronger when ticket requests involve service accounts, unusual encryption types, abnormal volume, unusual client systems, or suspicious activity immediately before the request.

### Scheduled Tasks

Scheduled tasks are used by Windows and legitimate software constantly. Tuning should consider task name, command line, creator account, parent process, and whether the task appeared near other suspicious events.

### Security Log Clearing

Security log clearing is high-signal. Legitimate administrators may clear logs during maintenance or troubleshooting, but the action is suspicious when it follows execution, credential-access, or persistence activity.

## Containment

For a real incident with this sequence, immediate containment would be:

1. Isolate WS01 from the network.
2. Preserve Splunk logs and endpoint evidence.
3. Disable or reset credentials for accounts involved in the activity.
4. Review Domain Admins and other privileged groups.
5. Confirm whether `svc_sql` or other service accounts were exposed.
6. Hunt for the same indicators across other hosts.

## Eradication

Recommended eradication steps would include removing unauthorized scheduled tasks, deleting malicious tools or payloads, rotating potentially exposed credentials, reviewing service-account SPN usage, and rebuilding the endpoint if credential compromise is suspected.

## Recovery

Recovery would include returning WS01 to service only after validation, increasing monitoring for the affected accounts, confirming the five detections still fire on test data, and documenting any changes to audit policy or Splunk ingestion.

## Detection Gaps

This lab does not include full production EDR telemetry, DNS logs, proxy logs, cloud identity logs, network packet capture, or centralized asset inventory. The detections are valid for the lab, but a production investigation would need more context before making final conclusions.

The scheduled-task evidence relied more on Sysmon/PowerShell process telemetry than Security Event IDs 4698/4702. That should be documented as a logging gap or audit-policy tuning opportunity.

## Lessons Learned

The strongest part of the project is not that the attacks were run. The valuable part is validating that logs were generated, understanding which source captured which behavior, recognizing when Defender blocked activity, and documenting telemetry gaps honestly instead of forcing a clean-looking but false result.
