# Splunk Reports and Alerts

This lab used five detection searches mapped to MITRE ATT&CK behaviors. Each search should be saved twice in Splunk: once as a Report and once as a Scheduled Alert.

## Report and alert settings

For each detection:

1. Run the SPL search in Splunk Search & Reporting.
2. Click **Save As → Report**.
3. Use the detection name exactly as shown below.
4. Run the same search again.
5. Click **Save As → Alert**.
6. Use a scheduled alert, hourly schedule, and trigger when result count is greater than 0.
7. Do not configure email for this lab; using Triggered Alerts is enough.

## DET-001 Suspicious PowerShell

```spl
index=pwsh EventCode=4104
| search Message="*EncodedCommand*" OR Message="*-enc*" OR Message="*Invoke-Expression*" OR Message="*DownloadString*" OR Message="*Hello, from PowerShell*"
```

Purpose: detect suspicious or lab-generated PowerShell script block activity.

## DET-002 LSASS Process Access

```spl
index=sysmon host=WS01 earliest=-24h (procdump OR lsass OR TargetImage="*lsass.exe*")
```

Purpose: detect credential-access behavior involving LSASS or ProcDump telemetry. In this lab, Defender blocked completion, but Sysmon still captured the attempt.

## DET-003 Kerberoasting Activity

```spl
index=win EventCode=4769 earliest=-24h (svc_sql OR MSSQLSvc)
```

Purpose: detect service-ticket activity associated with the lab service account used for Kerberoasting validation.

## DET-004 Scheduled Task Persistence

Primary search:

```spl
index=win earliest=-24h (EventCode=4698 OR EventCode=4702)
```

Backup search if Windows task events are not visible:

```spl
index=sysmon earliest=-24h (schtasks OR "Schedule.Service" OR "scheduled task")
```

Purpose: detect scheduled task creation or modification used as persistence.

## DET-005 Security Log Cleared

```spl
(index=win EventCode=1102 earliest=-24h) OR (index=sysmon earliest=-24h (wevtutil OR Clear-EventLog OR "cl Security"))
```

Purpose: detect defense evasion through Windows Security log clearing or equivalent process telemetry.

## Notes

The alerts are intentionally simple because this is a controlled lab. In a production SOC, these would need suppression logic, allowlists, owner context, and severity routing.
