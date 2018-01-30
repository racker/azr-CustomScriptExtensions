$url = 'https://github.com/racker/azr-CustomScriptExtensions/raw/master/PackageManagement_x64.msi'
$output = "D:\PackageManagement_x64.msi"
$wc = New-Object System.Net.WebClient -ErrorAction SilentlyContinue
$wc.DownloadFile($url, $output)
Start-Process msiexec.exe -Wait -ArgumentList '/I "D:\PackageManagement_x64.msi" /quiet' -ErrorAction SilentlyContinue
Register-PSRepository -Name "PSGallery" –SourceLocation "https://www.powershellgallery.com/api/v2/" -InstallationPolicy Trusted -ErrorAction SilentlyContinue | Out-Null
Install-PackageProvider -Name NuGet -Source "https://www.nuget.org/api/v2/" -Force -ErrorAction SilentlyContinue | Out-Null
Find-Module -name SpeculationControl | Install-Module -Scope AllUsers -Force -Confirm:$False -ErrorAction SilentlyContinue | Out-Null
Get-SpeculationControlSettings