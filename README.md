# 🖥️ LXApp - Sistema de Administración de Servidores Linux

Script interactivo con menús modulares para la administración y monitorización de servidores Linux, con módulo profesional de gestión de Ceph Storage.

![Version](https://img.shields.io/badge/version-1.7.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Bash](https://img.shields.io/badge/bash-4.0%2B-orange.svg)
![Ceph](https://img.shields.io/badge/ceph-v18%20%7C%20v19-red.svg)
![Website](https://img.shields.io/badge/web-idealored.com-blue.svg)

> 🌐 **Desarrollado por [idealored.com](https://www.idealored.com)**

## 📋 Características

- **Menú Modular**: Navegación intuitiva entre diferentes módulos
- **Pruebas de Rendimiento**: Tests de CPU, Memoria, Disco y Red (12 opciones)
- **Gestión Profesional de Ceph**:
  - Selección de versión (v18 Reef / v19 Squid)
  - Bootstrap y configuración de clusters
  - Gestión de nodos y OSDs
  - Soporte para entornos LOCAL y EXTERNO (datacenter)
- **Instalador de Nextcloud**: Instalación guiada con Nginx, MariaDB/PostgreSQL, Redis y SSL
- **Instalador de Docker CE**: Última versión desde repositorio oficial con docker-compose
- **Monitorización en Tiempo Real**: Seguimiento de procesos, servicios y recursos
- **Sistema de Reportes**: Generación automática en `~/lxapp_reports/`
- **Actualización Independiente**: Actualiza solo los componentes que necesites
- **Interfaz Colorida**: Mejor visualización con códigos de color ANSI

## 🚀 Inicio Rápido

### Prerrequisitos

- Sistema operativo Linux (Ubuntu, Debian, CentOS, etc.)
- Bash 4.0 o superior
- Permisos de sudo para ciertas operaciones

### Instalación

```bash
# Clonar el repositorio
git clone https://github.com/idealoredapp/lxapp.git

# Navegar al directorio
cd lxapp

# Dar permisos de ejecución
chmod +x menu-admin.sh

# Ejecutar el script
./menu-admin.sh
```

## 📖 Uso

### Menú Principal

Al ejecutar el script, verás el menú principal con las siguientes opciones:

```
1) Pruebas de Rendimiento del Servidor
2) Gestión de Ceph
3) Monitorización del Sistema
4) Actualizar Sistema Completo
5) Información del Sistema
6) Instalar Nextcloud
7) Instalar Docker (última versión)
0) Salir
```

### Módulos Disponibles

#### 🔧 Pruebas de Rendimiento

Realiza pruebas exhaustivas del servidor:
- **Test de CPU**: Benchmarking con sysbench
- **Test de Memoria**: Pruebas de rendimiento RAM
- **Test de Disco**: Medición de I/O de lectura/escritura
- **Test de Red**: Ping y velocidad de conexión
- **Test Completo**: Resumen de todos los recursos

#### 💾 Gestión Profesional de Ceph

Administra tu cluster de almacenamiento Ceph con funcionalidades avanzadas:

**Características principales:**
- **Selección de Versión**: Elige entre Ceph v18 (Reef) o v19 (Squid)
- **Bootstrap de Cluster**: Inicializa el primer nodo con cephadm
- **Gestión de Nodos**: Añade nodos adicionales al cluster
- **Gestión de OSDs**: Detección inteligente y configuración de discos
- **Entornos Múltiples**: Soporte para LOCAL (LAN) y EXTERNO (datacenter)
- **Dashboard**: Configuración automática con IPs internas/externas
- **Recuperación**: Purgar clusters rotos por FSID
- **Dependencias**: Instalación automática (podman, chrony, lvm2)

**Menú del módulo:**
```
1) Seleccionar versión Ceph (v18 o v19)
2) Instalar PRIMER nodo (bootstrap)
3) Añadir NODO adicional
4) Agregar OSDs (en ESTE nodo)
5) Ver estado del cluster
6) Cambiar contraseña dashboard
7) Ver nodos y OSDs
8) Purgar cluster roto (FSID)
```

#### 📊 Monitorización del Sistema

Monitorea tu servidor en tiempo real:
- Procesos activos con htop
- Análisis de uso de disco
- Estadísticas de CPU y memoria
- Conexiones de red activas
- Estado de servicios del sistema

## 🛠️ Herramientas Utilizadas

El script utiliza las siguientes herramientas (se instalan automáticamente si faltan):

**Rendimiento:**
- `sysbench` - Benchmarking de sistema
- `speedtest-cli` - Test de velocidad de red
- `iperf3` - Medición de ancho de banda

**Monitorización:**
- `htop` - Monitor de procesos interactivo
- `sysstat` - Utilidades de monitorización
- `iotop` - Monitor de I/O
- `nethogs` - Monitor de ancho de banda por proceso

**Ceph Storage:**
- `cephadm` - Orquestador de Ceph (v18/v19)
- `podman` - Motor de contenedores
- `chrony` - Sincronización de tiempo
- `lvm2` - Gestión de volúmenes lógicos

## 📝 Ejemplos de Uso

### Ejecutar test de rendimiento completo

```bash
./menu-admin.sh
# Seleccionar opción 1 (Pruebas de Rendimiento)
# Luego opción 5 (Test Completo)
```

### Bootstrap de cluster Ceph

```bash
./menu-admin.sh
# Seleccionar opción 2 (Gestión de Ceph)
# Opción 1: Seleccionar versión (v18 o v19)
# Opción 2: Instalar PRIMER nodo (bootstrap)
#   - Elegir entorno: LOCAL o EXTERNO
#   - Ingresar IP interna del nodo
#   - (Opcional) IP externa para dashboard
#   - Configurar red de cluster
#   - Establecer contraseña del dashboard
```

### Añadir nodo al cluster Ceph

```bash
./menu-admin.sh
# Seleccionar opción 2 (Gestión de Ceph)
# Opción 3: Añadir NODO adicional
#   - Ingresar hostname del nuevo nodo
#   - Ingresar IP interna del nodo
#   - Ingresar IP del master para SSH
```

### Monitorizar procesos en tiempo real

```bash
./menu-admin.sh
# Seleccionar opción 3 (Monitorización)
# Luego opción 1 (Procesos en Ejecución)
```

## 🔄 Control de Versiones

Ver el archivo [CHANGELOG.md](CHANGELOG.md) para el historial completo de cambios.

### Versión Actual: 1.7.0

- ✅ Menú principal con navegación modular (7 opciones)
- ✅ **Módulo de pruebas de rendimiento** (12 opciones)
  - Pruebas básicas: CPU, RAM, Disco, Red
  - Pruebas avanzadas: Multi-thread, iperf3, ioping, DB, stress-ng
  - Sistema de reportes en `~/lxapp_reports/`
- ✅ **Módulo profesional de gestión de Ceph (v18/v19)**
  - Bootstrap de cluster, nodos adicionales, OSDs
  - Entornos LOCAL y EXTERNO (datacenter)
- ✅ **Monitorización del sistema** (htop, ss, df, sysstat)
- ✅ **Instalador de Nextcloud** (Nginx + MariaDB/PostgreSQL + Redis + SSL)
- ✅ **Instalador de Docker CE** (última versión oficial + docker-compose)
  - Repositorio oficial Docker con clave GPG
  - Detección automática de distro (Ubuntu/Debian/Raspbian/Mint)
  - Habilita servicio systemd y gestión de permisos de usuario
- ✅ Compatible con root y sudo (contenedores LXC/VPS)

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Haz un Fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/NuevaCaracteristica`)
3. Commit tus cambios (`git commit -m 'Agregar nueva característica'`)
4. Push a la rama (`git push origin feature/NuevaCaracteristica`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👤 Autor

**idealored**

- 🌐 Website: [idealored.com](https://www.idealored.com)
- 💻 GitHub: [@idealoredapp](https://github.com/idealoredapp)
- 📦 Repositorio: [lxapp](https://github.com/idealoredapp/lxapp)

## 🙏 Agradecimientos

- Comunidad de código abierto
- Documentación oficial de Ceph
- Proyecto sysbench
- Proyecto cephadm

## 📞 Soporte

Si encuentras algún problema o tienes sugerencias:

- Abre un [Issue](https://github.com/idealoredapp/lxapp/issues)
- Contacta al autor

---

⭐ Si te ha sido útil este proyecto, ¡dale una estrella en GitHub!
