# Logging Baseline

Default Windows logging is not enough for the detection goals in this lab. Additional auditing is enabled so attacker behavior leaves useful evidence.

## Log Sources

| Source | Event IDs | Purpose |
|---|---|---|
| Windows Security | 4688 | Process creation |
| Windows Security | 4698 / 4702 | Scheduled task creation and modification |
| Windows Security | 4769 | Kerberos service-ticket requests |
| Windows Security | 1102 | Security audit log cleared |
| PowerShell Operational | 4104 | PowerShell script block contents |
| Sysmon | 1 | Detailed process creation |
| Sysmon | 10 | Process access, including access to LSASS |
| System | Various | Service and OS context |

## Audit Policy

Advanced Audit Policy is enabled for security-relevant categories including Kerberos operations, credential validation, account management, process creation, logon activity, and audit-policy changes.

## Command-Line Logging

Process creation auditing is configured to include command-line arguments. This adds critical context to Event ID 4688 and makes it possible to distinguish a benign process launch from a suspicious invocation.

## PowerShell Logging

PowerShell Module Logging and Script Block Logging are enabled. Script Block Logging produces Event ID 4104 and provides visibility into script contents that may not be obvious from process creation alone.

## Security Log Capacity

The Security log is increased to reduce the risk of useful evidence being overwritten during testing.

## Sysmon

Sysmon is installed on the Windows systems to provide higher-fidelity process and process-access telemetry. A community-maintained configuration is used as a practical baseline because it provides broad coverage without requiring a complete custom Sysmon policy to be designed from scratch.
