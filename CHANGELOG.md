# Changelog

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.7.0] - 2026-04-19

### ✨ Añadido
- **Instalador de Docker CE (opción 7 en menú principal)**
  - Usa el repositorio oficial de Docker para instalar la última versión estable
  - Instala: `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`
  - Detecta y elimina automáticamente paquetes conflictivos (`docker.io`, `podman-docker`, etc.)
  - Detección automática de distribución (Ubuntu, Debian, Raspbian, Linux Mint, Pop!_OS)
  - Configura clave GPG y repositorio oficial de Docker
  - Habilita e inicia el servicio `docker` en systemd
  - Opción para añadir el usuario actual al grupo `docker` (sin sudo)
  - Verifica la instalación con `docker run hello-world`
  - Detecta si Docker ya está instalado y ofrece reinstalar/actualizar
  - Compatible con root y con sudo

---

## [1.6.0] - 2026-01-25

### ✨ Añadido
- **Instalador de Nextcloud integrado (opción 6)**
  - Instalación completa de Nextcloud con asistente interactivo
  - Configuración automática de Nginx como servidor web
  - Elección entre MariaDB o PostgreSQL como base de datos
  - Configuración de PHP con todas las extensiones necesarias
  - Redis opcional para caché de rendimiento
  - SSL/HTTPS opcional con Let's Encrypt (Certbot)
  - Configuración automática de UFW (firewall)
- **Menú post-instalación Nextcloud (nc-menu)**
  - Ver estado de servicios y Nextcloud
  - Añadir dominios de confianza (trusted domains)
  - Migrar de IP a dominio
  - Activar SSL después de instalación
  - Maintenance mode on/off
  - Backup completo (DB + archivos + datos)
  - Ejecutar comandos occ personalizados
  - Ver logs de Nginx y Nextcloud
  - Reparar y validar stack completo

### 📦 Archivos nuevos
- `nextcloud-installer.sh` - Script standalone de instalación
- Instalador guardado en `/usr/local/bin/nc-menu` tras instalación

## [1.5.0] - 2026-01-04

### ✨ Añadido
- **Stress Test (opción 10) ahora con verificación automática**
  - Detecta si falta `stress-ng` antes de ejecutar
  - Pregunta e instala automáticamente si acepta el usuario
  - Compatible con sistemas sin sudo (detecta root)
- **Generación automática de reporte del stress test**
  - Guarda en `~/lxapp_reports/test_estres_*.txt`
  - Incluye configuración del test (nivel, duración, comando)
  - Captura todas las métricas de stress-ng
  - Timestamps de inicio y fin
  - Formato profesional comparable

### 🔧 Mejorado
- Opción 10 ahora tiene mismo nivel de UX que opción 5
- Instalación automática sin sudo en contenedores LXC
- Reportes guardados automáticamente sin preguntar
- Niveles de stress con nombres descriptivos (LIGERO/MODERADO/INTENSO)

## [1.4.2] - 2026-01-04

### 🐛 Corregido
- **Compatibilidad total con sistemas sin sudo**
- Detecta automáticamente si el usuario es root (`$EUID -ne 0`)
- Usa `sudo` solo cuando es necesario y está disponible
- Permite ejecución directa como root (contenedores LXC, VPS)
- Corregido `apt update/install` para funcionar sin sudo
- Corregido `drop_caches` para funcionar sin sudo
- Mensajes de error claros cuando no hay permisos

### 📝 Casos soportados
- ✅ Usuario normal con sudo instalado
- ✅ Usuario root directo (sin necesidad de sudo)
- ✅ Contenedores LXC ejecutando como root
- ❌ Usuario sin privilegios y sin sudo (muestra error con instrucciones)

## [1.4.1] - 2026-01-04

### ✨ Añadido
- **Verificación automática de herramientas** antes del test completo
- **Instalación automática opcional** de herramientas faltantes
- Detecta si falta `sysbench` antes de ejecutar tests
- Pregunta al usuario si quiere instalar lo que falta
- Instala automáticamente con `apt` si el usuario acepta
- Advertencia clara si se ejecuta sin todas las herramientas
- Opción para continuar aunque falten herramientas

### 🔧 Mejorado
- Experiencia de usuario: ya no falla silenciosamente
- Evita ejecutar tests parciales sin avisar
- Confirmación antes de modificar el sistema

## [1.4.0] - 2026-01-04

### 🚀 Mejorado
- **Test Completo ahora ejecuta TODOS los benchmarks reales**:
  - ✅ Test de CPU single-thread (sysbench)
  - ✅ Test de CPU multi-thread con todos los cores
  - ✅ Test de Memoria RAM (10GB de transferencia)
  - ✅ Test de Disco I/O (lectura Y escritura de 1GB)
  - ✅ Test de Red (latencia con 10 pings)
- **Reporte automático siempre generado** con resultados numéricos
- **Resultados comparables** entre diferentes servidores
- **Tiempo de ejecución**: 3-5 minutos
- **Interfaz mejorada** con progreso paso a paso [1/6] a [6/6]

### 📊 Características del Reporte
- Velocidad de escritura/lectura de disco (MB/s o GB/s)
- Eventos por segundo de CPU
- Tasa de transferencia de memoria (MB/s)
- Latencia de red promedio (ms)
- Información completa del hardware

## [1.3.0] - 2026-01-04

