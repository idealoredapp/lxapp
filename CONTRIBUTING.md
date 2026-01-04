# 🤝 Guía de Contribución

¡Gracias por tu interés en contribuir al Sistema de Administración de Servidores Linux! 

## 📋 Código de Conducta

Este proyecto se adhiere a un código de conducta. Al participar, se espera que mantengas un ambiente respetuoso y colaborativo.

## 🚀 ¿Cómo Contribuir?

### 1. Reportar Bugs

Si encuentras un bug, por favor crea un issue con:

- **Descripción clara** del problema
- **Pasos para reproducir** el bug
- **Comportamiento esperado** vs **comportamiento actual**
- **Versión** del script y distribución de Linux
- **Logs o capturas** de pantalla si es posible

### 2. Sugerir Mejoras

Para sugerir nuevas características:

- Abre un issue con el tag `enhancement`
- Describe la funcionalidad propuesta
- Explica por qué sería útil
- Considera posibles alternativas

### 3. Contribuir Código

#### Preparación

```bash
# Fork el repositorio en GitHub

# Clona tu fork
git clone https://github.com/TU_USUARIO/admin-server-menu.git
cd admin-server-menu

# Agrega el repositorio original como upstream
git remote add upstream https://github.com/USUARIO_ORIGINAL/admin-server-menu.git
```

#### Crear una Rama

```bash
# Actualiza tu main
git checkout main
git pull upstream main

# Crea una rama para tu feature
git checkout -b feature/nombre-descriptivo
```

#### Realizar Cambios

1. **Escribe código limpio**:
   - Usa nombres de variables descriptivos
   - Comenta código complejo
   - Sigue el estilo del código existente

2. **Prueba tus cambios**:
   - Ejecuta el script en diferentes escenarios
   - Verifica que no rompa funcionalidad existente

3. **Documenta**:
   - Actualiza el README.md si es necesario
   - Agrega entradas al CHANGELOG.md

#### Commit de Cambios

Usa mensajes de commit descriptivos:

```bash
# Formato: tipo(ámbito): descripción

# Ejemplos:
git commit -m "feat(ceph): agregar opción para eliminar pools"
git commit -m "fix(rendimiento): corregir test de disco en sistemas btrfs"
git commit -m "docs(readme): actualizar ejemplos de uso"
```

**Tipos de commit**:
- `feat`: Nueva característica
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Formato, espacios (sin cambio de código)
- `refactor`: Refactorización de código
- `test`: Agregar o modificar tests
- `chore`: Tareas de mantenimiento

#### Push y Pull Request

```bash
# Push a tu fork
git push origin feature/nombre-descriptivo
```

Luego en GitHub:
1. Ve a tu fork
2. Haz clic en "Compare & pull request"
3. Describe tus cambios detalladamente
4. Enlaza issues relacionados si existen

## 📝 Estándares de Código

### Bash Style Guide

```bash
# Variables en minúsculas con guiones bajos
nombre_variable="valor"

# Constantes en mayúsculas
CONSTANTE="VALOR"

# Funciones con nombres descriptivos
function nombre_funcion() {
    # Código aquí
}

# Usar comillas dobles para variables
echo "${variable}"

# Verificar comandos antes de usar
if command -v htop &> /dev/null; then
    htop
fi

# Siempre verificar códigos de salida para operaciones críticas
if sudo apt install paquete; then
    echo "Instalación exitosa"
else
    echo "Error en instalación"
fi
```

### Comentarios

```bash
# Comentario de una línea para explicaciones breves

#########################################
# Bloque de comentarios para secciones
# importantes o encabezados de funciones
#########################################

# TODO: Tarea pendiente
# FIXME: Necesita corrección
# NOTE: Información importante
```

## 🧪 Testing

Antes de enviar un PR, asegúrate de probar:

1. **Menú principal**: Navegación entre opciones
2. **Cada submenú**: Todas las opciones funcionan
3. **Casos extremos**: 
   - Comandos no instalados
   - Sin permisos de sudo
   - Entradas inválidas
4. **Diferentes distribuciones**: Si es posible, prueba en Ubuntu, Debian, etc.

## 📚 Recursos Útiles

- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- [ShellCheck](https://www.shellcheck.net/) - Linter para scripts de shell
- [Conventional Commits](https://www.conventionalcommits.org/)

## 💬 Preguntas

Si tienes preguntas, puedes:

- Abrir un issue con la etiqueta `question`
- Contactar al mantenedor del proyecto

## 🎉 Reconocimientos

Todos los contribuyentes serán reconocidos en el README.md.

---

¡Gracias por contribuir! 🙏
