# Final Finish Guide

Use this file to finish the project without bouncing around.

## 1. Screenshots

The `screenshots/` folder already contains the lab evidence screenshots from the chat/uploaded files. Keep the main folder clean and keep troubleshooting screenshots in `screenshots/extra/`.

Required evidence screenshots:

- `01-splunk-sysmon-hosts.png` — copy this from your local folder; it was visible locally but not uploaded here.
- `02-splunk-windows-hosts.png`
- `03-splunk-powershell-hosts.png`
- `04-active-directory-ou-tree.png`
- `05-domain-users.png`
- `06-ws01-domain-joined.png`
- `07-atomic-powershell-4104.png`
- `08-atomic-powershell-sysmon.png`
- `09-lsass-access.png`
- `10-kerberoasting-4769.png`
- `11-scheduled-task.png`
- `12-security-log-cleared.png`
- `13-soc-dashboard.png`

## 2. Reports and alerts

Fastest option: install the included Splunk app from `splunk-app/enterprise_soc_detection_lab/` on SPL01.

On SPL01, copy the app folder to:

```bash
/opt/splunk/etc/apps/enterprise_soc_detection_lab
```

Then restart Splunk:

```bash
sudo /opt/splunk/bin/splunk restart
```

If the app does not load cleanly, manually create the five reports/alerts from `docs/06-splunk-reports-alerts.md`.

## 3. Config files

Still required before public GitHub publishing:

- `configs/ws01-inputs.conf`
- `configs/ws01-outputs.conf`
- `configs/dc01-inputs.conf`
- `configs/dc01-outputs.conf`
- `configs/sysmonconfig-export.xml`

Before committing, open each file and remove secrets, tokens, passwords, or environment-specific credentials.

## 4. GitHub

Create a repository named:

```text
enterprise-soc-detection-lab
```

Recommended upload path:

```bash
git init
git add .
git commit -m "Initialize enterprise SOC detection lab"
git branch -M main
git remote add origin https://github.com/Momoney007/enterprise-soc-detection-lab.git
git push -u origin main
```

Keep it private until configs are checked.

## 5. Final honesty notes

- Do not claim the LSASS dump succeeded. It was blocked by Defender, and that is documented.
- Do not claim Atomic Red Team ran T1070.001. The installed atomics folder did not contain it; equivalent telemetry was generated manually with `wevtutil cl Security`.
- If normal fake AD users were not created, create a few or clearly describe that `svc_sql` was the service account used for Kerberoasting.
