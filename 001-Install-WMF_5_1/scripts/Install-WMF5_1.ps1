$url = 'https://github.com/racker/azr-CustomScriptExtensions/raw/master/PackageManagement_x64.msi'
$output = "D:\PackageManagement_x64.msi"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)
Start-Process msiexec.exe -Wait -ArgumentList '/I "D:\PackageManagement_x64.msi" /quiet'
Register-PSRepository -Name "PSGallery" –SourceLocation "https://www.powershellgallery.com/api/v2/" -InstallationPolicy Trusted | Out-Null
Install-PackageProvider -Name NuGet -Source "https://www.nuget.org/api/v2/" -Force | Out-Null
Find-Module -name SpeculationControl | Install-Module -Scope AllUsers -Force -Confirm:$False | Out-Null
Get-SpeculationControlSettings