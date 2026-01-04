# 📦 Instrucciones para Crear Releases en GitHub

## 🎯 Objetivo
Crear releases visibles en GitHub para mostrar el historial de versiones de LXApp.

## 🔗 URL para crear releases
https://github.com/idealoredapp/lxapp/releases/new

---

## 📋 Release v1.1.0 (Más Reciente)

### Paso 1: Ir a crear release
1. Ve a: https://github.com/idealoredapp/lxapp/releases/new
2. Inicia sesión si es necesario

### Paso 2: Completar formulario

**Tag version:** `v1.1.0`

**Release title:** `🖥️ LXApp v1.1.0 - Módulo Profesional de Ceph`

**Description:**
```markdown
## 🎯 Módulo Profesional de Ceph Storage

Esta versión introduce un módulo completamente profesional para la gestión de clusters Ceph Storage, con soporte para v18 (Reef) y v19 (Squid).

### ✨ Nuevas Características

#### 🔹 Gestión Avanzada de Ceph
- **Selección de Versión**: Soporte para Ceph v18 (Reef) y v19 (Squid)
- **Bootstrap Automatizado**: Inicialización de primer nodo con cephadm
- **Gestión de Nodos**: Añadir nodos adicionales al cluster de forma guiada
- **Detección Inteligente de OSDs**: Identifica automáticamente discos candidatos
- **Entornos Múltiples**: Soporte para LOCAL (LAN) y EXTERNO (datacenter)
- **Dashboard Configurado**: Setup automático con validación de IPs
- **Recuperación de Clusters**: Función para purgar clusters rotos por FSID

#### 🔹 Funcionalidades del Módulo Ceph
1. Seleccionar versión Ceph (v18 o v19)
2. Instalar PRIMER nodo (bootstrap)
3. Añadir NODO adicional
4. Agregar OSDs (en ESTE nodo)
5. Ver estado del cluster
6. Cambiar contraseña dashboard
7. Ver nodos y OSDs
8. Purgar cluster roto (FSID)

#### 🔹 Instalación Automática
- Descarga automática de `cephadm` según versión
- Instalación de dependencias: `podman`, `chrony`, `lvm2`, `openssh-server`
- Configuración de repositorios oficiales de Ceph
- Instalación de `ceph-common` y herramientas CLI

### 🔧 Mejoras
- Reemplazado módulo básico de Ceph por versión profesional completa
- Mejorada experiencia de usuario con validación de entrada
- Añadida opción para especificar red de cluster personalizada
- Protección del disco del sistema operativo
- Soporte para contenedores con Podman/Docker

### 📝 Archivos Modificados
- `menu-admin.sh` - +350 líneas de código profesional de Ceph
- `CHANGELOG.md` - Documentación de cambios v1.1.0
- `README.md` - Actualización con nuevas características

### 🚀 Instalación

```bash
git clone https://github.com/idealoredapp/lxapp.git
cd lxapp
chmod +x menu-admin.sh
./menu-admin.sh
```

### 📚 Documentación
- [README.md](https://github.com/idealoredapp/lxapp/blob/main/README.md)
- [CHANGELOG.md](https://github.com/idealoredapp/lxapp/blob/main/CHANGELOG.md)
- [RELEASES.md](https://github.com/idealoredapp/lxapp/blob/main/RELEASES.md)

### 🌐 Autor
**idealored** - [idealored.com](https://www.idealored.com)

---

**Full Changelog**: https://github.com/idealoredapp/lxapp/compare/v1.0.0...v1.1.0
```

### Paso 3: Finalizar
- Marcar como "Latest release" ✅
- Clic en **"Publish release"**

---

## 📋 Release v1.0.0 (Inicial)

### Paso 1: Ir a crear release
1. Ve a: https://github.com/idealoredapp/lxapp/releases/new

### Paso 2: Completar formulario

**Tag version:** `v1.0.0`

**Release title:** `🎉 LXApp v1.0.0 - Lanzamiento Inicial`

**Description:**
```markdown
## 🎉 Lanzamiento Inicial de LXApp

Primera versión pública de **LXApp** - Sistema de Administración de Servidores Linux con menús modulares.

### ✨ Características Principales

#### 🔹 Menú Modular
- Navegación intuitiva entre módulos independientes
- Sistema de colores ANSI para mejor visualización
- Interfaz de usuario limpia y profesional

#### 🔹 Módulo de Pruebas de Rendimiento
- **Test de CPU**: Benchmarking con sysbench
- **Test de Memoria RAM**: Pruebas de rendimiento de memoria
- **Test de Disco (I/O)**: Medición de lectura/escritura con dd
- **Test de Red**: Ping y speedtest-cli
- **Test Completo**: Resumen de todos los recursos del sistema
- **Actualización Independiente**: Instalar/actualizar solo herramientas de benchmarking

#### 🔹 Módulo de Gestión de Ceph (Básico)
- Instalación de Ceph
- Verificación de estado del cluster
- Configuración de nuevos OSDs
- Gestión de pools
- Visualización de logs
- Actualización de paquetes Ceph

#### 🔹 Módulo de Monitorización
- **Procesos**: Visualización con htop/top
- **Uso de Disco**: Análisis con df y du
- **CPU y Memoria**: Estadísticas en tiempo real
- **Conexiones de Red**: Listado con ss
- **Servicios**: Estado de servicios systemd

#### 🔹 Funciones del Sistema
- Actualización completa del sistema
- Información detallada del sistema
- Gestión de paquetes con APT

### 📦 Componentes Incluidos

**Scripts:**
- `menu-admin.sh` - Script principal (413 líneas)
- `git-helper.sh` - Asistente para Git

**Documentación:**
- `README.md` - Documentación completa
- `CHANGELOG.md` - Historial de cambios
- `CONTRIBUTING.md` - Guía para contribuidores
- `GUIA_GIT.md` - Tutorial de Git en español
- `LICENSE` - Licencia MIT

### 🛠️ Herramientas Utilizadas

- `sysbench`, `htop`, `speedtest-cli`, `iperf3`
- `sysstat`, `ceph`, y más

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

**idealored** - [idealored.com](https://www.idealored.com)
```

### Paso 3: Finalizar
- NO marcar como "Latest release" (ya hay v1.1.0)
- Clic en **"Publish release"**

---

## ✅ Resultado Final

Después de crear ambas releases, tu repositorio mostrará:

1. **En la página principal**: Badge con "2 releases"
2. **En /releases**: Lista de versiones con changelog
3. **Sidebar**: "Latest release" apuntando a v1.1.0

---

## 🔄 Para Futuras Versiones

Cuando actualices a v1.2.0, v2.0.0, etc:

1. Actualiza `CHANGELOG.md`
2. Actualiza versión en `menu-admin.sh` y `README.md`
3. Haz commit y push
4. Crea tag: `git tag -a v1.2.0 -m "Descripción"`
5. Push tag: `git push origin v1.2.0`
6. Crea release en GitHub con el contenido del CHANGELOG

---

📌 **Tip**: Puedes usar el archivo `RELEASES.md` como plantilla para futuras releases.
