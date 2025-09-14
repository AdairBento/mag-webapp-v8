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
Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro -Only ===`n$(Get-Clipboard)" # (ou cole manualmente no final do arquivo via notepad) . .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro -Only ===`n$(Get-Clipboard)" # (ou cole manualmente no final do arquivo via notepad) . .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1  Show-RentalStatus $vehicle.id Show-RentalStatus $vehicle.id -Only confirmed  # conferência direta Get-Rentals -vehicleId $vehicle.id -status confirmed | Select id,status | ft -AutoSize 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1  Show-RentalStatus $vehicle.id Show-RentalStatus $vehicle.id -Only confirmed  # conferência direta Get-Rentals -vehicleId $vehicle.id -status confirmed | Select id,status | ft -AutoSize 

# Show-RentalStatus (array-safe)
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


# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1 




# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

# === patches array-safe & filtro -Only ===
. .\mag-api-smoke.ps1 

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
PS C:\Users\adair\PythonProject\mag-webapp-v8> function mag-boot {                                       >>   . "$PWD\mag-api-smoke.ps1" >>   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell" >>   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" } >>   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id >>   "OK: ambiente pronto." >> } PS C:\Users\adair\PythonProject\mag-webapp-v8> mag-boot                                                                                                Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  .: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:62 Line |   62 |  . .\mag-api-smoke.ps1  Show-RentalStatus $vehicle.id Show-RentalStatu …      |    ~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  .: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:65 Line |   65 |  . .\mag-api-smoke.ps1  Show-RentalStatus $vehicle.id Show-RentalStatu …      |    ~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  param: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:68 Line |   68 |  param([string]$vehicleId, [string]$Only = $null)      |  ~~~~~      | The term 'param' is not recognized as a name of a cmdlet, function, script file, or executable program. Check the spelling of the name, or if        | a path was included, verify that the path is correct and try again. GetJson: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:24 Line |   24 |    As-Array ((GetJson $url).data)      |               ~~~~~~~      | The term 'GetJson' is not recognized as a name of a cmdlet, function, script file, or executable program. Check the spelling of the name, or         | if a path was included, verify that the path is correct and try again. Get-SafeCount: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:72 Line |   72 |    $n = Get-SafeCount $rentals      |         ~~~~~~~~~~~~~      | The term 'Get-SafeCount' is not recognized as a name of a cmdlet, function, script file, or executable program. Check the spelling of the            | name, or if a path was included, verify that the path is correct and try again.  === RELATÓRIO DE LOCAÇÕES === Veículo ID: Total:   (sem resultados) Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  .: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:62 Line |   62 |  . .\mag-api-smoke.ps1  Show-RentalStatus $vehicle.id Show-RentalStatu …      |    ~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  .: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:62 Line |   62 |  . .\mag-api-smoke.ps1  Show-RentalStatus $vehicle.id Show-RentalStatu …      |    ~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  

# === patches array-safe & filtro -Only ===
PS C:\Users\adair\PythonProject\mag-webapp-v8> function mag-boot {                                       >>   . "$PWD\mag-api-smoke.ps1" >>   $global:client  = Ensure-Client  "teste.powershell@example.com" "Cliente PowerShell" >>   $global:vehicle = Ensure-Vehicle "PWR-2024" @{ brand="Toyota"; model="Corolla"; year=2024; dailyRate="150.00"; color="Branco" } >>   $global:rental  = Ensure-ConfirmedRentalForVehicle $vehicle.id $client.id >>   "OK: ambiente pronto." >> } PS C:\Users\adair\PythonProject\mag-webapp-v8> mag-boot                                                                                                Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  .: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:62 Line |   62 |  . .\mag-api-smoke.ps1  Show-RentalStatus $vehicle.id Show-RentalStatu …      |    ~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  .: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:65 Line |   65 |  . .\mag-api-smoke.ps1  Show-RentalStatus $vehicle.id Show-RentalStatu …      |    ~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  param: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:68 Line |   68 |  param([string]$vehicleId, [string]$Only = $null)      |  ~~~~~      | The term 'param' is not recognized as a name of a cmdlet, function, script file, or executable program. Check the spelling of the name, or if        | a path was included, verify that the path is correct and try again. GetJson: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:24 Line |   24 |    As-Array ((GetJson $url).data)      |               ~~~~~~~      | The term 'GetJson' is not recognized as a name of a cmdlet, function, script file, or executable program. Check the spelling of the name, or         | if a path was included, verify that the path is correct and try again. Get-SafeCount: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:72 Line |   72 |    $n = Get-SafeCount $rentals      |         ~~~~~~~~~~~~~      | The term 'Get-SafeCount' is not recognized as a name of a cmdlet, function, script file, or executable program. Check the spelling of the            | name, or if a path was included, verify that the path is correct and try again.  === RELATÓRIO DE LOCAÇÕES === Veículo ID: Total:   (sem resultados) Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  .: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:62 Line |   62 |  . .\mag-api-smoke.ps1  Show-RentalStatus $vehicle.id Show-RentalStatu …      |    ~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  .: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:62 Line |   62 |  . .\mag-api-smoke.ps1  Show-RentalStatus $vehicle.id Show-RentalStatu …      |    ~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:56 Line |   56 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  Add-Content: C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1:59 Line |   59 |  Add-Content .\mag-api-smoke.ps1 "`n# === patches array-safe & filtro  …      |  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      | The process cannot access the file 'C:\Users\adair\PythonProject\mag-webapp-v8\mag-api-smoke.ps1' because it is being used by another process.  
