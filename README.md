# Enterprise SOC Detection & Incident Response Lab

## Executive Summary

This project is a small enterprise-style security monitoring lab built to practice the full SOC workflow: collecting endpoint telemetry, forwarding it into a SIEM, simulating attacker behavior, writing detections, validating those detections, and investigating related activity as a single incident.

The lab uses a Windows Active Directory environment, Splunk Enterprise, Sysmon, PowerShell logging, Windows Security auditing, Splunk Universal Forwarders, and Atomic Red Team. The goal is not simply to show that the virtual machines work. The goal is to show how telemetry moves from endpoints into Splunk and how that telemetry can be turned into useful detections and analyst conclusions.

## What This Project Demonstrates

- Windows Server Active Directory administration
- Domain-joined Windows endpoint configuration
- Enterprise-style network segmentation in a virtual lab
- Windows Security, PowerShell, System, and Sysmon telemetry collection
- Splunk Universal Forwarder deployment and index separation
- ATT&CK-aligned adversary simulation with Atomic Red Team
- SPL detection development
- Sigma detection engineering
- False-positive analysis and detection tuning
- Incident triage, scoping, timeline development, and remediation planning

## Architecture

| Host | Operating System | IP Address | Role |
|---|---|---:|---|
| DC01 | Windows Server 2022 | 10.10.10.10 | Active Directory Domain Services, DNS, DHCP |
| SPL01 | Ubuntu Server 24.04 | 10.10.10.20 | Splunk Enterprise |
| WS01 | Windows 11 | 10.10.10.30 | Domain workstation and attack target |
| KALI01 | Kali Linux | 10.10.10.40 | Optional attacker workstation |

Primary lab network: `10.10.10.0/24` on an isolated VMware host-only network.

SPL01 also uses a NAT-connected adapter for package and application downloads.

### Data Flow

```text
DC01 / WS01
    |
    | Windows Security + PowerShell + Sysmon + System
    v
Splunk Universal Forwarder
    |
    | TCP 9997
    v
SPL01 / Splunk Enterprise
    |
    +--> win
    +--> sysmon
    +--> pwsh
```

## Active Directory Environment

The domain is `corp.northgate.local` with NetBIOS name `NORTHGATE`.

The directory structure includes separate organizational units for users, workstations, servers, and service accounts. A dedicated service account named `svc_sql` is used to generate Kerberos service-ticket activity for controlled Kerberoasting detection testing.

## Logging Configuration

The lab enables additional Windows telemetry beyond the default operating-system logging baseline.

Key sources include:

| Source | Important Event IDs | Security Value |
|---|---|---|
| Windows Security | 4688, 4698, 4702, 4769, 1102 | Process creation, scheduled tasks, Kerberos activity, log clearing |
| PowerShell Operational | 4104 | Script block content |
| Sysmon | 1, 10 | Process creation and process access |
| System | Various | Operating-system and service context |

Additional configuration includes Advanced Audit Policy, command-line capture in process creation events, PowerShell Module Logging, PowerShell Script Block Logging, an expanded Security log size, and Sysmon with a hardened community configuration.

## Splunk Configuration

Splunk Enterprise runs on SPL01 and receives Windows telemetry from DC01 and WS01 over TCP 9997 using Splunk Universal Forwarders.

Telemetry is separated into three indexes:

- `win` — Windows Security and System events
- `sysmon` — Sysmon Operational events
- `pwsh` — PowerShell Operational events

Separating telemetry by source makes searches easier to reason about and avoids treating the entire lab as one undifferentiated event stream.

## Attack Simulations

The lab is designed around five controlled simulations mapped to MITRE ATT&CK:

| Detection | Technique | Tactic | Primary Evidence |
|---|---|---|---|
| DET-001 | T1059.001 PowerShell | Execution | Event 4104, Sysmon Event 1 |
| DET-002 | T1003.001 LSASS Memory | Credential Access | Sysmon Event 10 |
| DET-003 | T1558.003 Kerberoasting | Credential Access | Security Event 4769 |
| DET-004 | T1053.005 Scheduled Task | Persistence | Security Event 4698/4702, Sysmon Event 1 |
| DET-005 | T1070.001 Clear Windows Event Logs | Defense Evasion | Security Event 1102 |

