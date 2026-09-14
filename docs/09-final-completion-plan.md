# Final Completion Plan

This is the compressed version of what is left.

## Block 1: Evidence cleanup

1. Rename the local folder `screenshot` to `screenshots`.
2. Put every numbered screenshot in `screenshots/`.
3. Add missing screenshots:
   - `05-domain-users.png`
   - any missing numbered Splunk screenshots from 01 through 13

## Block 2: Attack log

Open `attacks/execution-log.csv` and replace all `REPLACE_WITH_REAL_TIME` values with timestamps visible in the matching screenshots.

## Block 3: Reports and alerts

In Splunk, save the five detection searches as Reports and Alerts:

- DET-001 Suspicious PowerShell
- DET-002 LSASS Process Access
- DET-003 Kerberoasting Activity
- DET-004 Scheduled Task Persistence
- DET-005 Security Log Cleared

Alert settings:

- Scheduled
- Every hour
- Trigger when result count is greater than 0
- Add to Triggered Alerts

## Block 4: Tuning

Run the raw and tuned searches in `docs/07-false-positive-tuning.md` and replace the placeholder counts with real counts.

## Block 5: Config export

Copy these into `configs/`:

- `ws01-inputs.conf`
- `ws01-outputs.conf`
- `dc01-inputs.conf`
- `dc01-outputs.conf`
- `sysmonconfig-export.xml`

Check for secrets before publishing.

## Block 6: GitHub

Create the GitHub repo manually:

`enterprise-soc-detection-lab`

Then upload the project or push with Git.

Recommended commands:

```bash
git init
git add .
git commit -m "Initialize enterprise SOC detection lab"
git branch -M main
git remote add origin https://github.com/Momoney007/enterprise-soc-detection-lab.git
git push -u origin main
```
