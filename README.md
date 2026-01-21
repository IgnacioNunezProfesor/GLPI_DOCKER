# GLPI + OCS Inventory Docker Setup

## 📋 Descripción del Proyecto

Este proyecto proporciona una configuración **Docker Compose** lista para usar que despliega dos aplicaciones de gestión de IT de forma integrada:

- **GLPI (Gestión de Inventario)**: Aplicación para la gestión centralizada de inventario IT, tickets de soporte y activos.
- **OCS Inventory**: Herramienta de inventario y administración de máquinas clientes para la recopilación automática de información de hardware y software.

Ambos servicios se ejecutan en contenedores Docker con bases de datos MariaDB independientes, proporcionando un entorno aislado y fácil de gestionar.

## 🎯 Propósito

Este proyecto está diseñado para:

✅ Facilitar la instalación y configuración de GLPI y OCS Inventory sin dependencias del sistema  
✅ Proporcionar un ambiente de desarrollo y pruebas con Docker  
✅ Mantener bases de datos independientes para cada aplicación  
✅ Permitir reiniciar, actualizar y gestionar los servicios de forma sencilla  
✅ Automatizar el levantamiento de servicios mediante scripts PowerShell

## 🏗️ Estructura del Proyecto

```
GLPI+OCS/
├── docker/
│   ├── docker-compose.glpi.yml      # Configuración principal de Docker Compose
│   ├── glpi_data/                   # Volumen persistente para datos de GLPI
│   ├── ocs_data/                    # Volumen persistente para datos de OCS
│   └── ocs_db_data/                 # Volumen persistente para BD de OCS
├── scripts/
│   └── start-docker-compose.ps1     # Script PowerShell para gestionar servicios
└── README.md                         # Este archivo
```

## 🐳 Servicios Incluidos

### 1. **GLPI (Puerto 8080)**
- **Imagen**: `glpi/glpi` (versión oficial)
- **Base de Datos**: MariaDB 10.11
- **URL de Acceso**: `http://localhost:8080`
- **Credenciales por defecto**: 
  - Usuario: `glpi`
  - Contraseña: `glpi`

### 2. **OCS Inventory (Puerto 8081)**
- **Imagen**: `ocsinventory/ocsinventory-docker-image:latest`
- **Base de Datos**: MariaDB 10.11
- **URL de Acceso**: `http://localhost:8081`
- **Volúmenes**: Reportes y datos persistentes

## 📋 Requisitos Previos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

- **Docker Desktop** (Windows/Mac) o **Docker Engine** (Linux)
- **Docker Compose** (generalmente incluido en Docker Desktop)
- **PowerShell** (para ejecutar los scripts de inicio en Windows)
- **Git** (opcional, para clonar el repositorio)

### Verificar Instalación

```powershell
docker --version
docker compose version
```

## 🚀 Cómo Lanzar el Proyecto

### Opción 1: Usar el Script PowerShell (Recomendado)

Desde PowerShell, navega a la raíz del proyecto:

```powershell
cd "C:\Ruta\del\proyecto\GLPI+OCS"
```

#### Iniciar los servicios:
```powershell
.\scripts\start-docker-compose.ps1
```

#### Iniciar con rebuild (si hay cambios en imágenes):
```powershell
.\scripts\start-docker-compose.ps1 -Build
```

#### Detener los servicios:
```powershell
.\scripts\start-docker-compose.ps1 -Down
```

### Opción 2: Usar Docker Compose Directamente

Si prefieres no usar el script, puedes ejecutar docker compose directamente:

```powershell
# Navega a la carpeta docker
cd docker

# Inicia los servicios en segundo plano
docker compose -f docker-compose.glpi.yml up -d

# Para detener los servicios
docker compose -f docker-compose.glpi.yml down

# Para ver los logs en tiempo real
docker compose -f docker-compose.glpi.yml logs -f
```

## 🌐 Acceso a las Aplicaciones

Una vez que los servicios se hayan iniciado correctamente:

