# Determine Windows OS Version
Set-ExecutionPolicy Unrestricted -Force | out-null
$WindowsVersion = (Get-WmiObject -class Win32_OperatingSystem).Caption
if ($WindowsVersion -like "*2008 R2*"){
  # Check for .Net Version
  $NetRegKey = Get-Childitem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
  $Release = $NetRegKey.GetValue("Release")
  Switch ($Release) {
    378389 {$NetFrameworkVersion = "4.5"}
    378675 {$NetFrameworkVersion = "4.5.1"}
    378758 {$NetFrameworkVersion = "4.5.1"}
    379893 {$NetFrameworkVersion = "4.5.2"}
    393295 {$NetFrameworkVersion = "4.6"}
    393297 {$NetFrameworkVersion = "4.6"}
    394254 {$NetFrameworkVersion = "4.6.1"}
    394271 {$NetFrameworkVersion = "4.6.1"}
    394802 {$NetFrameworkVersion = "4.6.2"}
    394806 {$NetFrameworkVersion = "4.6.2"}
    Default {$NetFrameworkVersion = "Net Framework 4.5 or later is not installed."}
  }
  # If 4.5.2 or higher is installed, download the WMF5 package
  if( [System.Version]$NetFrameworkVersion -ge [System.Version]"4.5.2" ){
    # Enable WinRM
    Set-WSManQuickConfig -Force | out-null
    # Download the Update Package
    $url = 'https://github.com/racker/azr-CustomScriptExtensions/raw/master/001-Install-WMF_5_1/Win7AndW2K8R2-KB3191566-x64.zip'
    $output = "D:\Win7AndW2K8R2-KB3191566-x64.zip"
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $output)
    # Unzip the Package
    $shell = New-Object -ComObject shell.application
    $zip = $shell.NameSpace($output)
    foreach ($item in $zip.items()) {
      $shell.Namespace("D:\").CopyHere($item)
    }
    $Script = [scriptblock]::Create("D:\Install-WMF5.1.ps1 -AcceptEULA")
    Invoke-Command -ScriptBlock $Script
    Set-ExecutionPolicy RemoteSigned -Force | out-null
  }
  else{
    Write-Output "WMF 5.1 Requires at least .Net 4.5.2, found $NetFrameworkVersion"
  }
}
if ($WindowsVersion -like "*2012 R2*"){
  # Download the Update Package
  $url = 'https://github.com/racker/azr-CustomScriptExtensions/raw/master/001-Install-WMF_5_1/Win8.1AndW2K12R2-KB3191564-x64.msu'
  $output = "D:\Win8.1AndW2K12R2-KB3191564-x64.msu"
  $wc = New-Object System.Net.WebClient
  $wc.DownloadFile($url, $output)
  $Update = Get-Item -Path $output
  $FileTime = Get-Date -format 'yyyy.MM.dd-HH.mm'
  if (!(Test-Path $env:systemroot\SysWOW64\wusa.exe)){
    $Wus = "$env:systemroot\System32\wusa.exe"
  }
  else {
    $Wus = "$env:systemroot\SysWOW64\wusa.exe"
  }
  
  if (!(Test-Path $env:HOMEDRIVE\Temp)){
    New-Item $env:HOMEDRIVE\Temp
  }
  
  if (Test-Path $env:HOMEDRIVE\Temp\Wusa.evtx){
    Rename-Item $env:HOMEDRIVE\Temp\Wusa.evtx $env:HOMEDRIVE\Temp\Wusa.$FileTime.evtx
  }
  Start-Process -FilePath $Wus -ArgumentList ($Update.FullName, '/quiet', '/norestart', "/log:$env:HOMEDRIVE\Temp\Wusa.log") -Wait
  if (Test-Path $env:HOMEDRIVE\Temp\Wusa.log){
    Rename-Item $env:HOMEDRIVE\Temp\Wusa.log $env:HOMEDRIVE\Temp\Wusa.$FileTime.evtx
  }
}