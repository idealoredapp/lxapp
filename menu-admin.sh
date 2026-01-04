#!/bin/bash

#########################################
# Script de Administración de Sistemas
# Menú Principal con Submenús Modulares
#########################################

# Colores para mejorar la visualización
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para mostrar el encabezado
mostrar_encabezado() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   SISTEMA DE ADMINISTRACIÓN DE SERVIDORES      ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Función para pausar y esperar entrada del usuario
pausar() {
    echo ""
    read -p "Presiona ENTER para continuar..."
}

#########################################
# SUBMENÚ 1: PRUEBAS DE RENDIMIENTO
#########################################
submenu_rendimiento() {
    while true; do
        mostrar_encabezado
        echo -e "${GREEN}=== PRUEBAS DE RENDIMIENTO DEL SERVIDOR ===${NC}"
        echo ""
        echo "1) Test de CPU"
        echo "2) Test de Memoria RAM"
        echo "3) Test de Disco (I/O)"
        echo "4) Test de Red"
        echo "5) Test Completo"
        echo "6) Actualizar Herramientas de Benchmarking"
        echo "0) Volver al Menú Principal"
        echo ""
        read -p "Selecciona una opción: " opcion

        case $opcion in
            1)
                mostrar_encabezado
                echo -e "${YELLOW}=== Test de CPU ===${NC}"
                echo "Ejecutando prueba de CPU con sysbench..."
                if command -v sysbench &> /dev/null; then
                    sysbench cpu --cpu-max-prime=20000 run
                else
                    echo -e "${RED}sysbench no está instalado. Instala con: sudo apt install sysbench${NC}"
                fi
                pausar
                ;;
            2)
                mostrar_encabezado
                echo -e "${YELLOW}=== Test de Memoria RAM ===${NC}"
                echo "Mostrando información de memoria..."
                free -h
                echo ""
                echo "Prueba de memoria con sysbench..."
                if command -v sysbench &> /dev/null; then
                    sysbench memory --memory-total-size=10G run
                else
                    echo -e "${RED}sysbench no está instalado.${NC}"
                fi
                pausar
                ;;
            3)
                mostrar_encabezado
                echo -e "${YELLOW}=== Test de Disco (I/O) ===${NC}"
                echo "Ejecutando prueba de I/O..."
                if command -v dd &> /dev/null; then
                    echo "Test de escritura (escribe 1GB):"
                    dd if=/dev/zero of=/tmp/test_write bs=1M count=1024 conv=fdatasync 2>&1 | grep -v records
                    echo ""
                    echo "Test de lectura:"
                    dd if=/tmp/test_write of=/dev/null bs=1M 2>&1 | grep -v records
                    rm -f /tmp/test_write
                else
                    echo -e "${RED}dd no disponible${NC}"
                fi
                pausar
                ;;
            4)
                mostrar_encabezado
                echo -e "${YELLOW}=== Test de Red ===${NC}"
                echo "Verificando conexión de red..."
                echo "Ping a Google DNS (8.8.8.8):"
                ping -c 4 8.8.8.8
                echo ""
                echo "Test de velocidad (requiere speedtest-cli):"
                if command -v speedtest-cli &> /dev/null; then
                    speedtest-cli
                else
                    echo -e "${RED}speedtest-cli no está instalado. Instala con: sudo apt install speedtest-cli${NC}"
                fi
                pausar
                ;;
            5)
                mostrar_encabezado
                echo -e "${YELLOW}=== Test Completo del Sistema ===${NC}"
                echo "CPU:"
                lscpu | grep "Model name"
                echo ""
                echo "Memoria:"
                free -h
                echo ""
                echo "Disco:"
                df -h
                echo ""
                echo "Red:"
                ip -brief address
                pausar
                ;;
            6)
                mostrar_encabezado
                echo -e "${YELLOW}=== Actualizar Herramientas de Benchmarking ===${NC}"
                echo "Actualizando herramientas..."
                sudo apt update
                sudo apt install -y sysbench iperf3 speedtest-cli htop
                echo -e "${GREEN}Herramientas actualizadas correctamente.${NC}"
                pausar
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}Opción inválida${NC}"
                pausar
                ;;
        esac
    done
}

