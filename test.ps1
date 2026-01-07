# Auto-élévation en admin si pas déjà admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# === CONFIGURATION ===
Write-Host "=== Setup FPS Booster Auto-Start Admin ===" -ForegroundColor Cyan
Write-Host ""

# Demander le chemin du programme
$p = Read-Host "Entre le chemin COMPLET de ton FPS booster"

# Vérifier que le fichier existe
if (-not (Test-Path $p)) {
    Write-Host "ERREUR: Le fichier n'existe pas!" -ForegroundColor Red
    pause
    Exit
}

Write-Host "Configuration en cours..." -ForegroundColor Yellow

# Créer le script VBS pour bypass UAC
$v = "$env:APPDATA\FPSBooster.vbs"
"Set UAC = CreateObject(""Shell.Application""): UAC.ShellExecute ""$p"", """", """", ""runas"", 0" | Out-File $v -Encoding ASCII -Force

# Ajouter au registre de démarrage
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "FPSBooster" /t REG_SZ /d "wscript.exe ""$v""" /f | Out-Null

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "         CONFIGURATION TERMINEE!        " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Ton FPS booster sera maintenant lance en admin" -ForegroundColor Cyan
Write-Host "automatiquement a chaque demarrage de Windows!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Plus besoin de cliquer sur UAC!" -ForegroundColor Yellow
Write-Host ""
pause