### ✨ Añadido
- **Sistema de Reportes Completo**:
  - Generación automática de reportes en archivos .txt
  - Directorio centralizado: `~/lxapp_reports/`
  - Reporte del Test Completo con información detallada del sistema
  - Opción para guardar o no al finalizar cada prueba
  - Nueva opción 12: "Ver Reportes Guardados"
  - Listado de reportes con fecha, tamaño y nombre
  - Visualización directa de reportes desde el menú
  - Instrucciones para abrir con nano o cat

### 🔧 Funcionalidades del Sistema de Reportes
- Crear directorio automático de reportes
- Nombres de archivo con timestamp y hostname
- Encabezados formatados con información del servidor
- Secciones organizadas por tipo de información
- Footer con branding LXApp + idealored.com

###  📝 Estructura de Reportes
- CPU: Información completa del procesador
- Memoria: free + /proc/meminfo
- Disco: df + uso por directorio (top 10)
- Red: interfaces + configuración
- Sistema: uptime + procesos activos

## [1.2.0] - 2026-01-04

### ✨ Añadido
- **Pruebas Avanzadas de Rendimiento**:
  - Test de CPU Multi-Thread: Benchmarking con todos los cores disponibles
  - Test de Ancho de Banda de Red con iperf3: Modo servidor y cliente
  - Test de Latencia de Disco con ioping: Medición precisa de latencia I/O
  - Benchmark de Base de Datos: Simula carga MySQL/PostgreSQL con sysbench
  - Stress Test del Sistema con stress-ng: Carga extrema configurable (ligera/moderada/intensa)
- Menú reorganizado con secciones "Pruebas Básicas" y "Pruebas Avanzadas"
- Detección automática de CPUs con `nproc` para tests multi-thread
- Opciones personalizables en test de latencia de disco y stress test

### 🔧 Cambiado
- Ampliado menú de rendimiento de 6 a 11 opciones
- Test de CPU ahora específica single-thread vs multi-thread
- Actualización de herramientas incluye: ioping y stress-ng
- Mejorada descripción de cada opción en el menú

### 📦 Herramientas Nuevas
- `ioping` - Latencia de disco
- `stress-ng` - Stress testing avanzado

## [1.1.0] - 2026-01-04

### ✨ Añadido
- **Módulo Profesional de Gestión de Ceph**:
  - Selección de versión (Ceph v18 Reef o v19 Squid)
  - Bootstrap de primer nodo con cephadm
  - Gestión de nodos adicionales en el cluster
  - Detección inteligente de discos candidatos para OSDs
  - Soporte para entornos LOCAL y EXTERNO (datacenter)
  - Configuración de dashboard con IP interna/externa
  - Función para purgar clusters rotos por FSID
  - Validación de IPs y hostnames
  - Instalación automática de dependencias (podman, chrony, lvm2)
  - Soporte para contenedores con Podman/Docker

### 🔧 Cambiado
- Reemplazado módulo básico de Ceph por versión profesional completa
- Mejorada la experiencia de usuario con validación de entrada
- Añadida opción para especificar red de cluster personalizada

## [1.0.0] - 2026-01-04

### ✨ Añadido
- Menú principal interactivo con navegación modular
- Módulo de **Pruebas de Rendimiento del Servidor**:
  - Test de CPU con sysbench
  - Test de memoria RAM
  - Test de disco I/O con dd
  - Test de red con ping y speedtest-cli
  - Test completo del sistema
  - Actualización independiente de herramientas de benchmarking
- Módulo de **Gestión de Ceph**:
  - Instalación automatizada de Ceph
  - Verificación de estado del cluster
  - Configuración de nuevos OSDs
  - Listado de pools existentes
  - Creación de nuevos pools
  - Actualización independiente de Ceph
  - Visualización de logs del sistema
- Módulo de **Monitorización del Sistema**:
  - Visualización de procesos con htop
  - Análisis de uso de disco
  - Monitorización de memoria y CPU en tiempo real
  - Listado de conexiones de red activas
  - Estado de servicios del sistema
  - Actualización independiente de herramientas de monitorización
- Sistema de colores ANSI para mejor visualización
- Función de pausa entre operaciones
- Encabezado visual con ASCII art
- Verificación de comandos antes de ejecutarlos
- Solicitud de confirmación para operaciones críticas
- Opción de actualización del sistema completo
- Pantalla de información del sistema

### 🔧 Detalles Técnicos
- Script escrito en Bash
- Compatible con distribuciones basadas en Debian/Ubuntu
- Uso de apt para gestión de paquetes
- Sistema modular con funciones independientes
- Menús anidados con navegación fluida

### 📋 Planificado para Futuras Versiones
- Soporte para más distribuciones Linux (CentOS, RHEL, Arch)
- Módulo de gestión de bases de datos
- Exportación de reportes de rendimiento
- Configuración personalizable mediante archivo de configuración
- Modo de ejecución no interactivo para automatización
- Registro de logs de las operaciones realizadas
- Notificaciones por email o Telegram

---

## [Unreleased]

### 🔜 En Desarrollo
- Módulo de gestión de backups
- Integración con Prometheus para métricas
- Dashboard web para visualización remota

---

## Formato de Versionado

Este proyecto usa [Semantic Versioning](https://semver.org/):
- **MAJOR**: Cambios incompatibles en la API
- **MINOR**: Nueva funcionalidad compatible con versiones anteriores
- **PATCH**: Correcciones de bugs compatibles con versiones anteriores

### Tipos de Cambios
- **Añadido**: Para nuevas características
- **Cambiado**: Para cambios en funcionalidad existente
- **Obsoleto**: Para características que serán eliminadas pronto
- **Eliminado**: Para características eliminadas
- **Corregido**: Para corrección de bugs
- **Seguridad**: Para cambios de seguridad
