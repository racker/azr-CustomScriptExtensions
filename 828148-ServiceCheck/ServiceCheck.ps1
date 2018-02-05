[cmdletbinding()]
param(
  [string[]]$ServiceName,
  [string]$vmid
)

Try {
  $Svc = Get-Service -Name $ServiceName.split(',').trim() -ErrorAction Stop
  #Format OMS Report Object
  $Message = @(ForEach ($Service in $Svc) {
    $Report = New-Object PSObject -Property ([ordered]@{
      Computer=$env:COMPUTERNAME
      SvcDisplay=$Service.DisplayName
      SvcName=$Service.Name
      SvcState=($Service.Status).tostring()
      SvcStartType = ($Service.StartType).tostring()
      ResourceId = $vmid
    })
    $Report
  })
  $MessageJSONString = [string]($Message | ConvertTo-JSON) 
  Write-Output -InputObject $MessageJSONString
  Remove-Variable -Name MessageJSONString,vmid,svc,Message,ServiceName,Report -Force -ErrorAction SilentlyContinue | Out-Null
}
Catch [Microsoft.PowerShell.Commands.ServiceCommandException] {
  Write-Error -Exception $_.Exception -Message "$($_.TargetObject) Service Not Found"
  $Message = @(ForEach ($Service in $Svc) {
    New-Object PSObject ([ordered]@{
      Computer=$env:COMPUTERNAME
      SvcDisplay=$Svc.DisplayName
      SvcName=$Svc.Name
      SvcState=($Svc.Status).tostring()
      SvcStartType = ($Svc.StartType).ToString()
      ResourceId = $vmid
    })
  })
  $MessageJSONString = [string]($Message | ConvertTo-JSON) 
  Write-Output -InputObject $MessageJSONString
  Remove-Variable -Name MessageJSONString,vmid,Message,ServiceName -Force -ErrorAction SilentlyContinue | Out-Null
}


