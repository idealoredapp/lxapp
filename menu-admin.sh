#!/bin/bash

#########################################
# LXApp - Sistema de Administración de Servidores
# Versión: 1.4.0
# Autor: idealored (www.idealored.com)
# Repositorio: github.com/idealoredapp/lxapp
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
    echo -e "${CYAN}║              🖥️  LXApp v1.4.0                  ║${NC}"
    echo -e "${CYAN}║   Sistema de Administración de Servidores      ║${NC}"
    echo -e "${CYAN}║        www.idealored.com                       ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Función para pausar y esperar entrada del usuario
pausar() {
    echo ""
    read -p "Presiona ENTER para continuar..."
}

#########################################
# SISTEMA DE REPORTES
#########################################

# Directorio para guardar reportes
REPORTS_DIR="$HOME/lxapp_reports"

# Crear directorio de reportes si no existe
crear_directorio_reportes() {
    if [[ ! -d "$REPORTS_DIR" ]]; then
        mkdir -p "$REPORTS_DIR"
        echo -e "${GREEN}Directorio de reportes creado: $REPORTS_DIR${NC}"
    fi
}

# Función para generar nombre de archivo de reporte
generar_nombre_reporte() {
    local tipo="$1"
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local hostname=$(hostname -s)
    echo "${REPORTS_DIR}/${hostname}_${tipo}_${timestamp}.txt"
}

# Función para iniciar reporte
iniciar_reporte() {
    local archivo="$1"
    local titulo="$2"
    
    cat > "$archivo" << EOF
╔════════════════════════════════════════════════════════════════╗
║                    🖥️  LXApp - Reporte de Pruebas             ║
║                      www.idealored.com                         ║
╚════════════════════════════════════════════════════════════════╝

TÍTULO: $titulo
SERVIDOR: $(hostname)
FECHA: $(date '+%Y-%m-%d %H:%M:%S')
SISTEMA: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 || uname -s)
KERNEL: $(uname -r)

════════════════════════════════════════════════════════════════
EOF
}

# Función para añadir sección al reporte
añadir_seccion() {
    local archivo="$1"
    local titulo="$2"
    
    cat >> "$archivo" << EOF

────────────────────────────────────────────────────────────────
$titulo
────────────────────────────────────────────────────────────────
EOF
}

# Función para finalizar reporte
finalizar_reporte() {
    local archivo="$1"
    
    cat >> "$archivo" << EOF

════════════════════════════════════════════════════════════════
Reporte generado por LXApp v1.2.0
Desarrollado por idealored.com
════════════════════════════════════════════════════════════════
EOF
    
    echo ""
    echo -e "${GREEN}✓ Reporte guardado en: ${NC}${YELLOW}$archivo${NC}"
    echo -e "${CYAN}  Para ver el reporte: ${NC}nano $archivo"
    echo -e "${CYAN}  O ejecuta: ${NC}cat $archivo"
}

# Función para preguntar si guardar reporte
preguntar_guardar_reporte() {
    echo ""
    read -p "¿Guardar reporte de esta prueba? (s/n): " guardar
    if [[ $guardar == "s" || $guardar == "S" ]]; then
        return 0  # Sí guardar
    else
        return 1  # No guardar
    fi
}

