# Splunk Telemetry Pipeline

## Collection Path

```text
DC01 / WS01
    ↓
Splunk Universal Forwarder
    ↓
10.10.10.20:9997
    ↓
SPL01 / Splunk Enterprise
```

## Index Design

| Index | Data |
|---|---|
| `win` | Windows Security and System logs |
| `sysmon` | Microsoft-Windows-Sysmon/Operational |
| `pwsh` | Microsoft-Windows-PowerShell/Operational |

The indexes are separated by telemetry source so queries remain readable and so each data source can be validated independently.

## Forwarder Design

Splunk Universal Forwarder is installed on both DC01 and WS01. Each forwarder monitors the relevant Windows Event Log channels and sends data to SPL01 over TCP port 9997.

## Validation Strategy

The pipeline is validated in Splunk by confirming:

- both Windows hosts are present
- Sysmon events are arriving
- Windows Security events are arriving
- PowerShell Operational events are arriving
- the expected indexes contain the expected source types

This validation is important before running any attack simulations. If the logging pipeline is broken before testing begins, a missing detection cannot be distinguished from missing telemetry.
