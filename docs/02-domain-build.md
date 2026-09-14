# Active Directory Domain Build

## Domain

- DNS domain: `corp.northgate.local`
- NetBIOS: `NORTHGATE`
- Domain controller: `DC01`

## Organizational Units

The domain is organized into a top-level `Corp` OU with separate child OUs for:

- Users
- Workstations
- Servers
- ServiceAccounts

This layout provides a cleaner administrative structure and makes it easier to apply policy to systems based on their role.

## Workstation

`WS01` is joined to `corp.northgate.local` and is used as the primary Windows workstation and controlled attack target.

## Service Account

A service account named `svc_sql` is used to create realistic Kerberos service-ticket behavior. It is assigned a Service Principal Name so Kerberoasting telemetry can be generated and detected in a controlled lab scenario.

The security value of this configuration is not the weak service account itself. The value is being able to generate and analyze Windows Event ID 4769 activity associated with service-ticket requests.
