[cmdletbinding()]
param(
  [string]$ServiceName,
  [string]$vmid
)

Try {
  $Svc = Get-Service -Name $ServiceName -ErrorAction Stop
  #Format OMS Report Object
  $Message = New-Object PSObject ([ordered]@{
    Computer=$env:COMPUTERNAME
    SvcDisplay=$Svc.DisplayName
    SvcName=$Svc.Name
    SvcState=($Svc.Status).tostring()
    SvcStartType = ($Svc.StartType).ToString()
    ResourceId = $vmid
  })
  $MessageJSONString = [string]($Message | ConvertTo-JSON) 
  Write-Output -InputObject $MessageJSONString
  Remove-Variable -Name MessageJSONString,vmid,svc,Message,ServiceName -Force -ErrorAction SilentlyContinue | Out-Null
}
Catch [Microsoft.PowerShell.Commands.ServiceCommandException] {
  Write-Error -Exception $_.Exception -Message "$($_.TargetObject) Service Not Found"
  $Message = New-Object PSObject ([ordered]@{
    Computer = $env:COMPUTERNAME
    SvcDisplay = "Service Not Found"
    SvcName = $ServiceName
    SvcState = "Service Not Found"
    SvcStartType = "Service Not Found"
    ResourceId = $vmid
  })
  $MessageJSONString = [string]($Message | ConvertTo-JSON) 
  Write-Output -InputObject $MessageJSONString
  Remove-Variable -Name MessageJSONString,vmid,Message,ServiceName -Force -ErrorAction SilentlyContinue | Out-Null
}