| Servicio | URL | Usuario | Contraseña |
|----------|-----|---------|------------|
| **GLPI** | http://localhost:8080 | glpi | glpi |
| **OCS Inventory** | http://localhost:8081 | - | - |

> **Nota**: Las credenciales pueden cambiarse en el archivo `docker-compose.glpi.yml` antes de iniciar los servicios.

## 📊 Verificación del Estado

Para verificar que los contenedores se están ejecutando correctamente:

```powershell
# Ver estado de todos los contenedores
docker ps

# Ver logs de un servicio específico
docker logs glpi_app
docker logs ocs_server

# Ver logs de la base de datos
docker logs glpi_db
docker logs ocs_db
```

## 🔧 Configuración Personalizada

Para modificar la configuración, edita el archivo [docker/docker-compose.glpi.yml](docker/docker-compose.glpi.yml):

### Cambiar puertos:
```yaml
glpi:
  ports:
    - "8080:80"    # Cambiar el primer número para usar otro puerto local
```

### Cambiar contraseñas de base de datos:
```yaml
db_glpi:
  environment:
    MYSQL_ROOT_PASSWORD: tuContraseña
    MYSQL_PASSWORD: tuContraseña
```

## 💾 Volúmenes Persistentes

Los datos de las aplicaciones se almacenan en **bind mounts** (carpetas locales en la raíz del proyecto) para que persistan incluso después de reiniciar los contenedores:

```
GLPI+OCS/
├── glpi_data/              # Archivos y configuración de GLPI
├── glpi_db_data/           # Base de datos de GLPI
├── ocs_data/               # Reportes y datos de OCS
├── ocs_db_data/            # Base de datos de OCS
└── docker/
    └── docker-compose.glpi.yml
```

Esto permite:
- ✅ Acceso directo a los archivos desde el sistema de archivos
- ✅ Copias de seguridad fáciles
- ✅ Edición de archivos sin acceder al contenedor
- ✅ Persistencia de datos entre reinicios

Para eliminar todos los datos (⚠️ **Elimina las carpetas completas**):
```powershell
Remove-Item -Path glpi_data, glpi_db_data, ocs_data, ocs_db_data -Recurse -Force
```

## 📝 Comandos Útiles

```powershell
# Ver espacio usado por Docker
docker system df

# Limpiar recursos no usados
docker system prune -a

# Ver estadísticas de uso en tiempo real
docker stats

# Acceder a la terminal de un contenedor
docker exec -it glpi_app bash
docker exec -it ocs_server bash

# Ver variables de entorno de un contenedor
docker exec glpi_app env
```

## 🐛 Solución de Problemas

### Los contenedores no inician

**Problema**: `docker compose: command not found`  
**Solución**: Asegúrate de tener Docker Compose instalado. Si usas una versión antigua de Docker, usa `docker-compose` en lugar de `docker compose`.

### Puerto ya en uso

**Problema**: `Error: Bind for 0.0.0.0:8080 failed`  
**Solución**: Cambia el puerto en `docker-compose.glpi.yml` o detén la aplicación que usa ese puerto.

### Base de datos no se inicializa

**Problema**: GLPI o OCS no pueden conectarse a la BD  
**Solución**: 
- Espera 30 segundos a que MariaDB se inicialice completamente
- Verifica que los nombres de host en variables de entorno sean correctos
- Revisa los logs: `docker logs glpi_db` o `docker logs ocs_db`

### Permisos denegados en Windows

**Problema**: Error de permisos en volúmenes  
**Solución**: 
- Asegúrate de ejecutar PowerShell como administrador
- Revisa que el path no contiene caracteres especiales

## 📚 Recursos Útiles

- [Documentación oficial de GLPI](https://glpi-project.org/es/)
- [Documentación oficial de OCS Inventory](https://wiki.ocsinventory-ng.org/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [MariaDB Docker Hub](https://hub.docker.com/_/mariadb)

## 📄 Licencia

Este proyecto utiliza imágenes Docker oficiales de GLPI y OCS Inventory. Consulta sus respectivas licencias.

## 👨‍💻 Autor

**Ignacio Núñez Profesor**

---

**Última actualización**: Enero 2026
