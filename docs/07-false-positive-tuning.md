# False-Positive Tuning Notes

This file records the tuning work for two detections. Do not invent counts. Use the counts actually seen in Splunk.

## DET-001 Suspicious PowerShell

Raw validation search:

```spl
index=pwsh host=WS01 EventCode=4104 earliest=-60m
```

Observed raw count from screenshot: `44` events.

Tuned search:

```spl
index=pwsh EventCode=4104 earliest=-24h
| search Message="*EncodedCommand*" OR Message="*-enc*" OR Message="*Invoke-Expression*" OR Message="*DownloadString*"
```

Tuning notes:

- Raw 4104 events are useful for visibility but too broad as an alert.
- The tuned detection focuses on higher-risk PowerShell behaviors and suspicious command patterns.
- Legitimate software deployment or admin scripts may still trigger this rule.
- Additional context to review: user, host, parent process, command line, and timing.

Before tuning: `44` events in the validation window.  
After tuning: `REPLACE_WITH_TUNED_COUNT` events.  
Atomic still detected: `REPLACE_WITH_YES_OR_NO`.

## DET-004 Scheduled Task Persistence

Raw validation search used during evidence collection:

```spl
index=sysmon host=WS01 earliest=-30m (schtasks OR "Scheduled Task" OR powershell)
```

Observed raw count from screenshot: `107` events.

Tuned candidate:

```spl
index=sysmon host=WS01 earliest=-30m (schtasks OR "Scheduled Task")
```

Alternative Windows Security search:

```spl
index=win host=WS01 earliest=-24h (EventCode=4698 OR EventCode=4702)
```

Tuning notes:

- The broad query catches too much PowerShell and Splunk forwarder noise.
- Scheduled task detection should focus on task creation/modification fields, `schtasks.exe`, suspicious task names, suspicious users, and command-line content.
- Legitimate software installers and Windows maintenance tasks can create scheduled tasks.

Before tuning: `107` events in the broad validation window.  
After tuning: `REPLACE_WITH_TUNED_COUNT` events.  
Atomic still detected: `REPLACE_WITH_YES_OR_NO`.
