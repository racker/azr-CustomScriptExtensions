# Download the Clients
# Set Client Locations
$AgentMSI = 'https://containerd.blob.core.windows.net/tanium/InstallTanium.msi'
# Set the output names
$outputMSI = "D:\InstallTanium.msi"
# Create the Webclient object and download the files locally
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($AgentMSI, $outputMSI)
# Start the Install Process
Start-Process msiexec.exe -Wait -ArgumentList '/i "D:\InstallTanium.msi" /qn'