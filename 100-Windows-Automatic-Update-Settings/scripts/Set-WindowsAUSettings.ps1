param(
  [ Parameter( 
    Position = 0, 
    Mandatory = $False, 
    ValueFromPipeline = $False)
  ]
  [ ValidateSet("Enabled", "Disabled") ]
  [string]$AutoUpdate="Enabled",
  [ Parameter( 
    Position = 1, 
    Mandatory = $False, 
    ValueFromPipeline = $False)
  ]
  [ ValidateSet("Notify before Download", "Download and Notify", "Download and Install", "User Configured") ]
  [string]$AUOptions="Download and Notify",
  [ Parameter( 
    Position = 2, 
    Mandatory = $False,
    ValueFromPipeline = $False)
  ]
  [ ValidateSet("Every Day", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday") ]
  [string]$ScheduledInstallDay,
  [ Parameter( 
    Position = 3, 
    Mandatory = $False,
    ValueFromPipeline = $False)
  ]
  [ ValidateSet(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23)]
  [int]$ScheduledInstallTime
)

$RegKey = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU"

switch ($AutoUpdate) {
  "Enabled" {
    [int]$AutoUpdate = 0
    switch ($AUOptions) {
      "Notify before Download" { [int]$AUOptions = 2; break }
      "Download and Notify" { [int]$AuOptions = 3; break }
      "Download and Install" { [int]$AuOptions = 4; break }
      "User Configured" { [int]$AuOptions = 5; break }
    }
    if ( $AUOptions -eq 4 ) {
      switch ($ScheduledInstallDay) {
        "Every Day" { [int]$ScheduledInstallDay = 0; break }
        "Sunday" { [int]$ScheduledInstallDay = 1; break }
        "Monday" { [int]$ScheduledInstallDay = 2; break }
        "Tuesday" { [int]$ScheduledInstallDay = 3; break }
        "Wednesday" { [int]$ScheduledInstallDay = 4; break }
        "Thursday" { [int]$ScheduledInstallDay = 5; break }
        "Friday" { [int]$ScheduledInstallDay = 6; break }
        "Saturday" { [int]$ScheduledInstallDay = 7; break }
      }
    }
    break 
  }
  "Disabled" { [int]$AutoUdpate = 1; break }
}


# Determine if the Key Exists
If ( (Test-Path $RegKey) -eq $false ) {
  # Determine if the Key one level up exists
  $RegKey = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate"
  if ( (Test-Path $RegKey) -eq $false ) {
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows" -Name "WindowsUpdate" -Force -ErrorAction Continue | Out-Null
    New-Item -Path $RegKey -Name "AU" -Force -ErrorAction Continue | Out-Null
    $RegKey = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
  }
  else {
    New-Item -Path $RegKey -Name "AU" -Force -ErrorAction Continue | Out-Null
    $RegKey = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
  }
}
# Perform the Work
switch ( $AutoUpdate ) {
  0 {
    try {
      Set-ItemProperty -Path $RegKey -Name NoAutoUpdate -Value $AutoUpdate -ErrorAction Continue | Out-Null
    }
    catch {
      New-ItemProperty -Path $RegKey -Name NoAutoUpdate -Value $AutoUpdate -PropertyType DWORD -Force -ErrorAction Continue | Out-Null
    }

    try {
      Set-ItemProperty -Path $RegKey -Name AUOptions -Value $AUOptions -ErrorAction Continue | Out-Null
    }
    catch {
      New-ItemProperty -Path $RegKey -Name AUOptions -Value $AUOptions -PropertyType DWORD -Force -ErrorAction Continue | Out-Null
    }

    if ( $AUOptions -eq 4 ) {
      try {
        Set-ItemProperty -Path $RegKey -Name ScheduledInstallDay -Value $ScheduledInstallDay -ErrorAction Continue | Out-Null
      }
      catch {
        New-ItemProperty -Path $RegKey -Name ScheduledInstallDay -Value $ScheduledInstallDay -PropertyType DWORD -Force -ErrorAction Continue | Out-Null
      }
      try {
        Set-ItemProperty -Path $RegKey -Name ScheduledInstallTime -Value $ScheduledInstallTime -ErrorAction Continue | Out-Null
      }
      catch {
        New-ItemProperty -Path $RegKey -Name ScheduledInstallTime -Value $ScheduledInstallTime -PropertyType DWORD -Force -ErrorAction Continue | Out-Null
      }
    }
    else {
      try {
        Remove-ItemProperty -Path $RegKey -Name ScheduledInstallDay -ErrorAction SilentlyContinue | Out-Null
        Remove-ItemProperty -Path $RegKey -Name ScheduledInstallTime -ErrorAction SilentlyContinue | Out-Null
      }
      catch {}
    }
    break
  }
  1 {
    try {
      Set-ItemProperty -Path $RegKey -Name NoAutoUpdate -Value $AutoUpdate -ErrorAction Continue | Out-Null
    }
    catch {
      New-ItemProperty -Path $RegKey -Name NoAutoUpdate -Value $AutoUpdate -PropertyType DWORD -Force -ErrorAction Continue | Out-Null
    }
    try {
      Remove-ItemProperty -Path $RegKey -Name AUOptions -ErrorAction Continue | Out-Null
      Remove-ItemProperty -Path $RegKey -Name ScheduledInstallDay -ErrorAction Continue | Out-Null
      Remove-ItemProperty -Path $RegKey -Name ScheduledInstallTime -ErrorAction Continue | Out-Null
    }
    catch {
    }
    break
  }
}

# Restart the Windows Update Service
Stop-Service -Name wuauserv -Force | Out-Null
Start-Service -Name wuauserv | Out-Null

# Gather the update settings from the registry
$ClientSettings = Get-ItemProperty $RegKey -ErrorAction SilentlyContinue
If ($ClientSettings -ne $null) {
  $Status = @{
    ComputerName         = $ENV:ComputerName
    AUOptions            = if ($ClientSettings.AUOptions -ne $null) { switch ($ClientSettings.AUOptions) { 2 { "Notify before Download"; break } 3 { "Download and Notify"; break } 4 { "Download and Install"; break } 5 { "User Configured"; break } } } else {"Not Configured"}
    ScheduledInstallDay  = if ($ClientSettings.ScheduledInstallDay -ne $null) { switch ($ClientSettings.ScheduledInstallDay) { 0 { "Every Day" } 1 { "Sunday" } 2 { "Monday" } 3 { "Tuesday" } 4 { "Wednesday" } 5 { "Thursday" } 6 { "Friday" } 7 { "Saturday" } } } else {"Not Configured"}
    ScheduledInstallTime = if ($ClientSettings.ScheduledInstallTime -ne $null) { if ($ClientSettings.ScheduledInstallTime -lt 13) { ($ClientSettings.ScheduledInstallTime).ToString() + ":00 AM" } else { ($ClientSettings.ScheduledInstallTime).ToString() + ":00 PM" } } else {"Not Configured"}
    AutoUpdateStatus     = if ($ClientSettings.NoAutoUpdate -ne $null) { if ($ClientSettings.NoAutoUpdate -eq 1) { "Disabled" } else { "Enabled" } } else {"Not Configured"}
  }
  $Status = $Status | ConvertTo-Json
}
else {
  $Status = "Registry Key $RegKey is null!"
}

Write-Output $Status

Remove-Variable -Name AutoUpdate,AUOptions,ScheduledInstallDay,ScheduledInstallTime,RegKey,ClientSettings,Status -Force -ErrorAction SilentlyContinue | Out-Null