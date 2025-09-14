# === config padrão (ajuste se necessário) ===
if(-not $script:MAG_BASE){ $script:MAG_BASE = $env:MAG_BASE; if(-not $script:MAG_BASE){ $script:MAG_BASE = "http://localhost:3000" } }
if(-not $Tenant){ $Tenant = $env:MAG_TENANT; if(-not $Tenant){ $Tenant = "dev" } }

function Get-SafeCount { param($x) ($x | Measure-Object).Count }

function As-Array {
  param($value)
  if($null -eq $value){ return @() }
  if($value -is [System.Array]){ return $value }
  return @($value)
}

function GetJson {
  param(
    [Parameter(Mandatory=$true)][string]$Path,
    [ValidateSet("GET","POST","PUT","PATCH","DELETE")][string]$Method = "GET",
    $Body = $null,
    [hashtable]$Headers = $null
  )
  $base = $script:MAG_BASE
  $uri  = ($Path -match '^https?://') ? $Path : ($base.TrimEnd('/') + $Path)

  $h = @{}
  if($Headers){ $h += $Headers }
  if($Tenant){ $h['X-Tenant-Id'] = "$Tenant" }
  if($AuthToken){ $h['Authorization'] = "Bearer $AuthToken" }

  $params = @{ Uri=$uri; Method=$Method; Headers=$h; ContentType='application/json' }
  if($Body){ $params.Body = ($Body | ConvertTo-Json -Depth 10) }

  Invoke-RestMethod @params
}

function Get-Rentals([string]$vehicleId=$null,[string]$status=$null,[int]$limit=200){
  $qs=@()
  if($Tenant){ $qs+="tenantId=$Tenant" }
  $qs+="limit=$limit"
  if($vehicleId){ $qs+="vehicleId=$vehicleId" }
  if($status){    $qs+="status=$status" }
  $url = "/api/v1/rentals?$(($qs -join '&'))"
  As-Array ((GetJson $url).data)
}

function Ensure-Client([string]$email,[string]$name){
  $qs=@()
  if($Tenant){ $qs+="tenantId=$Tenant" }
  $qs+="email=$([uri]::EscapeDataString($email))"
  $found = As-Array ((GetJson "/api/v1/clients?$(($qs -join '&'))").data)
  if($found.Count){ return $found[0] }
  $body=@{ email=$email; name=$name; tenantId=$Tenant }
  (GetJson "/api/v1/clients" -Method POST -Body $body).data
}

function Ensure-Vehicle([string]$plate,[hashtable]$props){
  $qs=@()
  if($Tenant){ $qs+="tenantId=$Tenant" }
  $qs+="plate=$([uri]::EscapeDataString($plate))"
  $found = As-Array ((GetJson "/api/v1/vehicles?$(($qs -join '&'))").data)
  if($found.Count){ return $found[0] }
  $body = @{ plate=$plate; tenantId=$Tenant } + $props
  (GetJson "/api/v1/vehicles" -Method POST -Body $body).data
}

function Ensure-ConfirmedRentalForVehicle([string]$vehicleId,[string]$clientId,[int]$days=2){
  $qs=@()
  if($Tenant){ $qs+="tenantId=$Tenant" }
  $qs += "vehicleId=$vehicleId","clientId=$clientId","status=confirmed","limit=1"
  $found = As-Array ((GetJson "/api/v1/rentals?$(($qs -join '&'))").data)
  if($found.Count){ return $found[0] }
  $s = Get-Date
  $e = $s.AddDays($days)
  $body=@{
    tenantId = $Tenant
    clientId = $clientId
    vehicleId= $vehicleId
    startDate= $s.ToString("o")
    endDate  = $e.ToString("o")
    status   = "confirmed"
  }
  (GetJson "/api/v1/rentals" -Method POST -Body $body).data
}

function Show-RentalStatus {
  param([string]$vehicleId, [string]$Only = $null)
  $rentals = if($Only){ Get-Rentals -vehicleId $vehicleId -status $Only } else { Get-Rentals -vehicleId $vehicleId }
  $rentals = As-Array $rentals
  $n = Get-SafeCount $rentals

  Write-Host "`n=== RELATÓRIO DE LOCAÇÕES ===" -ForegroundColor Cyan
  Write-Host "Veículo ID: $vehicleId" -ForegroundColor White
  if($Only){ Write-Host "Filtro: $Only" -ForegroundColor DarkGray }
  Write-Host ("Total: {0}" -f $n) -ForegroundColor White

  if($n -gt 0){
    ($rentals | Group-Object status) | ForEach-Object {
      Write-Host ("  - {0}: {1}" -f $_.Name, $_.Count) -ForegroundColor Gray
    }
    $active = $rentals | Where-Object { $_.status -eq "confirmed" }
    if(Get-SafeCount $active){
      Write-Host "`nAtivas:" -ForegroundColor Yellow
      $active | ForEach-Object {
        $s = Get-Date $_.startDate; $e = Get-Date $_.endDate
        Write-Host ("  {0} | {1} → {2}" -f $_.id.Substring(0,8), $s.ToString('dd/MM HH:mm'), $e.ToString('dd/MM HH:mm'))
      }
    }
  } else {
    Write-Host "  (sem resultados)" -ForegroundColor DarkGray
  }
}
