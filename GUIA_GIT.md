# 📘 Guía Git para Publicar en GitHub

Esta guía te ayudará a publicar tu proyecto en GitHub y mantener un control de versiones profesional.

## 🎯 Pasos para Publicar en GitHub

### 1️⃣ Crear Repositorio en GitHub

1. Ve a [GitHub](https://github.com)
2. Haz clic en el botón **"New"** o **"+"** → **"New repository"**
3. Completa la información:
   - **Repository name**: `admin-server-menu` (o el nombre que prefieras)
   - **Description**: "Script interactivo para administración de servidores Linux"
   - **Public** o **Private**: Selecciona según prefieras
   - ❌ **NO** inicialices con README (ya lo tenemos)
4. Haz clic en **"Create repository"**

### 2️⃣ Inicializar Git Localmente

Desde tu directorio del proyecto, ejecuta:

```bash
# Navega al directorio del proyecto
cd /ruta/a/tu/proyecto/lxapp

# Inicializa el repositorio Git
git init

# Configura tu nombre y email (solo la primera vez)
git config --global user.name "Tu Nombre"
git config --global user.email "tu.email@ejemplo.com"
```

### 3️⃣ Agregar Archivos al Repositorio

```bash
# Ver el estado de los archivos
git status

# Agregar todos los archivos al staging
git add .

# O agregar archivos específicos
git add menu-admin.sh
git add README.md
git add CHANGELOG.md

# Verificar qué archivos están en staging
git status
```

### 4️⃣ Hacer el Primer Commit

```bash
# Crear el commit inicial
git commit -m "feat: versión inicial del sistema de administración de servidores

- Menú principal con navegación modular
- Módulo de pruebas de rendimiento
- Módulo de gestión de Ceph
- Módulo de monitorización del sistema
- Documentación completa"
```

### 5️⃣ Conectar con GitHub

```bash
# Agregar el repositorio remoto (reemplaza TU_USUARIO y NOMBRE_REPO)
git remote add origin https://github.com/TU_USUARIO/NOMBRE_REPO.git

# Verificar que se agregó correctamente
git remote -v

# Renombrar la rama a 'main' (GitHub usa 'main' por defecto)
git branch -M main
```

### 6️⃣ Subir a GitHub

```bash
# Subir todos los commits al repositorio remoto
git push -u origin main
```

Si te pide autenticación, usa un **Personal Access Token** en lugar de contraseña:
- Ve a GitHub → Settings → Developer settings → Personal access tokens → Generate new token
- Dale permisos de `repo`
- Copia el token y úsalo como contraseña

---

## 🔄 Workflow Diario de Git

### Hacer Cambios y Crear Nueva Versión

```bash
# 1. Ver archivos modificados
git status

# 2. Agregar cambios
git add menu-admin.sh           # Archivo específico
git add .                       # Todos los archivos

# 3. Hacer commit con mensaje descriptivo
git commit -m "feat(ceph): agregar opción para monitorear OSDs"

# 4. Subir a GitHub
git push
```

### Tipos de Mensajes de Commit

```bash
# Nueva característica
git commit -m "feat(modulo): descripción de la nueva funcionalidad"

# Corrección de bug
git commit -m "fix(modulo): descripción del bug corregido"

# Actualización de documentación
git commit -m "docs: actualizar README con nuevas instrucciones"

# Refactorización de código
git commit -m "refactor: reorganizar funciones del menú principal"

# Mejora de rendimiento
git commit -m "perf: optimizar test de disco I/O"

# Cambios de estilo (formato, espacios)
git commit -m "style: formatear código según guía de estilo"
```

### Ver Historial de Cambios

```bash
# Ver todos los commits
git log

# Ver commits de forma resumida
git log --oneline

# Ver últimos 5 commits
git log -n 5

# Ver cambios en un archivo específico
git log -- menu-admin.sh
```

### Trabajar con Ramas

```bash
# Crear nueva rama para una característica
git checkout -b feature/nueva-funcionalidad

# Hacer cambios y commits en la rama
git add .
git commit -m "feat: agregar nueva funcionalidad"

# Volver a la rama main
git checkout main

# Fusionar la rama (merge)
git merge feature/nueva-funcionalidad

# Eliminar rama después de fusionar
git branch -d feature/nueva-funcionalidad
```

### Actualizar CHANGELOG.md con Cada Versión

Cuando hagas cambios significativos:

1. Edita `CHANGELOG.md`
2. Agrega la nueva versión siguiendo el formato:

```markdown
## [1.1.0] - 2026-01-15

### ✨ Añadido
- Nueva opción para monitorear OSDs de Ceph en tiempo real
- Comando para exportar reportes de rendimiento

### 🐛 Corregido
- Bug en test de disco que fallaba con sistemas btrfs

### 🔧 Cambiado
- Mejorado el rendimiento del test de CPU
```

3. Haz commit del changelog:

```bash
git add CHANGELOG.md
git commit -m "docs: actualizar changelog para v1.1.0"
```

### Crear Tags para Versiones

```bash
# Crear tag para la versión
git tag -a v1.0.0 -m "Versión 1.0.0 - Lanzamiento inicial"

# Subir el tag a GitHub
git push origin v1.0.0

# Subir todos los tags
git push --tags

# Ver todos los tags
git tag
```

---

## 🏷️ Sistema de Versionado Semántico

Usa **Semantic Versioning** (MAJOR.MINOR.PATCH):

```
v1.2.3
│ │ │
│ │ └─── PATCH: Corrección de bugs (1.2.3 → 1.2.4)
│ └───── MINOR: Nueva funcionalidad compatible (1.2.3 → 1.3.0)
└─────── MAJOR: Cambios incompatibles (1.2.3 → 2.0.0)
```

**Ejemplos**:
- `v1.0.0` → Versión inicial
- `v1.0.1` → Corrección de un bug
- `v1.1.0` → Agregaste nueva característica
- `v2.0.0` → Cambiaste la estructura del menú completamente

---

## 📊 Ver Tu Repositorio en GitHub

Una vez publicado, podrás:

1. **Ver el código** en `https://github.com/TU_USUARIO/NOMBRE_REPO`
2. **Crear releases** desde la pestaña "Releases"
3. **Ver estadísticas** de commits, contribuidores, etc.
4. **Recibir issues** y pull requests de otros usuarios

---

## 🆘 Comandos Útiles para Solución de Problemas

```bash
# Deshacer último commit (mantiene cambios)
git reset --soft HEAD~1

# Deshacer cambios no commiteados en un archivo
git checkout -- archivo.sh

# Ver diferencias antes de hacer commit
git diff

# Ver diferencias de archivos en staging
git diff --staged

# Actualizar repositorio desde GitHub
git pull origin main

# Clonar tu propio repositorio en otra máquina
git clone https://github.com/TU_USUARIO/NOMBRE_REPO.git
```

---

## ✅ Checklist Antes de Publicar

- [ ] Todos los archivos importantes están en el repositorio
- [ ] El `.gitignore` excluye archivos sensibles
- [ ] El `README.md` tiene instrucciones claras
- [ ] El `CHANGELOG.md` documenta la versión inicial
- [ ] El `LICENSE` está incluido
- [ ] Has hecho `git add .` y `git commit`
- [ ] Has configurado el remote con `git remote add origin`
- [ ] Has hecho el primer `git push -u origin main`

---

## 🎓 Recursos para Aprender Git

- [Git Book (Español)](https://git-scm.com/book/es/v2)
- [GitHub Guides](https://guides.github.com/)
- [Keep a Changelog](https://keepachangelog.com/es/)
- [Semantic Versioning](https://semver.org/lang/es/)

---

¡Ahora estás listo para publicar y mantener tu proyecto en GitHub! 🚀
