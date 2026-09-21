$ErrorActionPreference = "Stop"

$zipUrl = "https://raw.githubusercontent.com/giovannipaganinitrading/gerenciamento-master/main/Gerenciamento_Master.zip"
$tempZip = Join-Path $env:TEMP "Gerenciamento_Master_Temp.zip"
$tempExtract = Join-Path $env:TEMP "Gerenciamento_Master_Extracted"

Write-Host ">>> Baixando Gerenciamento Master do GitHub..." -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing

if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

$terminalBase = "$env:APPDATA\MetaQuotes\Terminal"
$installedCount = 0

if (Test-Path $terminalBase) {
    $terminals = Get-ChildItem -Path $terminalBase -Directory | Where-Object { 
        Test-Path (Join-Path $_.FullName "MQL5\Experts") 
    }

    foreach ($terminal in $terminals) {
        $dest = Join-Path $terminal.FullName "MQL5\Experts\Gerenciamento Master"
        if (-not (Test-Path $dest)) {
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
        }
        
        Copy-Item -Path "$tempExtract\Gerenciamento Master\*" -Destination $dest -Recurse -Force
        Write-Host " [OK] Instalado com sucesso no terminal: $($terminal.Name)" -ForegroundColor Green
        $installedCount++
    }
}

Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

if ($installedCount -gt 0) {
    Write-Host "`n>>> [SUCESSO] RobÃ´ Gerenciamento Master instalado em $installedCount terminal(is) do MT5!" -ForegroundColor Green
    Write-Host ">>> Abra seu MetaTrader 5 e clique com o botÃ£o direito em 'Expert Advisors' -> 'Atualizar'." -ForegroundColor Yellow
} else {
    Write-Host "`n[AVISO] Nenhuma pasta de MetaTrader 5 foi detectada automaticamente." -ForegroundColor Red
}
