# === MAG API boot ===
Set-Alias mag-reload "$HOME\PythonProject\mag-webapp-v8\mag-api-smoke.ps1"

function mag-boot {
  . "$HOME\PythonProject\mag-webapp-v8\mag-api-smoke.ps1"
  $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"
  $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }
  $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id
  "OK: ambiente pronto."
}
# --- Array-safe helper ---
function As-Array($value){
  if ($null -eq $value) { return @() }
  if ($value -is [System.Array]) { return $value }
  return @($value)
}

# --- Get-Rentals array-safe (mantém suporte a status) ---
function Get-Rentals([string]$vehicleId=$null,[string]$status=$null,[int]$limit=200){
  $qs=@("tenantId=$Tenant","limit=$limit")
  if($vehicleId){ $qs+="vehicleId=$vehicleId" }
  if($status){    $qs+="status=$status" }
  $url = "/api/v1/rentals?$(($qs -join '&'))"
  As-Array ((GetJson $url).data)
}

# --- Show-RentalStatus com suporte a -Only e 0/1/N itens ---
function Show-RentalStatus([string]$vehicleId, [string]$Only = $null){
  $rentals = if($Only){ Get-Rentals -vehicleId $vehicleId -status $Only } else { Get-Rentals -vehicleId $vehicleId }
  $rentals = As-Array $rentals

  Write-Host "`n=== RELATÓRIO DE LOCAÇÕES ===" -ForegroundColor Cyan
  Write-Host "Veículo ID: $vehicleId" -ForegroundColor White
  if($Only){ Write-Host "Filtro: $Only" -ForegroundColor DarkGray }
  Write-Host ("Total: {0}" -f (($rentals | Measure-Object).Count)) -ForegroundColor White

  if($rentals.Count -gt 0){
    ($rentals | Group-Object status) | ForEach-Object {
      Write-Host ("  - {0}: {1}" -f $_.Name, $_.Count) -ForegroundColor Gray
    }

    $active = $rentals | Where-Object { $_.status -eq "confirmed" }
    if($active){
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

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# Show-RentalStatus (array-safe)

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


# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===
. C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1 




# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
function mag-boot {   . "$PWD\mag-api-smoke.ps1"   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell"   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" }   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id   "OK: ambiente pronto." } 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===
mag-boot 

# === patches array-safe & filtro -Only ===

# === patches array-safe & filtro -Only ===


function Get-SafeCount { param($x) ($x | Measure-Object).Count }

function As-Array {
  param($value)
  if ($null -eq $value) { return @() }
  if ($value -is [System.Array]) { return $value }
  return @($value)
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
