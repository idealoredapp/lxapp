# ============================================
# SCRIPT PARA SUBIR PROYECTO A GITHUB
# Ejecutar desde PowerShell en Windows
# ============================================

Write-Host "`n" -NoNewline
Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   SUBIR PROYECTO A GITHUB - PASO A PASO        ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "`n"

# Variables - MODIFICA ESTAS
$REPO_URL = Read-Host "Ingresa la URL de tu repositorio GitHub (ej: https://github.com/usuario/repo.git)"
$TU_NOMBRE = Read-Host "Tu nombre para Git (ej: Juan Pérez)"
$TU_EMAIL = Read-Host "Tu email para Git (ej: juan@ejemplo.com)"

Write-Host "`n=== Configurando Git ===" -ForegroundColor Yellow

# Configurar usuario
git config user.name "$TU_NOMBRE"
git config user.email "$TU_EMAIL"

Write-Host "✓ Usuario configurado: $TU_NOMBRE <$TU_EMAIL>" -ForegroundColor Green

Write-Host "`n=== Inicializando repositorio local ===" -ForegroundColor Yellow

# Verificar si ya existe .git
if (Test-Path ".git") {
    Write-Host "⚠ El repositorio ya está inicializado" -ForegroundColor Yellow
} else {
    git init
    Write-Host "✓ Repositorio inicializado" -ForegroundColor Green
}

Write-Host "`n=== Agregando archivos ===" -ForegroundColor Yellow

# Agregar todos los archivos
git add .
Write-Host "✓ Archivos agregados al staging" -ForegroundColor Green

# Mostrar qué se va a subir
Write-Host "`nArchivos que se subirán:" -ForegroundColor Cyan
git status --short

Write-Host "`n=== Creando primer commit ===" -ForegroundColor Yellow

# Hacer commit
git commit -m "feat: versión inicial del sistema de administración de servidores

- Menú principal con navegación modular
- Módulo de pruebas de rendimiento del servidor
- Módulo de gestión de Ceph
- Módulo de monitorización del sistema
- Documentación completa (README, CHANGELOG, CONTRIBUTING)
- Licencia MIT"

Write-Host "✓ Commit creado" -ForegroundColor Green

Write-Host "`n=== Configurando rama principal ===" -ForegroundColor Yellow

# Renombrar a main
git branch -M main
Write-Host "✓ Rama renombrada a 'main'" -ForegroundColor Green

Write-Host "`n=== Conectando con GitHub ===" -ForegroundColor Yellow

# Verificar si ya existe el remote
$remoteExists = git remote | Select-String -Pattern "origin"

if ($remoteExists) {
    Write-Host "⚠ Remote 'origin' ya existe. Eliminando..." -ForegroundColor Yellow
    git remote remove origin
}

# Agregar remote
git remote add origin $REPO_URL
Write-Host "✓ Repositorio remoto agregado: $REPO_URL" -ForegroundColor Green

Write-Host "`n=== Subiendo a GitHub ===" -ForegroundColor Yellow
Write-Host "Esto puede tardar unos segundos..." -ForegroundColor Cyan

# Push a GitHub
try {
    git push -u origin main
    Write-Host "`n✓ ¡Proyecto subido exitosamente a GitHub!" -ForegroundColor Green
} catch {
    Write-Host "`n✗ Error al subir. Es posible que necesites autenticarte." -ForegroundColor Red
    Write-Host "`nSi te pide contraseña, usa un Personal Access Token:" -ForegroundColor Yellow
    Write-Host "1. Ve a GitHub.com → Settings → Developer settings → Personal access tokens" -ForegroundColor Yellow
    Write-Host "2. Generate new token (classic)" -ForegroundColor Yellow
    Write-Host "3. Dale permiso 'repo'" -ForegroundColor Yellow
    Write-Host "4. Copia el token y úsalo como contraseña" -ForegroundColor Yellow
    exit
}

Write-Host "`n=== Creando versión inicial (tag) ===" -ForegroundColor Yellow

# Crear tag
git tag -a v1.0.0 -m "Versión 1.0.0 - Lanzamiento inicial"
git push origin v1.0.0

Write-Host "✓ Tag v1.0.0 creado y subido" -ForegroundColor Green

Write-Host "`n╔════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          ¡TODO LISTO!                          ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`nPuedes ver tu repositorio en:" -ForegroundColor Cyan
Write-Host $REPO_URL.Replace(".git", "") -ForegroundColor White

Write-Host "`n=== Próximos pasos ===" -ForegroundColor Yellow
Write-Host "1. Ve a tu repositorio en GitHub y verifica que todo esté correcto" -ForegroundColor White
Write-Host "2. Agrega una descripción y temas (topics) al repositorio" -ForegroundColor White
Write-Host "3. Para futuros cambios, usa: git add . && git commit -m 'mensaje' && git push" -ForegroundColor White

Write-Host "`nPresiona ENTER para salir..."
Read-Host
