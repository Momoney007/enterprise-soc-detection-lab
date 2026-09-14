# Detection Catalog

| ID | Detection | ATT&CK | Primary Source | Severity |
|---|---|---|---|---|
| DET-001 | Suspicious PowerShell | T1059.001 | PowerShell 4104 | Medium |
| DET-002 | LSASS Process Access | T1003.001 | Sysmon 10 | High |
| DET-003 | Kerberoasting Activity | T1558.003 | Security 4769 | Medium |
| DET-004 | Scheduled Task Persistence | T1053.005 | Security 4698/4702 | Medium |
| DET-005 | Security Log Cleared | T1070.001 | Security 1102 | High |

The Sigma rules provide portable detection logic. The SPL files provide the Splunk implementation used in this lab.

Each detection should be validated against real telemetry from the lab before being treated as complete. Detection quality depends on the actual field names, normalization, benign baseline, and source configuration present in the environment.
