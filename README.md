# 🖥️ Sistema de Administración de Servidores Linux

Script interactivo con menús modulares para la administración y monitorización de servidores Linux.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Bash](https://img.shields.io/badge/bash-4.0%2B-orange.svg)

## 📋 Características

- **Menú Modular**: Navegación intuitiva entre diferentes módulos
- **Pruebas de Rendimiento**: Tests de CPU, Memoria, Disco y Red
- **Gestión de Ceph**: Instalación, configuración y administración de Ceph Storage
- **Monitorización en Tiempo Real**: Seguimiento de procesos, servicios y recursos
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
git clone https://github.com/TU_USUARIO/admin-server-menu.git

# Navegar al directorio
cd admin-server-menu

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

#### 💾 Gestión de Ceph

Administra tu cluster de almacenamiento Ceph:
- Instalación automatizada de Ceph
- Verificación de estado del cluster
- Configuración de nuevos OSDs
- Gestión de pools
- Visualización de logs

#### 📊 Monitorización del Sistema

Monitorea tu servidor en tiempo real:
- Procesos activos con htop
- Análisis de uso de disco
- Estadísticas de CPU y memoria
- Conexiones de red activas
- Estado de servicios del sistema

## 🛠️ Herramientas Utilizadas

El script utiliza las siguientes herramientas (se instalan automáticamente si faltan):

- `sysbench` - Benchmarking de sistema
- `htop` - Monitor de procesos interactivo
- `speedtest-cli` - Test de velocidad de red
- `iperf3` - Medición de ancho de banda
- `ceph` - Gestión de almacenamiento distribuido
- `sysstat` - Utilidades de monitorización

## 📝 Ejemplos de Uso

### Ejecutar test de rendimiento completo

```bash
./menu-admin.sh
# Seleccionar opción 1 (Pruebas de Rendimiento)
# Luego opción 5 (Test Completo)
```

### Instalar y configurar Ceph

```bash
./menu-admin.sh
# Seleccionar opción 2 (Gestión de Ceph)
# Luego opción 1 (Instalar Ceph)
```

### Monitorizar procesos en tiempo real

```bash
./menu-admin.sh
# Seleccionar opción 3 (Monitorización)
# Luego opción 1 (Procesos en Ejecución)
```

## 🔄 Control de Versiones

Ver el archivo [CHANGELOG.md](CHANGELOG.md) para el historial completo de cambios.

### Versión Actual: 1.0.0

- Menú principal con navegación modular
- Módulo de pruebas de rendimiento
- Módulo de gestión de Ceph
- Módulo de monitorización del sistema
- Sistema de actualización independiente por módulo

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

**Tu Nombre**

- GitHub: [@TU_USUARIO](https://github.com/TU_USUARIO)

## 🙏 Agradecimientos

- Comunidad de código abierto
- Documentación oficial de Ceph
- Proyecto sysbench

## 📞 Soporte

Si encuentras algún problema o tienes sugerencias:

- Abre un [Issue](https://github.com/TU_USUARIO/admin-server-menu/issues)
- Contacta al autor

---

⭐ Si te ha sido útil este proyecto, ¡dale una estrella en GitHub!