Each simulation is intended to be executed separately, validated in Splunk, documented, cleaned up, and then converted into a repeatable detection.

## Detection Engineering

### DET-001 — Suspicious PowerShell

Purpose: detect suspicious PowerShell execution patterns that may indicate command obfuscation or script-based execution.

Relevant telemetry: PowerShell Script Block Logging and Sysmon process creation.

ATT&CK: T1059.001.

### DET-002 — LSASS Process Access

Purpose: identify processes requesting access to `lsass.exe`, a common credential-access behavior.

Relevant telemetry: Sysmon Event ID 10.

ATT&CK: T1003.001.

### DET-003 — Kerberoasting Activity

Purpose: identify suspicious Kerberos service-ticket requests associated with service-account targeting.

Relevant telemetry: Windows Security Event ID 4769.

ATT&CK: T1558.003.

### DET-004 — Scheduled Task Persistence

Purpose: identify creation or modification of scheduled tasks that could be used for persistence or execution.

Relevant telemetry: Security Event IDs 4698 and 4702, plus Sysmon process creation.

ATT&CK: T1053.005.

### DET-005 — Security Log Cleared

Purpose: identify clearing of the Windows Security event log, a high-signal defense-evasion behavior.

Relevant telemetry: Security Event ID 1102.

ATT&CK: T1070.001.

## Incident Investigation

The investigation portion of the project is structured as a simulated multi-stage intrusion rather than five unrelated alerts. The intended analyst workflow is:

```text
PowerShell execution
    -> LSASS access
    -> Kerberos service-ticket activity
    -> Scheduled-task persistence
    -> Security-log clearing
```

The investigation report focuses on timeline reconstruction, affected hosts and accounts, relevant event fields, false-positive analysis, ATT&CK mapping, containment, eradication, recovery, and detection gaps.

## False Positives and Tuning

A useful detection is not simply a query that returns events. Each rule should be evaluated for legitimate administrative behavior, expected software activity, missing context, and conditions that could produce false negatives.

The project emphasizes tuning detections against the lab's own telemetry rather than copying community rules without validating them.

## Limitations

This is a controlled home lab rather than a production enterprise network. It does not reproduce enterprise-scale event volume, EDR telemetry, cloud identity sources, production change-control procedures, or a real adversary operating unpredictably.

Atomic Red Team creates known test behavior, which is useful for validating telemetry and detection logic but does not prove a detection would identify every real-world implementation of the same ATT&CK technique.

## Repository Structure

```text
enterprise-soc-detection-lab/
├── README.md
├── references.md
├── configs/
├── docs/
├── attacks/
├── detections/
│   ├── sigma/
│   └── spl/
├── investigations/
└── screenshots/
```

## References

See [references.md](references.md).

## Evidence Screenshots

The `screenshots/` folder contains the evidence used for the project:

- Baseline Splunk ingestion by host: `01`, `02`, `03`
- Active Directory structure and domain membership: `04`, `05`, `06`
- Atomic/attack simulation evidence: `07` through `12`
- Final SOC dashboard: `13`

The `screenshots/extra/` folder contains troubleshooting and supporting proof, including Atomic Red Team setup, the blocked LSASS attempt, and the manual `wevtutil` log-clearing command.

## Finalization Notes

The repository includes the main documentation, detections, Sigma rules, SPL files, incident report, dashboard XML, helper scripts, and captured screenshots. Before making the repository public, copy sanitized Splunk forwarder/Sysmon configs into `configs/` and verify that no credentials, tokens, passwords, private keys, or secrets are committed.

Splunk dashboard and saved-search definitions are included under:

```text
splunk-app/enterprise_soc_detection_lab/
```

These can be imported into Splunk as a small local app, but each search should still be validated against the local field names.
