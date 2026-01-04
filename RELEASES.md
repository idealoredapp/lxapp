# 📦 Releases - LXApp

Historial completo de versiones publicadas de LXApp.

---

## [v1.1.0](https://github.com/idealoredapp/lxapp/releases/tag/v1.1.0) - 2026-01-04

### 🎯 Módulo Profesional de Ceph

Esta versión introduce un módulo completamente profesional para la gestión de clusters Ceph Storage.

### ✨ Nuevas Características

#### Gestión Avanzada de Ceph
- **Selección de Versión**: Soporte para Ceph v18 (Reef) y v19 (Squid)
- **Bootstrap Automatizado**: Inicialización de primer nodo con cephadm
- **Gestión de Nodos**: Añadir nodos adicionales al cluster de forma guiada
- **Detección Inteligente de OSDs**: Identifica automáticamente discos candidatos
- **Entornos Múltiples**: Soporte para LOCAL (LAN) y EXTERNO (datacenter)
- **Dashboard Configurado**: Setup automático con validación de IPs
- **Recuperación de Clusters**: Función para purgar clusters rotos por FSID
- **Validación Completa**: IPs, hostnames y configuraciones validadas

#### Instalación Automática
- Descarga automática de `cephadm` según versión seleccionada
- Instalación de dependencias: `podman`, `chrony`, `lvm2`, `openssh-server`
- Configuración de repositorios oficiales de Ceph
- Instalación de `ceph-common` y herramientas CLI

#### Funcionalidades del Módulo
1. Seleccionar versión Ceph (v18 o v19)
2. Instalar PRIMER nodo (bootstrap)
3. Añadir NODO adicional
4. Agregar OSDs (en ESTE nodo)
5. Ver estado del cluster
6. Cambiar contraseña dashboard
7. Ver nodos y OSDs
8. Purgar cluster roto (FSID)

### 🔧 Mejoras

- Reemplazado módulo básico de Ceph por versión profesional completa
- Mejorada experiencia de usuario con validación de entrada
- Añadida opción para especificar red de cluster personalizada
- Soporte para contenedores con Podman/Docker
- Funciones auxiliares para gestión segura de discos
- Protección del disco del sistema operativo

### 📝 Archivos Modificados

- `menu-admin.sh` - +350 líneas de código profesional de Ceph
- `CHANGELOG.md` - Documentación de cambios v1.1.0
- `README.md` - Actualización con nuevas características

### 🔗 Enlaces

- [Código Fuente](https://github.com/idealoredapp/lxapp/archive/refs/tags/v1.1.0.zip)
- [Documentación](https://github.com/idealoredapp/lxapp/blob/main/README.md)
- [Changelog](https://github.com/idealoredapp/lxapp/blob/main/CHANGELOG.md)

---

## [v1.0.0](https://github.com/idealoredapp/lxapp/releases/tag/v1.0.0) - 2026-01-04

### 🎉 Lanzamiento Inicial

Primera versión pública de **LXApp** - Sistema de Administración de Servidores Linux.

### ✨ Características Principales

#### Menú Modular
- Navegación intuitiva entre módulos independientes
- Sistema de colores ANSI para mejor visualización
- Interfaz de usuario limpia y profesional

#### Módulo de Pruebas de Rendimiento
- **Test de CPU**: Benchmarking con sysbench
- **Test de Memoria RAM**: Pruebas de rendimiento de memoria
- **Test de Disco (I/O)**: Medición de lectura/escritura con dd
- **Test de Red**: Ping y speedtest-cli
- **Test Completo**: Resumen de todos los recursos del sistema
- **Actualización Independiente**: Instalar/actualizar solo herramientas de benchmarking

#### Módulo de Gestión de Ceph (Básico)
- Instalación de Ceph
- Verificación de estado del cluster
- Configuración de nuevos OSDs
- Gestión de pools
- Visualización de logs
- Actualización de paquetes Ceph

#### Módulo de Monitorización
- **Procesos**: Visualización con htop/top
- **Uso de Disco**: Análisis con df y du
- **CPU y Memoria**: Estadísticas en tiempo real
- **Conexiones de Red**: Listado con ss
- **Servicios**: Estado de servicios systemd
- **Actualización Independiente**: Herramientas de monitorización

#### Funciones del Sistema
- Actualización completa del sistema
- Información detallada del sistema
- Gestión de paquetes con APT

### 📦 Componentes Incluidos

**Scripts:**
- `menu-admin.sh` - Script principal (413 líneas)
- `git-helper.sh` - Asistente para Git

**Documentación:**
- `README.md` - Documentación completa del proyecto
- `CHANGELOG.md` - Historial de cambios
- `CONTRIBUTING.md` - Guía para contribuidores
- `GUIA_GIT.md` - Tutorial de Git en español
- `LICENSE` - Licencia MIT

**Configuración:**
- `.gitignore` - Archivos excluidos de Git

### 🛠️ Herramientas Utilizadas

- `sysbench` - Benchmarking
- `htop` - Monitor de procesos
- `speedtest-cli` - Test de velocidad
- `iperf3` - Ancho de banda
- `sysstat` - Estadísticas del sistema
- `ceph` - Almacenamiento distribuido

### 🚀 Inicio Rápido

```bash
git clone https://github.com/idealoredapp/lxapp.git
cd lxapp
chmod +x menu-admin.sh
./menu-admin.sh
```

### 📄 Licencia

Este proyecto se distribuye bajo la Licencia MIT.

### 🌐 Autor

**idealored**
- Website: [idealored.com](https://www.idealored.com)
- GitHub: [@idealoredapp](https://github.com/idealoredapp)

---

## 🔄 Formato de Versionado

LXApp sigue [Semantic Versioning](https://semver.org/lang/es/):

- **MAJOR** (X.0.0): Cambios incompatibles en la API
- **MINOR** (1.X.0): Nueva funcionalidad compatible con versiones anteriores
- **PATCH** (1.1.X): Correcciones de bugs compatibles

---

📌 **Nota**: Para ver el changelog detallado de cada versión, consulta [CHANGELOG.md](CHANGELOG.md)
