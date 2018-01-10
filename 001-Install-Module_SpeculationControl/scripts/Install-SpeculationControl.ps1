Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
Find-Module -name SpeculationControl | Install-Module -Scope AllUsers -Force -Confirm:$False | Out-Null
Get-SpeculationControlSettings