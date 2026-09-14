# Optional helper: run on WS01 after replacing placeholder times below.
$Path = "C:\Lab\attacks\execution-log.csv"
$Rows = @(
"timestamp_utc,technique_id,test_number,host,user,description,expected_artifact,observed_event_ids,detection_fired,cleanup_complete",
"2026-09-12T18:46:52Z,T1059.001,17,WS01,NORTHGATE\Administrator,Atomic PowerShell command execution test,PowerShell script block logging and Sysmon process telemetry,PowerShell EventCode 4104 and Sysmon EventCode 1 observed,Yes,Yes",
"2026-09-12T18:56:15Z,T1003.001,1,WS01,NORTHGATE\Administrator,Atomic ProcDump LSASS memory dump test,LSASS/procdump telemetry,Sysmon ProcDump telemetry observed; Defender blocked with Access Denied,Partial,Yes",
"REPLACE_WITH_REAL_TIME,T1558.003,1,WS01,NORTHGATE\Administrator,Kerberoasting service ticket request simulation,Kerberos service-ticket event on DC01,Windows Security EventCode 4769 observed,Yes,Yes",
"REPLACE_WITH_REAL_TIME,T1053.005,1,WS01,NORTHGATE\Administrator,Scheduled task persistence simulation,Scheduled task creation and process telemetry,EventCode 4698/4702 or Sysmon schtasks telemetry observed,Yes,Yes",
"REPLACE_WITH_REAL_TIME,T1070.001,manual,WS01,NORTHGATE\Administrator,Security log clearing simulation using wevtutil,Audit log cleared event and/or wevtutil process telemetry,EventCode 1102 or Sysmon wevtutil telemetry observed,Yes,Not applicable"
)
$Rows | Set-Content $Path -Encoding UTF8
Write-Host "Wrote execution log template to $Path"
