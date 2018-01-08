# A Custom Script Extension to Gather Windows Resgistry Data under the QualityCompat Key

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https:%2F%2Fraw.githubusercontent.com%2Fracker%2Fazr-CustomScriptExtensions%2Fmaster%2F100-Get-WindowsSpectreMeltdownAVKey%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https:%2F%2Fraw.githubusercontent.com%2Fracker%2Fazr-CustomScriptExtensions%2Fmaster%2F100-Get-WindowsSpectreMeltdownAVKey%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

Allows the owner of the Azure Virtual Machines to gather the Data in HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\QualityCompat to determine if the DWORD Value "cadca5fe-87d3-4b96-b7fb-a231484277cc" exists. 

Should the key not exist, the script accepts the Switch Parameter of "Fix" (True/False) which instructs the extension to either be run in Fix mode or Audit mode. 

## Deploy

1. Using Azure CLI

  https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-azure-resource-manager/

2. Using Powershell

  https://azure.microsoft.com/en-us/documentation/articles/powershell-azure-resource-manager/

3. Using Azure Portal
  Click the "Deploy to Azure" button.