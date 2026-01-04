# Changelog

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

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
- Módulo de gestión de Docker y contenedores
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
