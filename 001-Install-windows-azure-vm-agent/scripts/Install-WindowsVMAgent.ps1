#Download link for the latest Azure Guest Agent (windows)

$Link="http://go.microsoft.com/fwlink/?LinkID=394789"

# Set download path D:\temp, if it doesn't exist - create it
$AzAgtPath="D:\temp"

if(!(Test-Path -Path $AzAgtPath )){
  New-Item -ItemType directory -Path $AzAgtPath
}

# Download and install
Start-BitsTransfer -Source $Link -Destination $AzAgtPath\WindowsAzureVmAgent.2.7.1198.778.rd_art_stable.160617-1120.fre.msi
Start-Process "D:\temp\WindowsAzureVmAgent.2.7.1198.778.rd_art_stable.160617-1120.fre.msi" -ArgumentList "/quiet"