#########################################
# SUBMENÚ 2: GESTIÓN DE CEPH
#########################################
submenu_ceph() {
    while true; do
        mostrar_encabezado
        echo -e "${GREEN}=== GESTIÓN DE CEPH ===${NC}"
        echo ""
        echo "1) Instalar Ceph"
        echo "2) Verificar Estado de Ceph"
        echo "3) Configurar Nuevo OSD"
        echo "4) Listar Pools"
        echo "5) Crear Nuevo Pool"
        echo "6) Actualizar Ceph"
        echo "7) Ver Logs de Ceph"
        echo "0) Volver al Menú Principal"
        echo ""
        read -p "Selecciona una opción: " opcion

        case $opcion in
            1)
                mostrar_encabezado
                echo -e "${YELLOW}=== Instalación de Ceph ===${NC}"
                echo "Esta opción instalará Ceph en el sistema..."
                echo ""
                read -p "¿Confirmas la instalación? (s/n): " confirmar
                if [[ $confirmar == "s" || $confirmar == "S" ]]; then
                    echo "Agregando repositorio de Ceph..."
                    wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
                    echo "deb https://download.ceph.com/debian-quincy/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/ceph.list
                    sudo apt update
                    sudo apt install -y ceph ceph-deploy
                    echo -e "${GREEN}Ceph instalado correctamente.${NC}"
                else
                    echo "Instalación cancelada."
                fi
                pausar
                ;;
            2)
                mostrar_encabezado
                echo -e "${YELLOW}=== Estado de Ceph ===${NC}"
                if command -v ceph &> /dev/null; then
                    sudo ceph -s
                    echo ""
                    sudo ceph health detail
                else
                    echo -e "${RED}Ceph no está instalado.${NC}"
                fi
                pausar
                ;;
            3)
                mostrar_encabezado
                echo -e "${YELLOW}=== Configurar Nuevo OSD ===${NC}"
                echo "Discos disponibles:"
                lsblk
                echo ""
                read -p "Introduce el dispositivo (ejemplo: /dev/sdb): " dispositivo
                if [[ -b $dispositivo ]]; then
                    echo "Creando OSD en $dispositivo..."
                    sudo ceph-volume lvm create --data $dispositivo
                    echo -e "${GREEN}OSD creado correctamente.${NC}"
                else
                    echo -e "${RED}Dispositivo no válido.${NC}"
                fi
                pausar
                ;;
            4)
                mostrar_encabezado
                echo -e "${YELLOW}=== Listar Pools de Ceph ===${NC}"
                if command -v ceph &> /dev/null; then
                    sudo ceph osd lspools
                else
                    echo -e "${RED}Ceph no está instalado.${NC}"
                fi
                pausar
                ;;
            5)
                mostrar_encabezado
                echo -e "${YELLOW}=== Crear Nuevo Pool ===${NC}"
                read -p "Nombre del pool: " pool_name
                read -p "Número de PGs (recomendado 128): " pg_num
                pg_num=${pg_num:-128}
                sudo ceph osd pool create $pool_name $pg_num
                echo -e "${GREEN}Pool '$pool_name' creado correctamente.${NC}"
                pausar
                ;;
            6)
                mostrar_encabezado
                echo -e "${YELLOW}=== Actualizar Ceph ===${NC}"
                echo "Actualizando paquetes de Ceph..."
                sudo apt update
                sudo apt upgrade -y ceph ceph-common
                echo -e "${GREEN}Ceph actualizado correctamente.${NC}"
                pausar
                ;;
            7)
                mostrar_encabezado
                echo -e "${YELLOW}=== Logs de Ceph ===${NC}"
                echo "Últimas 50 líneas del log:"
                sudo tail -n 50 /var/log/ceph/ceph.log
                pausar
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}Opción inválida${NC}"
                pausar
                ;;
        esac
    done
}

