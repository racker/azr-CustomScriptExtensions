# Get-WindowsSpectreMeltdownAVKey_scriptextension

param(
  [ Parameter( 
    Position = 0, 
    Mandatory = $True, 
    ValueFromPipeline = $False)
  ]
  [switch]$Fix=$False
)
$ClientSettings = @{
  ComputerName         = $ENV:ComputerName
  KeyAlreadyExists     = $null
  ValueAlreadyExists   = $null
  Value                = $null
  RegistryModified     = $null
}

$RegKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\QualityCompat"

# Perform the Work
switch ( $Fix ) {
  True {
    # Steps to take in remediation mode.
    # Determine if the Key Exists, if it does move on.
    If ( (Test-Path $RegKey) -eq $false ) {
      # Determine if the Key one level up exists
      $RegKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion"
      if ( (Test-Path $RegKey) -eq $false ) {
        # If it doesn't exist, make it
        New-Item -Path "HKLM:\Software\Microsoft\Windows" -Name "CurrentVersion" -Force -ErrorAction Continue | Out-Null
        New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion" -Name "QualityCompat" -Force -ErrorAction Continue | Out-Null
        $RegKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\QualityCompat"
        $ClientSettings.KeyAlreadyExists = $false
      }
      else {
        # If it does exist, create the QualityCompat subkey
        New-Item -Path $RegKey -Name "QualityCompat" -Force -ErrorAction Continue | Out-Null
        $RegKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\QualityCompat"
        $ClientSettings.KeyAlreadyExists = $false
      }
    }
    else{
      $ClientSettings.KeyAlreadyExists = $true
    }

    # Check to see if the Value Exists
    if ((Get-Item -Path $RegKey).Property -contains 'cadca5fe-87d3-4b96-b7fb-a231484277cc'){
        $ClientSettings.ValueAlreadyExists = $true
        Set-ItemProperty -Path $RegKey -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -Value "0" -ErrorAction Continue | Out-Null
        $ClientSettings.Value = Get-ItemPropertyValue -Path $RegKey -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc"
        $ClientSettings.RegistryModified = $true
      }
    else{
      $ClientSettings.ValueAlreadyExists = $false
      New-ItemProperty -Path $RegKey -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -Value "0" -PropertyType DWORD -Force -ErrorAction Continue | Out-Null
      $ClientSettings.Value = Get-ItemPropertyValue -Path $RegKey -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc"
      $ClientSettings.RegistryModified = $true
    }
    break # Escape the Switch
  }
  False {
    # Steps to take in Audit mode.
    # Check for the Key
    If ( (Test-Path $RegKey) -eq $false ) {
      $ClientSettings.KeyAlreadyExists = $false
      $ClientSettings.Value = $null
      $ClientSettings.ValueAlreadyExists = $false
      $ClientSettings.RegistryModified = $false
    }
    else{
      if ((Get-Item -Path $RegKey).Property -contains 'cadca5fe-87d3-4b96-b7fb-a231484277cc'){
        $ClientSettings.KeyAlreadyExists = $true
        $ClientSettings.Value = Get-ItemPropertyValue -Path $RegKey -Name 'cadca5fe-87d3-4b96-b7fb-a231484277cc'
        $ClientSettings.ValueAlreadyExists = $true
        $ClientSettings.RegistryModified = $false
      }
      else{
        $ClientSettings.KeyAlreadyExists = $true
        $ClientSettings.Value = $null
        $ClientSettings.ValueAlreadyExists = $false
        $ClientSettings.RegistryModified = $false
      }
    }
    break
  }
}

Write-Output $ClientSettings

Remove-Variable -Name Fix,RegKey,ClientSettings -Force -ErrorAction SilentlyContinue | Out-Null