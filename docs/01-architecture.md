# Lab Architecture

## Hosts

| Host | OS | Role | IP |
|---|---|---|---:|
| DC01 | Windows Server 2022 | Active Directory, DNS, DHCP | 10.10.10.10 |
| SPL01 | Ubuntu Server 24.04 | Splunk Enterprise | 10.10.10.20 |
| WS01 | Windows 11 | Domain workstation / attack target | 10.10.10.30 |
| KALI01 | Kali Linux | Optional attacker host | 10.10.10.40 |

## Network

The core environment uses an isolated VMware host-only network on `10.10.10.0/24`.

VMware DHCP is disabled on that network so DHCP can be provided by DC01 instead of the hypervisor.

SPL01 also uses a NAT adapter for controlled Internet access when downloading packages or Splunk components.

## Security Design

The lab separates the infrastructure into distinct roles rather than running everything on one VM. That matters because detections become easier to reason about when authentication, endpoint, and SIEM activity occur on separate hosts.

## Data Flow

```text
WS01 / DC01
    ↓
Windows Security + PowerShell + Sysmon + System
    ↓
Splunk Universal Forwarder
    ↓ TCP 9997
SPL01 / Splunk Enterprise
    ↓
win / sysmon / pwsh indexes
```

The Universal Forwarder is used as the collection agent on Windows endpoints. Splunk Enterprise is the central analysis platform.
