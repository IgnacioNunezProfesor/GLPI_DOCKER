# Script para levantar el docker-compose de GLPI y OCS
# Este script levanta los contenedores de MariaDB, GLPI y OCS

param(
    [switch]$Build = $false,
    [switch]$Down = $false
)

# Obtener el directorio raíz del proyecto
$scriptPath = Split-Path -Parent $MyInvocation.MyCommandPath
$projectRoot = Split-Path -Parent $scriptPath
$dockerComposePath = Join-Path $projectRoot "docker" "docker-compose.glpi.yml"

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  GLPI + OCS Docker Compose Manager" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que el archivo docker-compose existe
if (-not (Test-Path $dockerComposePath)) {
    Write-Host "ERROR: No se encontró el archivo docker-compose.glpi.yml en: $dockerComposePath" -ForegroundColor Red
    exit 1
}

Write-Host "Ruta del docker-compose: $dockerComposePath" -ForegroundColor Yellow
Write-Host ""

# Detener y eliminar contenedores si se solicita
if ($Down) {
    Write-Host "Deteniendo contenedores..." -ForegroundColor Yellow
    docker compose -f $dockerComposePath down
    Write-Host "Contenedores detenidos." -ForegroundColor Green
    exit 0
}

# Levantar los servicios
if ($Build) {
    Write-Host "Levantando contenedores con rebuild..." -ForegroundColor Yellow
    docker compose -f $dockerComposePath up -d --build
} else {
    Write-Host "Levantando contenedores..." -ForegroundColor Yellow
    docker compose -f $dockerComposePath up -d
}

# Verificar si los contenedores se levantaron correctamente
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓ Contenedores levantados correctamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "Servicios disponibles:" -ForegroundColor Cyan
    Write-Host "  - GLPI:       http://localhost:8080" -ForegroundColor Green
    Write-Host "  - OCS:        http://localhost:8081" -ForegroundColor Green
    Write-Host ""
    Write-Host "Para ver los logs: docker compose -f '$dockerComposePath' logs -f" -ForegroundColor Yellow
    Write-Host "Para detener:     .\scripts\start-docker-compose.ps1 -Down" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "✗ Error al levantar los contenedores" -ForegroundColor Red
    Write-Host "Verifica los logs con: docker compose -f '$dockerComposePath' logs" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
