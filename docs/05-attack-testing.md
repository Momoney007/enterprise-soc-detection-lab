# Controlled Attack Testing Method

The project uses Atomic Red Team to generate repeatable ATT&CK-mapped behavior in a controlled lab.

## Test Sequence

1. Review the Atomic test definition.
2. Verify prerequisites.
3. Execute one test only.
4. Record the UTC execution time.
5. Search Splunk for the expected telemetry.
6. Validate the relevant fields.
7. Capture evidence.
8. Record the result in the execution log.
9. Run cleanup.
10. Confirm cleanup before continuing.

## Technique Coverage

| Technique | Purpose | Expected Evidence |
|---|---|---|
| T1059.001 | PowerShell execution | PowerShell 4104, Sysmon 1 |
| T1003.001 | LSASS access | Sysmon 10 |
| T1558.003 | Kerberoasting | Security 4769 |
| T1053.005 | Scheduled Task | Security 4698/4702, Sysmon 1 |
| T1070.001 | Security log clearing | Security 1102 |

## Testing Principle

The simulations are intentionally run one at a time so each behavior can be tied to its telemetry and detection result. Running all techniques at once would make the evidence less precise and would weaken the ability to explain exactly why a rule fired.

## Cleanup and Rollback

Virtual-machine snapshots are used as a safety boundary before testing. Atomic cleanup procedures are used after each simulation so the lab returns to a known state before the next technique is executed.