#########################################
# SUBMENÚ 1: PRUEBAS DE RENDIMIENTO
#########################################
submenu_rendimiento() {
    while true; do
        mostrar_encabezado
        echo -e "${GREEN}=== PRUEBAS DE RENDIMIENTO DEL SERVIDOR ===${NC}"
        echo ""
        echo -e "${CYAN}Pruebas Básicas:${NC}"
        echo "1) Test de CPU (single-thread)"
        echo "2) Test de Memoria RAM"
        echo "3) Test de Disco (I/O básico)"
        echo "4) Test de Red (ping + speedtest)"
        echo "5) Test Completo (resumen)"
        echo ""
        echo -e "${CYAN}Pruebas Avanzadas:${NC}"
        echo "6) Test de CPU Multi-Thread"
        echo "7) Test de Ancho de Banda de Red (iperf3)"
        echo "8) Test de Latencia de Disco (ioping)"
        echo "9) Benchmark de Base de Datos"
        echo "10) Stress Test del Sistema"
        echo ""
        echo "11) Actualizar Herramientas de Benchmarking"
        echo "12) Ver Reportes Guardados"
        echo "0) Volver al Menú Principal"
        echo ""
        read -p "Selecciona una opción: " opcion

        case $opcion in
            1)
                mostrar_encabezado
                echo -e "${YELLOW}=== Test de CPU (Single-Thread) ===${NC}"
                echo "Ejecutando prueba de CPU con sysbench..."
                if command -v sysbench &> /dev/null; then
                    sysbench cpu --cpu-max-prime=20000 --threads=1 run
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
                echo -e "${YELLOW}=== Test de Disco (I/O Básico) ===${NC}"
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
                echo -e "${YELLOW}╔══════════════════════════════════════════════════════╗${NC}"
                echo -e "${YELLOW}║     TEST COMPLETO DE RENDIMIENTO DEL SERVIDOR        ║${NC}"
                echo -e "${YELLOW}╚══════════════════════════════════════════════════════╝${NC}"
                echo ""
                echo -e "${CYAN}Este test ejecutará TODOS los benchmarks reales:${NC}"
                echo "  • Test de CPU (single-thread)"
                echo "  • Test de CPU (multi-thread)"
                echo "  • Test de Memoria RAM"
                echo "  • Test de Disco (lectura/escritura)"
                echo "  • Test de Red (latencia)"
                echo ""
                echo -e "${YELLOW}⏱️  Tiempo estimado: 3-5 minutos${NC}"
                echo ""
                read -p "¿Continuar con el test completo? (s/n): " continuar
                
                if [[ $continuar != "s" && $continuar != "S" ]]; then
                    echo "Test cancelado."
                    pausar
                    continue
                fi
                
                # Crear reporte SIEMPRE
                crear_directorio_reportes
                REPORT_FILE=$(generar_nombre_reporte "benchmark_completo")
                iniciar_reporte "$REPORT_FILE" "Benchmark Completo de Rendimiento"
                
                echo ""
                echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
                echo -e "${GREEN}Iniciando tests de rendimiento...${NC}"
                echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
                
                # ═══════════════════════════════════════════════════════
                # 1. INFORMACIÓN DEL SISTEMA
                # ═══════════════════════════════════════════════════════
                echo ""
                echo -e "${CYAN}[1/6] Recopilando información del sistema...${NC}"
                
                añadir_seccion "$REPORT_FILE" "INFORMACIÓN DEL HARDWARE"
                {
                    echo "CPU: $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
                    echo "Cores: $(nproc)"
                    echo "Arquitectura: $(uname -m)"
                    echo ""
                    echo "Memoria Total: $(free -h | grep Mem | awk '{print $2}')"
                    echo "Memoria Disponible: $(free -h | grep Mem | awk '{print $7}')"
                    echo ""
                    echo "Sistema: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'\"' -f2 || uname -s)"
                    echo "Kernel: $(uname -r)"
                } >> "$REPORT_FILE"
                
                # ═══════════════════════════════════════════════════════
                # 2. TEST DE CPU SINGLE-THREAD
                # ═══════════════════════════════════════════════════════
                echo ""
                echo -e "${CYAN}[2/6] Test de CPU (single-thread)...${NC}"
                
                if command -v sysbench &> /dev/null; then
                    añadir_seccion "$REPORT_FILE" "TEST DE CPU (SINGLE-THREAD)"
                    echo "Calculando números primos hasta 20000..." >> "$REPORT_FILE"
                    echo "" >> "$REPORT_FILE"
                    
                    sysbench cpu --cpu-max-prime=20000 --threads=1 run 2>&1 | tee -a "$REPORT_FILE"
                    
                    echo -e "${GREEN}✓ Completado${NC}"
                else
                    echo -e "${RED}⚠ sysbench no instalado, saltando...${NC}"
                    echo "ERROR: sysbench no está instalado" >> "$REPORT_FILE"
                fi
                
                # ═══════════════════════════════════════════════════════
                # 3. TEST DE CPU MULTI-THREAD
                # ═══════════════════════════════════════════════════════
                echo ""
                echo -e "${CYAN}[3/6] Test de CPU (multi-thread con $(nproc) cores)...${NC}"
                
                if command -v sysbench &> /dev/null; then
                    añadir_seccion "$REPORT_FILE" "TEST DE CPU (MULTI-THREAD - $(nproc) CORES)"
                    echo "Calculando números primos hasta 20000 con $(nproc) threads..." >> "$REPORT_FILE"
                    echo "" >> "$REPORT_FILE"
                    
                    sysbench cpu --cpu-max-prime=20000 --threads=$(nproc) run 2>&1 | tee -a "$REPORT_FILE"
                    
                    echo -e "${GREEN}✓ Completado${NC}"
                else
                    echo -e "${RED}⚠ sysbench no instalado, saltando...${NC}"
                fi
                
                # ═══════════════════════════════════════════════════════
                # 4. TEST DE MEMORIA RAM
                # ═══════════════════════════════════════════════════════
                echo ""
                echo -e "${CYAN}[4/6] Test de Memoria RAM (10GB de transferencia)...${NC}"
                
                if command -v sysbench &> /dev/null; then
                    añadir_seccion "$REPORT_FILE" "TEST DE MEMORIA RAM"
                    echo "Prueba de transferencia de 10GB en memoria..." >> "$REPORT_FILE"
                    echo "" >> "$REPORT_FILE"
                    
                    sysbench memory --memory-total-size=10G run 2>&1 | tee -a "$REPORT_FILE"
                    
                    echo -e "${GREEN}✓ Completado${NC}"
                else
                    echo -e "${RED}⚠ sysbench no instalado, saltando...${NC}"
                fi
                
                # ═══════════════════════════════════════════════════════
                # 5. TEST DE DISCO (I/O)
                # ═══════════════════════════════════════════════════════
                echo ""
                echo -e "${CYAN}[5/6] Test de Disco (lectura/escritura de 1GB)...${NC}"
                
                añadir_seccion "$REPORT_FILE" "TEST DE DISCO (I/O)"
                
                # Test de ESCRITURA
                echo "═══ Test de Escritura ═══" >> "$REPORT_FILE"
                echo "Escribiendo 1GB de datos..." >> "$REPORT_FILE"
                echo "" >> "$REPORT_FILE"
                
                write_result=$(dd if=/dev/zero of=/tmp/lxapp_test_write bs=1M count=1024 conv=fdatasync 2>&1)
                write_speed=$(echo "$write_result" | grep -oP '\d+(\.\d+)? [MG]B/s' | tail -1)
                
                echo "$write_result" >> "$REPORT_FILE"
                echo "" >> "$REPORT_FILE"
                echo "Velocidad de escritura: $write_speed" >> "$REPORT_FILE"
                echo -e "${GREEN}  Escritura: $write_speed${NC}"
                
                # Test de LECTURA
                echo "" >> "$REPORT_FILE"
                echo "═══ Test de Lectura ═══" >> "$REPORT_FILE"
                echo "Leyendo 1GB de datos..." >> "$REPORT_FILE"
                echo "" >> "$REPORT_FILE"
                
                # Limpiar cache
                sync
                echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1
                
                read_result=$(dd if=/tmp/lxapp_test_write of=/dev/null bs=1M 2>&1)
                read_speed=$(echo "$read_result" | grep -oP '\d+(\.\d+)? [MG]B/s' | tail -1)
                
                echo "$read_result" >> "$REPORT_FILE"
                echo "" >> "$REPORT_FILE"
                echo "Velocidad de lectura: $read_speed" >> "$REPORT_FILE"
                echo -e "${GREEN}  Lectura: $read_speed${NC}"
                
                # Limpiar archivo temporal
                rm -f /tmp/lxapp_test_write
                
                echo -e "${GREEN}✓ Completado${NC}"
                
                # ═══════════════════════════════════════════════════════
                # 6. TEST DE RED (LATENCIA)
                # ═══════════════════════════════════════════════════════
                echo ""
                echo -e "${CYAN}[6/6] Test de Red (latencia a Google DNS)...${NC}"
                
                añadir_seccion "$REPORT_FILE" "TEST DE RED (LATENCIA)"
                echo "Ping a 8.8.8.8 (Google DNS):" >> "$REPORT_FILE"
                echo "" >> "$REPORT_FILE"
                
                ping_result=$(ping -c 10 8.8.8.8 2>&1)
                echo "$ping_result" >> "$REPORT_FILE"
                
                avg_latency=$(echo "$ping_result" | grep 'avg' | awk -F'/' '{print $5}' || echo "N/A")
                echo "" >> "$REPORT_FILE"
                echo "Latencia promedio: ${avg_latency} ms" >> "$REPORT_FILE"
                echo -e "${GREEN}  Latencia promedio: ${avg_latency} ms${NC}"
                
                echo -e "${GREEN}✓ Completado${NC}"
                
                # ═══════════════════════════════════════════════════════
                # RESUMEN FINAL
                # ═══════════════════════════════════════════════════════
                echo ""
                echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
                echo -e "${GREEN}       ✓ TODOS LOS TESTS COMPLETADOS                   ${NC}"
                echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
                
                # Finalizar reporte
                finalizar_reporte "$REPORT_FILE"
                
                echo ""
                echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
                echo -e "${YELLOW}  RESUMEN: Puedes comparar este reporte con otros     ${NC}"
                echo -e "${YELLOW}  servidores usando los valores numéricos del archivo ${NC}"
                echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
                
                pausar
                ;;
            6)
                mostrar_encabezado
                echo -e "${YELLOW}=== Test de CPU Multi-Thread ===${NC}"
                echo "Detectando número de CPUs/cores..."
                num_cpus=$(nproc)
                echo "CPUs detectados: $num_cpus"
                echo ""
                echo "Ejecutando benchmark multi-thread con sysbench..."
                if command -v sysbench &> /dev/null; then
                    sysbench cpu --cpu-max-prime=20000 --threads=$num_cpus run
                    echo ""
                    echo -e "${GREEN}Comparación:${NC}"
                    echo "- Single-thread: Ejecuta opción 1 para comparar"
                    echo "- Multi-thread ($num_cpus threads): Resultado mostrado arriba"
                else
                    echo -e "${RED}sysbench no está instalado. Instala con: sudo apt install sysbench${NC}"
                fi
                pausar
                ;;
            7)
                mostrar_encabezado
                echo -e "${YELLOW}=== Test de Ancho de Banda de Red (iperf3) ===${NC}"
                echo ""
                echo "Opciones:"
                echo "1) Modo SERVIDOR (escuchar conexiones)"
                echo "2) Modo CLIENTE (conectar a servidor)"
                echo ""
                read -p "Selecciona modo: " modo_iperf
                
                if command -v iperf3 &> /dev/null; then
                    if [[ $modo_iperf == "1" ]]; then
                        echo -e "${GREEN}Iniciando servidor iperf3 en puerto 5201...${NC}"
                        echo "En otro servidor, ejecuta: iperf3 -c $(hostname -I | awk '{print $1}')"
                        echo "Presiona Ctrl+C para detener el servidor"
                        iperf3 -s
                    elif [[ $modo_iperf == "2" ]]; then
                        read -p "IP del servidor iperf3: " server_ip
                        echo "Conectando a $server_ip..."
                        iperf3 -c $server_ip
                    else
                        echo -e "${RED}Opción inválida${NC}"
                    fi
                else
                    echo -e "${RED}iperf3 no está instalado. Instala con: sudo apt install iperf3${NC}"
                fi
                pausar
                ;;
            8)
                mostrar_encabezado
                echo -e "${YELLOW}=== Test de Latencia de Disco (ioping) ===${NC}"
                echo ""
                if command -v ioping &> /dev/null; then
                    echo "Selecciona disco a probar:"
                    echo "1) Directorio actual (.)"
                    echo "2) /tmp"
                    echo "3) /var"
                    echo "4) Personalizado"
                    read -p "Opción: " disco_opt
                    
                    case $disco_opt in
                        1) target="." ;;
                        2) target="/tmp" ;;
                        3) target="/var" ;;
                        4) read -p "Ruta del disco/directorio: " target ;;
                        *) target="." ;;
                    esac
                    
                    echo ""
                    echo -e "${GREEN}Probando latencia en: $target${NC}"
                    echo "Test 1: 10 solicitudes de I/O"
                    ioping -c 10 $target
                    echo ""
                    echo "Test 2: 3 segundos de prueba continua"
                    ioping -w 3 $target
                else
                    echo -e "${RED}ioping no está instalado. Instala con: sudo apt install ioping${NC}"
                fi
                pausar
                ;;
            9)
                mostrar_encabezado
                echo -e "${YELLOW}=== Benchmark de Base de Datos ===${NC}"
                echo ""
                echo "Ejecutando benchmark con sysbench (simula carga MySQL/PostgreSQL)..."
                
                if command -v sysbench &> /dev/null; then
                    echo "Preparando test..."
                    mkdir -p /tmp/sysbench_db_test
                    cd /tmp/sysbench_db_test
                    
                    echo ""
                    echo "1. Preparando datos de prueba (10,000 filas)..."
                    sysbench oltp_read_write --tables=2 --table-size=10000 prepare 2>/dev/null || \
                    sysbench --test=oltp --oltp-table-size=10000 prepare 2>/dev/null
                    
                    echo ""
                    echo "2. Ejecutando benchmark de lectura/escritura..."
                    sysbench oltp_read_write --tables=2 --table-size=10000 --threads=4 --time=30 run 2>/dev/null || \
                    sysbench --test=oltp --oltp-table-size=10000 --num-threads=4 --max-time=30 run 2>/dev/null
                    
                    echo ""
                    echo "3. Limpiando datos de prueba..."
                    sysbench oltp_read_write --tables=2 cleanup 2>/dev/null || \
                    sysbench --test=oltp cleanup 2>/dev/null
                    
                    cd - >/dev/null
                    rm -rf /tmp/sysbench_db_test
                    
                    echo ""
                    echo -e "${GREEN}Benchmark completado. Verifica las transacciones por segundo (TPS).${NC}"
                else
                    echo -e "${RED}sysbench no está instalado. Instala con: sudo apt install sysbench${NC}"
                fi
                pausar
                ;;
            10)
                mostrar_encabezado
                echo -e "${YELLOW}=== Stress Test del Sistema ===${NC}"
                echo ""
                echo -e "${RED}⚠️  ADVERTENCIA: Esta prueba pondrá el sistema bajo carga extrema${NC}"
                read -p "¿Continuar? (si/no): " confirmar
                
                if [[ $confirmar == "si" ]]; then
                    if command -v stress-ng &> /dev/null; then
                        num_cpus=$(nproc)
                        echo ""
                        echo "Configuración del stress test:"
                        echo "1) Stress ligero (30 segundos)"
                        echo "2) Stress moderado (60 segundos)"
                        echo "3) Stress intenso (120 segundos)"
                        echo "4) Personalizado"
                        read -p "Selecciona: " stress_opt
                        
                        case $stress_opt in
                            1) tiempo=30; carga="--cpu $num_cpus --vm 2 --vm-bytes 128M" ;;
                            2) tiempo=60; carga="--cpu $num_cpus --vm 4 --vm-bytes 256M --io 2" ;;
                            3) tiempo=120; carga="--cpu $num_cpus --vm 4 --vm-bytes 512M --io 4 --hdd 2" ;;
                            4) 
                                read -p "Duración en segundos: " tiempo
                                read -p "Workers de CPU: " cpu_w
                                read -p "Workers de VM: " vm_w
                                carga="--cpu ${cpu_w:-$num_cpus} --vm ${vm_w:-2} --vm-bytes 256M"
                                ;;
                            *) tiempo=30; carga="--cpu $num_cpus --vm 2 --vm-bytes 128M" ;;
                        esac
                        
                        echo ""
                        echo -e "${GREEN}Iniciando stress test por ${tiempo}s...${NC}"
                        echo "Monitorea con 'htop' en otra terminal"
                        stress-ng $carga --timeout ${tiempo}s --metrics-brief
                        
                        echo ""
                        echo -e "${GREEN}Stress test completado. Revisa las métricas de carga.${NC}"
                    else
                        echo -e "${RED}stress-ng no está instalado. Instala con: sudo apt install stress-ng${NC}"
                    fi
                else
                    echo "Stress test cancelado."
                fi
                pausar
                ;;
            11)
                mostrar_encabezado
                echo -e "${YELLOW}=== Actualizar Herramientas de Benchmarking ===${NC}"
                echo "Actualizando herramientas..."
                sudo apt update
                sudo apt install -y sysbench iperf3 speedtest-cli htop ioping stress-ng
                echo -e "${GREEN}Herramientas actualizadas correctamente.${NC}"
                echo ""
                echo "Herramientas instaladas:"
                echo "- sysbench (CPU, RAM, DB)"
                echo "- iperf3 (Ancho de banda de red)"
                echo "- speedtest-cli (Velocidad de internet)"
                echo "- htop (Monitor de procesos)"
                echo "- ioping (Latencia de disco)"
                echo "- stress-ng (Stress test)"
                pausar
                ;;
            12)
                mostrar_encabezado
                echo -e "${YELLOW}=== Reportes Guardados ===${NC}"
                echo ""
                
                if [[ ! -d "$REPORTS_DIR" ]] || [[ -z "$(ls -A $REPORTS_DIR 2>/dev/null)" ]]; then
                    echo -e "${YELLOW}No hay reportes guardados aún.${NC}"
                    echo "Los reportes se guardan en: $REPORTS_DIR"
                    echo ""
                    echo "Ejecuta pruebas y selecciona 'guardar reporte' para crear reportes."
                else
                    echo "Directorio de reportes: $REPORTS_DIR"
                    echo ""
                    echo "Reportes disponibles:"
                    echo ""
                    
                    # Listar reportes con numeración
                    mapfile -t reportes < <(ls -1t "$REPORTS_DIR"/*.txt 2>/dev/null)
                    
                    if [[ ${#reportes[@]} -eq 0 ]]; then
                        echo -e "${YELLOW}No hay reportes .txt guardados.${NC}"
                    else
                        for i in "${!reportes[@]}"; do
                            archivo="${reportes[$i]}"
                            nombre=$(basename "$archivo")
                            tamano=$(du -h "$archivo" | cut -f1)
                            fecha=$(date -r "$archivo" "+%Y-%m-%d %H:%M" 2>/dev/null || echo "N/A")
                            echo "$((i+1))) $nombre ($tamano) - $fecha"
                        done
                        
                        echo ""
                        echo "Opciones:"
                        echo "- Escribe número para ver el reporte"
                        echo "- Enter para volver"
                        echo ""
                        read -p "Selección: " sel
                        
                        if [[ "$sel" =~ ^[0-9]+$ ]] && [[ $sel -ge 1 ]] && [[ $sel -le ${#reportes[@]} ]]; then
                            archivo_sel="${reportes[$((sel-1))]}"
                            echo ""
                            echo -e "${GREEN}Mostrando: $(basename "$archivo_sel")${NC}"
                            echo ""
                            cat "$archivo_sel"
                            echo ""
                            echo -e "${CYAN}Para editar: ${NC}nano $archivo_sel"
                            echo -e "${CYAN}Ruta completa: ${NC}$archivo_sel"
                        fi
                    fi
                fi
                
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
# FUNCIONES AUXILIARES CEPH
#########################################

# Variables globales Ceph
CEPHADM_URL_V18="https://download.ceph.com/rpm-18.2.4/el9/noarch/cephadm"  # reef
CEPHADM_URL_V19="https://download.ceph.com/rpm-19.2.3/el9/noarch/cephadm"  # squid
CEPH_MAJOR=""
CEPH_RELEASE=""
CEPHADM_URL=""

valid_ip() {
  local ip=$1
  [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || return 1
  IFS='.' read -r -a o <<<"$ip"
  [[ ${o[0]} -le 255 && ${o[1]} -le 255 && ${o[2]} -le 255 && ${o[3]} -le 255 ]]
}

valid_hostname(){ [[ -n "${1:-}" ]]; }

install_dependencies_ceph() {
  apt update
  apt install -y curl ca-certificates gnupg chrony lvm2 openssh-server podman
  systemctl enable --now chrony || true
}

require_container_engine() {
  if ! command -v podman >/dev/null 2>&1 && ! command -v docker >/dev/null 2>&1; then
    echo -e "${RED}ERROR: No hay motor de contenedores (podman/docker).${NC}"
    return 1
  fi
  if command -v podman >/dev/null 2>&1; then
    echo "Container engine: $(podman --version)"
  else
    echo "Container engine: $(docker --version)"
  fi
}

choose_ceph_version() {
  echo ""
  echo "Selecciona versión Ceph:"
  echo "1) Ceph v18 (Reef)  - recomendado si quieres estabilidad"
  echo "2) Ceph v19 (Squid) - más nuevo"
  while true; do
    read -r -p "Opción (1/2): " v
    [[ "$v" == "1" || "$v" == "2" ]] && break
  done

  if [[ "$v" == "1" ]]; then
    CEPH_MAJOR="18"
    CEPH_RELEASE="reef"
    CEPHADM_URL="$CEPHADM_URL_V18"
  else
    CEPH_MAJOR="19"
    CEPH_RELEASE="squid"
    CEPHADM_URL="$CEPHADM_URL_V19"
  fi

  echo -e "${GREEN}Seleccionado: Ceph v${CEPH_MAJOR} (${CEPH_RELEASE})${NC}"
}

install_cephadm_selected() {
  [[ -n "${CEPHADM_URL:-}" ]] || { echo -e "${RED}ERROR: No se ha seleccionado versión Ceph.${NC}"; return 1; }

  echo "Descargando cephadm v${CEPH_MAJOR} desde: $CEPHADM_URL"
  curl -fL "$CEPHADM_URL" -o /usr/local/bin/cephadm
  chmod +x /usr/local/bin/cephadm

  ln -sf /usr/local/bin/cephadm /usr/sbin/cephadm
  ln -sf /usr/local/bin/cephadm /usr/bin/cephadm

  echo "cephadm => $(/usr/local/bin/cephadm version || true)"

  /usr/local/bin/cephadm add-repo --release "${CEPH_RELEASE}" || true
  /usr/local/bin/cephadm install ceph-common || true
}

get_root_disk() {
  local root_src root_pk
  root_src="$(findmnt -no SOURCE / || true)"
  root_pk="$(lsblk -no PKNAME "$root_src" 2>/dev/null || true)"
  echo "$root_pk"
}

list_osd_candidates() {
  local root_disk
  root_disk="$(get_root_disk)"

  mapfile -t disks < <(lsblk -ndo NAME,TYPE | awk '$2=="disk"{print $1}')
  for d in "${disks[@]}"; do
    [[ -n "$root_disk" && "$d" == "$root_disk" ]] && continue
    if lsblk -n "/dev/$d" -o NAME,TYPE | awk '$2=="part"{exit 0} END{exit 1}'; then
      continue
    fi
    echo "/dev/$d"
  done
}

add_osds_local() {
  local host
  host="$(hostname -s)"

  mapfile -t disks < <(list_osd_candidates)
  if [[ ${#disks[@]} -eq 0 ]]; then
    echo "No hay discos candidatos (excluyendo disco del sistema y discos con particiones)."
    return 0
  fi

  echo "Discos candidatos: ${disks[*]}"
  local ans
  while true; do
    read -r -p "¿Añadir TODOS como OSD? (si/no): " ans
    [[ "$ans" == "si" || "$ans" == "no" ]] && break
  done

  if [[ "$ans" == "si" ]]; then
    for d in "${disks[@]}"; do
      echo "Añadiendo OSD: ${host}:${d}"
      ceph orch daemon add osd "${host}:${d}"
    done
  else
    echo "Escribe discos a añadir separados por espacio (ej: /dev/sdb /dev/sdc), o ENTER para omitir:"
    read -r -a sel || true
    for d in "${sel[@]}"; do
      [[ -z "$d" ]] && continue
      echo "Añadiendo OSD: ${host}:${d}"
      ceph orch daemon add osd "${host}:${d}"
    done
  fi
}

ask_env_mode() {
  echo ""
  echo "Selecciona entorno:"
  echo "1) LOCAL (casa/LAN) -> solo IP interna"
  echo "2) EXTERNO (datacenter) -> IP interna + IP externa"
  while true; do
    read -r -p "Opción (1/2): " ENV_MODE
    [[ "$ENV_MODE" == "1" || "$ENV_MODE" == "2" ]] && break
  done
}

bootstrap_first_node() {
  local mon_ip_internal="$1"
  local cluster_net="${2:-}"

  require_container_engine || return 1

  echo "Bootstrap Ceph v${CEPH_MAJOR} (${CEPH_RELEASE})..."

  if [[ -z "$cluster_net" ]]; then
    cephadm bootstrap \
      --mon-ip "$mon_ip_internal" \
      --allow-fqdn-hostname \
      --skip-mon-network
  else
    cephadm bootstrap \
      --mon-ip "$mon_ip_internal" \
      --cluster-network "$cluster_net" \
      --allow-fqdn-hostname \
      --skip-mon-network
  fi
}

set_dashboard_password() {
  local dash_ip="$1"
  local p1 p2
  while true; do
    read -r -s -p "Contraseña dashboard admin: " p1; echo ""
    read -r -s -p "Confirmar contraseña: " p2; echo ""
    [[ "$p1" == "$p2" ]] && break
    echo "Contraseñas no coinciden."
  done
  ceph dashboard ac-user-set-password admin -i <(echo "$p1")
  echo -e "${GREEN}Dashboard: https://${dash_ip}:8443${NC}"
}

purge_broken_cluster() {
  echo -e "${RED}=== PURGAR CLUSTER ROTO ===${NC}"
  read -r -p "FSID del cluster roto (ej: b050a4fa-...): " FSID
  [[ -z "$FSID" ]] && { echo "FSID vacío. Cancelado."; return 0; }

  echo "Ejecutando: cephadm rm-cluster --force --zap-osds --fsid $FSID"
  cephadm rm-cluster --force --zap-osds --fsid "$FSID" || true

  echo "Limpiando restos locales..."
  rm -rf /etc/ceph/* /var/lib/ceph/* || true
  echo -e "${GREEN}Purgado completado.${NC}"
}

#########################################
# SUBMENÚ 2: GESTIÓN DE CEPH
#########################################
submenu_ceph() {
  while true; do
    mostrar_encabezado
    echo -e "${GREEN}=== GESTIÓN DE CEPH ===${NC}"
    echo ""
    echo "1) Seleccionar versión Ceph (v18 o v19)"
    echo "2) Instalar PRIMER nodo (bootstrap)"
    echo "3) Añadir NODO adicional"
    echo "4) Agregar OSDs (en ESTE nodo)"
    echo "5) Ver estado del cluster"
    echo "6) Cambiar contraseña dashboard"
    echo "7) Ver nodos y OSDs"
    echo "8) Purgar cluster roto (FSID)"
    echo "0) Volver al Menú Principal"
    echo ""
    echo -e "${CYAN}Versión seleccionada: ${CEPH_MAJOR:-NO SELECCIONADA} / ${CEPH_RELEASE:-}${NC}"
    read -p "Selecciona opción: " opt

    case "$opt" in
      1)
        choose_ceph_version
        pausar
        ;;

      2)
        [[ -n "${CEPH_MAJOR:-}" ]] || { echo -e "${RED}Primero elige versión (opción 1).${NC}"; pausar; continue; }

        echo -e "${YELLOW}=== PRIMER NODO (Bootstrap) ===${NC}"
        install_dependencies_ceph
        install_cephadm_selected

        ask_env_mode

        while true; do
          read -r -p "IP INTERNA del nodo (MON/bootstrap): " MASTER_INTERNAL_IP
          valid_ip "$MASTER_INTERNAL_IP" && break
          echo "IP inválida."
        done

        if [[ "$ENV_MODE" == "2" ]]; then
          while true; do
            read -r -p "IP EXTERNA del nodo (para dashboard): " MASTER_EXTERNAL_IP
            valid_ip "$MASTER_EXTERNAL_IP" && break
            echo "IP inválida."
          done
          DASHBOARD_IP="$MASTER_EXTERNAL_IP"
        else
          DASHBOARD_IP="$MASTER_INTERNAL_IP"
        fi

        read -r -p "Red interna cluster (ej: 10.0.0.0/16), ENTER para omitir: " cluster_net

        bootstrap_first_node "$MASTER_INTERNAL_IP" "$cluster_net"
        set_dashboard_password "$DASHBOARD_IP"
        add_osds_local
        pausar
        ;;

      3)
        [[ -n "${CEPH_MAJOR:-}" ]] || { echo -e "${RED}Primero elige versión (opción 1).${NC}"; pausar; continue; }

        echo -e "${YELLOW}=== AÑADIR NODO ===${NC}"
        install_dependencies_ceph
        install_cephadm_selected
        ask_env_mode

        while true; do
          read -r -p "Hostname del nodo NUEVO: " new_host
          valid_hostname "$new_host" && break
          echo "Hostname inválido."
        done

        while true; do
          read -r -p "IP INTERNA del nodo NUEVO (cluster): " new_internal_ip
          valid_ip "$new_internal_ip" && break
          echo "IP inválida."
        done

        if [[ "$ENV_MODE" == "1" ]]; then
          while true; do
            read -r -p "IP INTERNA del MASTER (SSH/copiar config): " master_ip
            valid_ip "$master_ip" && break
            echo "IP inválida."
          done
        else
          while true; do
            read -r -p "IP EXTERNA del MASTER (SSH/copiar config): " master_ip
            valid_ip "$master_ip" && break
            echo "IP inválida."
          done
        fi

        if ! ssh -o BatchMode=yes -o ConnectTimeout=5 root@"$master_ip" "echo ok" &>/dev/null; then
          echo -e "${RED}ERROR: No hay SSH al master ($master_ip).${NC}"
          pausar
          continue
        fi

        mkdir -p /etc/ceph
        scp root@"$master_ip":/etc/ceph/ceph.conf /etc/ceph/
        scp root@"$master_ip":/etc/ceph/ceph.client.admin.keyring /etc/ceph/

        ceph orch host add "$new_host" "$new_internal_ip"
        echo -e "${GREEN}Nodo añadido.${NC}"
        pausar
        ;;

      4)
        echo -e "${YELLOW}=== AÑADIR OSDs (local) ===${NC}"
        add_osds_local
        pausar
        ;;

      5)
        mostrar_encabezado
        echo -e "${YELLOW}=== ESTADO DEL CLUSTER ===${NC}"
        ceph -s || true
        pausar
        ;;

      6)
        echo -e "${YELLOW}=== CAMBIAR PASSWORD DASHBOARD ===${NC}"
        read -r -p "IP para dashboard (externa o interna): " dash_ip
        set_dashboard_password "$dash_ip"
        pausar
        ;;

      7)
        mostrar_encabezado
        echo -e "${YELLOW}=== NODOS Y OSDs ===${NC}"
        ceph orch host ls || true
        echo ""
        ceph osd tree || true
        pausar
        ;;

      8)
        purge_broken_cluster
        pausar
        ;;

      0)
        break
        ;;

      *)
        echo -e "${RED}Opción inválida.${NC}"
        sleep 1
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
