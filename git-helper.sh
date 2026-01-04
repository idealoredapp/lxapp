#!/bin/bash

##############################################
# Script de Comandos Rápidos de Git
# Automatiza tareas comunes de Git
##############################################

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   GIT - COMANDOS RÁPIDOS               ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""

# Función para nueva versión PATCH (bug fix)
nueva_version_patch() {
    echo -e "${YELLOW}=== Nueva Versión PATCH (Bug Fix) ===${NC}"
    read -p "Descripción del bug corregido: " descripcion
    
    git add .
    git commit -m "fix: $descripcion"
    
    # Obtener última versión
    ultima_version=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
    echo "Última versión: $ultima_version"
    
    # Incrementar PATCH
    IFS='.' read -ra VERSION <<< "${ultima_version#v}"
    nueva_ver="v${VERSION[0]}.${VERSION[1]}.$((VERSION[2] + 1))"
    
    echo "Nueva versión: $nueva_ver"
    read -p "¿Crear tag $nueva_ver? (s/n): " confirmar
    
    if [[ $confirmar == "s" ]]; then
        git tag -a $nueva_ver -m "Versión $nueva_ver: $descripcion"
        git push origin main
        git push origin $nueva_ver
        echo -e "${GREEN}✓ Versión $nueva_ver publicada${NC}"
    fi
}

# Función para nueva versión MINOR (nueva característica)
nueva_version_minor() {
    echo -e "${YELLOW}=== Nueva Versión MINOR (Nueva Característica) ===${NC}"
    read -p "Descripción de la nueva característica: " descripcion
    
    git add .
    git commit -m "feat: $descripcion"
    
    # Obtener última versión
    ultima_version=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
    echo "Última versión: $ultima_version"
    
    # Incrementar MINOR
    IFS='.' read -ra VERSION <<< "${ultima_version#v}"
    nueva_ver="v${VERSION[0]}.$((VERSION[1] + 1)).0"
    
    echo "Nueva versión: $nueva_ver"
    read -p "¿Crear tag $nueva_ver? (s/n): " confirmar
    
    if [[ $confirmar == "s" ]]; then
        git tag -a $nueva_ver -m "Versión $nueva_ver: $descripcion"
        git push origin main
        git push origin $nueva_ver
        echo -e "${GREEN}✓ Versión $nueva_ver publicada${NC}"
    fi
}

# Función para commit rápido
commit_rapido() {
    echo -e "${YELLOW}=== Commit Rápido ===${NC}"
    git status
    echo ""
    read -p "Mensaje del commit: " mensaje
    
    git add .
    git commit -m "$mensaje"
    git push
    
    echo -e "${GREEN}✓ Cambios publicados${NC}"
}

# Función para ver historial
ver_historial() {
    echo -e "${YELLOW}=== Historial de Commits ===${NC}"
    git log --oneline --graph --decorate --all -n 20
}

# Función para ver estado
ver_estado() {
    echo -e "${YELLOW}=== Estado del Repositorio ===${NC}"
    git status
    echo ""
    echo "Rama actual: $(git branch --show-current)"
    echo "Último commit: $(git log -1 --pretty=format:'%h - %s (%cr)')"
}

# Función de inicialización (primera vez)
inicializar_repo() {
    echo -e "${YELLOW}=== Inicializar Repositorio ===${NC}"
    echo ""
    read -p "URL del repositorio en GitHub: " repo_url
    
    git init
    git add .
    git commit -m "feat: versión inicial del sistema de administración de servidores"
    git branch -M main
    git remote add origin $repo_url
    git push -u origin main
    
    # Crear tag inicial
    git tag -a v1.0.0 -m "Versión 1.0.0 - Lanzamiento inicial"
    git push origin v1.0.0
    
    echo -e "${GREEN}✓ Repositorio inicializado y publicado${NC}"
}

# Menú principal
echo "1) Inicializar repositorio (primera vez)"
echo "2) Commit rápido"
echo "3) Nueva versión PATCH (bug fix)"
echo "4) Nueva versión MINOR (nueva característica)"
echo "5) Ver historial"
echo "6) Ver estado"
echo "0) Salir"
echo ""
read -p "Selecciona una opción: " opcion

case $opcion in
    1) inicializar_repo ;;
    2) commit_rapido ;;
    3) nueva_version_patch ;;
    4) nueva_version_minor ;;
    5) ver_historial ;;
    6) ver_estado ;;
    0) exit 0 ;;
    *) echo "Opción inválida" ;;
esac