#########################################
# SUBMENÚ 3: MONITORIZACIÓN DEL SISTEMA
#########################################
submenu_monitorizacion() {
    while true; do
        mostrar_encabezado
        echo -e "${GREEN}=== MONITORIZACIÓN DEL SISTEMA ===${NC}"
        echo ""
        echo "1) Procesos en Ejecución (htop)"
        echo "2) Uso de Disco"
        echo "3) Memoria y CPU en Tiempo Real"
        echo "4) Conexiones de Red Activas"
        echo "5) Servicios del Sistema"
        echo "6) Actualizar Herramientas de Monitorización"
        echo "0) Volver al Menú Principal"
        echo ""
        read -p "Selecciona una opción: " opcion

        case $opcion in
            1)
                mostrar_encabezado
                if command -v htop &> /dev/null; then
                    htop
                else
                    echo -e "${RED}htop no está instalado. Mostrando top...${NC}"
                    top
                fi
                ;;
            2)
                mostrar_encabezado
                echo -e "${YELLOW}=== Uso de Disco ===${NC}"
                df -h
                echo ""
                echo "Directorios más grandes:"
                du -sh /* 2>/dev/null | sort -hr | head -10
                pausar
                ;;
            3)
                mostrar_encabezado
                echo -e "${YELLOW}=== Memoria y CPU ===${NC}"
                echo "CPU:"
                mpstat 1 5 2>/dev/null || top -bn1 | grep "Cpu(s)"
                echo ""
                echo "Memoria:"
                free -h
                pausar
                ;;
            4)
                mostrar_encabezado
                echo -e "${YELLOW}=== Conexiones de Red Activas ===${NC}"
                ss -tulpn
                pausar
                ;;
            5)
                mostrar_encabezado
                echo -e "${YELLOW}=== Servicios del Sistema ===${NC}"
                systemctl list-units --type=service --state=running
                pausar
                ;;
            6)
                mostrar_encabezado
                echo -e "${YELLOW}=== Actualizar Herramientas ===${NC}"
                sudo apt update
                sudo apt install -y htop iotop nethogs sysstat
                echo -e "${GREEN}Herramientas actualizadas.${NC}"
                pausar
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}Opción inválida${NC}"
                pausar
                ;;
        esac
    done
}

#########################################
# MENÚ PRINCIPAL
#########################################
menu_principal() {
    while true; do
        mostrar_encabezado
        echo -e "${MAGENTA}=== MENÚ PRINCIPAL ===${NC}"
        echo ""
        echo "1) Pruebas de Rendimiento del Servidor"
        echo "2) Gestión de Ceph"
        echo "3) Monitorización del Sistema"
        echo "4) Actualizar Sistema Completo"
        echo "5) Información del Sistema"
        echo "0) Salir"
        echo ""
        read -p "Selecciona una opción: " opcion

        case $opcion in
            1)
                submenu_rendimiento
                ;;
            2)
                submenu_ceph
                ;;
            3)
                submenu_monitorizacion
                ;;
            4)
                mostrar_encabezado
                echo -e "${YELLOW}=== Actualizar Sistema Completo ===${NC}"
                echo "Este proceso actualizará todos los paquetes del sistema..."
                read -p "¿Continuar? (s/n): " confirmar
                if [[ $confirmar == "s" || $confirmar == "S" ]]; then
                    sudo apt update
                    sudo apt upgrade -y
                    sudo apt autoremove -y
                    echo -e "${GREEN}Sistema actualizado correctamente.${NC}"
                else
                    echo "Actualización cancelada."
                fi
                pausar
                ;;
            5)
                mostrar_encabezado
                echo -e "${YELLOW}=== Información del Sistema ===${NC}"
                echo "Hostname: $(hostname)"
                echo "Kernel: $(uname -r)"
                echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
                echo "Uptime: $(uptime -p)"
                echo "CPU: $(lscpu | grep "Model name" | cut -d':' -f2 | xargs)"
                echo "Memoria Total: $(free -h | grep Mem | awk '{print $2}')"
                pausar
                ;;
            0)
                mostrar_encabezado
                echo -e "${GREEN}¡Hasta luego!${NC}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${RED}Opción inválida. Por favor, selecciona una opción del menú.${NC}"
                pausar
                ;;
        esac
    done
}

#########################################
# INICIO DEL SCRIPT
#########################################

# Verificar si se ejecuta como root para ciertas operaciones
if [[ $EUID -eq 0 ]]; then
   echo -e "${YELLOW}Este script se está ejecutando como root.${NC}" 
   pausar
fi

# Ejecutar menú principal
menu_principal
