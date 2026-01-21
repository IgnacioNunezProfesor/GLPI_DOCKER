# 🔗 Configuración de GLPI para Obtener Datos de OCS Inventory

Este documento explica cómo integrar GLPI con OCS Inventory para sincronizar automáticamente el inventario de equipos.

## 📋 Índice

1. [Introducción](#introducción)
2. [Requisitos Previos](#requisitos-previos)
3. [Instalar Plugin OCS Inventory](#instalar-plugin-ocs-inventory)
4. [Configurar Conexión a OCS](#configurar-conexión-a-ocs)
5. [Sincronizar Equipos](#sincronizar-equipos)
6. [Mapeo de Campos](#mapeo-de-campos)
7. [Sincronización Automática](#sincronización-automática)
8. [Solución de Problemas](#solución-de-problemas)

---

## 📖 Introducción

La integración de GLPI con OCS Inventory permite:

✅ **Importar automáticamente** equipos inventariados en OCS  
✅ **Sincronizar información** de hardware y software  
✅ **Evitar duplicados** de equipos en GLPI  
✅ **Actualizar datos** automáticamente cuando cambia OCS  
✅ **Centralizar gestión** de inventario  

### Flujo de Datos

```
OCS Inventory          GLPI
(Inventario de      (Gestión de
 máquinas)          Servicios IT)
     │                  │
     └──────────────────┤
    Sincronización      │
    de equipos          │
```

---

## ✅ Requisitos Previos

Antes de configurar la integración:

1. ✅ GLPI debe estar corriendo en `http://localhost:8080`
2. ✅ OCS Inventory debe estar corriendo en `http://localhost:8081`
3. ✅ Tener acceso de administrador en ambas aplicaciones
4. ✅ Tener al menos un equipo inventariado en OCS
5. ✅ Contar con la extensión PHP `soap` instalada (incluida en la imagen Docker)

---

## 🔌 Instalar Plugin OCS Inventory

### Paso 1: Descargar el Plugin

1. Ve a la sección de plugins:
   - Sitio oficial: [Plugins GLPI](https://plugins.glpi-project.org/)
   - Busca "OCS Inventory" u "Ocsinventory"

2. Descarga el archivo ZIP más reciente compatible con tu versión de GLPI

### Paso 2: Instalar en GLPI

1. Desde GLPI, ve a **Configuración → Plugins**
2. Haz clic en **Instalar un plugin**
3. En la sección **Desde un archivo**:
   - Selecciona el archivo ZIP descargado
   - Haz clic en **Subir**

4. El plugin aparecerá en la lista
5. En la fila del plugin, haz clic en **Instalar**

### Paso 3: Activar el Plugin

1. En la lista de plugins
2. Haz clic en **Activar** en la fila de OCS Inventory
3. Verás un mensaje de confirmación

---

## ⚙️ Configurar Conexión a OCS

### Paso 1: Acceder a Configuración del Plugin

1. Ve a **Plugins**
2. Busca "OCS Inventory" en la lista
3. Haz clic en el nombre del plugin o en **Configurar**

### Paso 2: Configurar Parámetros de Conexión

En la pantalla de configuración:

#### Sección: Server

- **OCS Server URL**: `http://localhost:8081`
- **OCS Server Port**: `80`
- **OCS Server Path**: `/ocsinventory` (por defecto)

#### Sección: Authentication

- **OCS Username**: `admin`
- **OCS Password**: Tu contraseña de OCS
- **OCS Tag/Account**: `default` (si usas tags en OCS)

#### Sección: Connection Options

- **Enable SSL**: No (a menos que uses HTTPS)
- **Verify SSL Certificate**: No
- **Connection Timeout**: 30 segundos
- **Read Timeout**: 60 segundos

### Paso 3: Probar Conexión

1. Busca el botón **Test Connection** o similar
2. Haz clic para verificar que GLPI puede conectarse a OCS
3. Verás un mensaje:
   - ✅ **Connection successful**: La integración está lista
   - ❌ **Connection failed**: Revisa los parámetros

---

## 🔄 Sincronizar Equipos

### Paso 1: Importar Equipos de OCS

#### Opción A: Importación Manual

1. Ve a **Plugins → OCS Inventory**
2. Haz clic en **Import computers** o **Importar equipos**
3. Verás una lista de equipos en OCS que pueden importarse
4. Selecciona los equipos deseados:
   - Seleccionar todo: Marca la casilla superior
   - Seleccionar específicos: Marca cada equipo

5. Haz clic en **Import** o **Importar**
6. GLPI importará los equipos creando activos de tipo "Ordenador"

#### Opción B: Importación Automática (CRON)

1. Ve a **Plugins → OCS Inventory → Configuration**
2. En la sección **Automatic Import**:
   - **Enable Automatic Import**: Activa
   - **Import Frequency**: Define con qué frecuencia sincronizar
     - Hourly (Cada hora)
     - Daily (Diario)
     - Weekly (Semanal)
     - Monthly (Mensual)

3. Guarda

### Paso 2: Configurar Mapeo de Ubicación

1. Ve a **Plugins → OCS Inventory → Configuration**
2. En **Location Mapping**:
   - Mapea ubicaciones OCS a ubicaciones GLPI
   - Ejemplo:
     ```
     OCS: "Building A, Floor 2"  → GLPI: "Oficina Principal - Piso 2"
     OCS: "Data Center"           → GLPI: "Sala de Servidores"
     ```

3. Guarda la configuración

---

## 🗺️ Mapeo de Campos

### Configurar Sincronización de Datos

1. Ve a **Plugins → OCS Inventory → Field Mapping**
2. Define qué datos de OCS se sincronizan con GLPI:

#### Hardware Mapping:

| OCS Field | GLPI Field | Acción |
|-----------|-----------|--------|
| Computer Name | Computer Name | Sincronizar |
| Serial Number | Serial Number | Sincronizar |
| Manufacturer | Manufacturer | Sincronizar |
| Model | Model | Sincronizar |
| CPU | Processor | Sincronizar |
| RAM | RAM | Sincronizar |
| Storage | Hard Disk | Sincronizar |
| Network | Network Card | Sincronizar |

#### Software Mapping:

- **Software Name**: Nombre del software
- **Version**: Versión instalada
- **Publisher**: Editor/Desarrollador
- **Install Date**: Fecha de instalación

### Configurar Actualizaciones

1. En la configuración del plugin:
   - **Update on sync**: Activa para actualizar datos existentes
   - **Overwrite existing data**: Define si sobrescribir datos de GLPI
   - **Keep manual edits**: Preserva ediciones manuales en GLPI

---

## 🔄 Sincronización Automática

### Configurar CRON para Sincronización

GLPI debe tener configurado un CRON para ejecutar tareas automáticas.

#### En Servidor Linux/Docker

Desde terminal:

```bash
# Accede al contenedor GLPI
docker exec -it glpi_app bash

# Edita el crontab
crontab -e

# Añade esta línea para sincronizar cada hora:
0 * * * * php /var/www/html/scripts/cron.php 2>/dev/null

# O cada 30 minutos:
*/30 * * * * php /var/www/html/scripts/cron.php 2>/dev/null

# Guarda (Ctrl+X → Y → Enter)
```

#### Verificar Ejecución de CRON

```bash
# Ver logs de ejecución
docker exec glpi_app grep CRON /var/log/apache2/error.log

# O revisar directamente en GLPI:
# Configuración → Información del Sistema → Tareas programadas
```

### Monitorear Sincronización

1. Ve a **Configuración → Información del Sistema**
2. En la sección **Tareas Programadas**:
   - Verás el estado de sincronización
   - Hora de última ejecución
   - Próxima ejecución

---

## 📊 Verificar Datos Sincronizados

### Paso 1: Ver Equipos Importados

1. Ve a **Activos → Equipos**
2. Busca equipos que tengan:
   - Campo **OCS Link**: Enlace con OCS Inventory
   - Campo **Last OCS Sync**: Fecha de última sincronización

### Paso 2: Revisar Información Sincronizada

1. Selecciona un equipo sincronizado
2. En la pestaña **Componentes**:
   - CPU importada de OCS
   - RAM importada de OCS
   - Discos duros importados

3. En la pestaña **Software**:
   - Software instalado sincronizado desde OCS

### Paso 3: Vincular Equipos a Ubicaciones

Los equipos importados pueden no tener ubicación asignada:

1. Abre un equipo importado
2. En el campo **Ubicación**:
   - Selecciona la ubicación correspondiente
   - Guarda

O configura el mapeo automático en el plugin.

---

## 🛠️ Mantenimiento y Actualización

### Actualizar Datos Sincronizados

1. Ve a **Plugins → OCS Inventory**
2. Haz clic en **Resynchronize**
3. Selecciona equipos a actualizar:
   - Todo
   - Últimos 7 días
   - Últimos 30 días

4. Haz clic en **Resynchronize**

### Gestionar Duplicados

Si GLPI detecta duplicados:

1. Ve a **Herramientas → Fusionar elementos**
2. Selecciona los equipos duplicados
3. Haz clic en **Fusionar**
4. GLPI mantendrá los datos más completos

---

## 📋 Filtros y Búsquedas

### Buscar Equipos Sincronizados

1. Ve a **Activos → Equipos**
2. En la barra de búsqueda:
   - Busca equipos con campo "OCS"
   - Filtra por "OCS Link: No empty"

3. Verás solo los equipos sincronizados

### Crear Vista de Equipos OCS

1. Ve a **Activos → Equipos**
2. Haz clic en **Nueva búsqueda guardada**
3. Configura filtros:
   - **Campo**: OCS Link
   - **Operador**: No está vacío
   - **Valor**: (dejar vacío)

4. Nombre: "Equipos desde OCS"
5. Guarda

---

## 🆘 Solución de Problemas

### El plugin no se instala

**Problema**: Error al instalar el plugin OCS  
**Solución**:
1. Verifica que el archivo ZIP es compatible con tu versión de GLPI
2. Extrae el ZIP en `/var/www/html/plugins/ocsinventory/`
3. Ejecuta en GLPI: **Configuración → Plugins → Instalar**

### No se establece conexión con OCS

**Problema**: Error "Connection refused" o "Unable to connect"  
**Solución**:
```powershell
# Verifica que OCS está corriendo
docker ps | findstr ocs_server

# Prueba conectividad
Test-NetConnection -ComputerName localhost -Port 8081

# Si OCS no responde, reinicia
docker restart ocs_server

# Revisa logs
docker logs ocs_server
```

### Los equipos no se sincronizan

**Problema**: Los equipos OCS no aparecen en GLPI  
**Soluciones**:
1. Verifica que OCS tiene equipos inventariados:
   - Ve a OCS: **Inventory → Computers**
   - Si está vacío, instala y ejecuta un agente OCS

2. Verifica permisos del plugin:
   - **Administración → Roles → OCS Inventory**
   - Asigna permisos

3. Ejecuta sincronización manual:
   - **Plugins → OCS Inventory → Import**
   - Selecciona equipos
   - Haz clic en **Importar**

### Datos se duplican en sincronización

**Problema**: Aparecen equipos duplicados después de sincronizar  
**Solución**:
1. En el plugin, configura:
   - **Auto-merge duplicates**: Activa
   - **Merge criteria**: Serial Number

2. Ejecuta: **Herramientas → Fusionar elementos**
3. Mantén solo el registro más completo

### El CRON no ejecuta sincronización

**Problema**: La sincronización automática no funciona  
**Soluciones**:
```bash
# Verifica si CRON está configurado
crontab -l

# Ejecuta manualmente el CRON de GLPI
docker exec glpi_app php /var/www/html/scripts/cron.php

# Verifica si hay errores
docker exec glpi_app tail -f /var/log/apache2/error.log
```

---

## 📈 Mejores Prácticas

### 1. Sincronización Incrementental

Sincroniza solo equipos nuevos o modificados:
- Define frecuencia: Cada hora es suficiente
- Evita sobrecargar la red
- Reduce carga en la BD

### 2. Mapeo de Datos

Configura correctamente el mapeo para evitar:
- Datos incompletos
- Campos vacíos en GLPI
- Información duplicada

### 3. Mantenimiento Regular

```powershell
# Cada semana
# - Revisar equipos duplicados
# - Verificar sincronización correcta
# - Eliminar equipos inactivos en OCS

# Cada mes
# - Hacer backup de GLPI
# - Hacer backup de OCS
# - Revisar logs de sincronización
```

### 4. Seguridad

- ✅ Cambiar contraseña de OCS en el plugin
- ✅ Usar HTTPS si es posible
- ✅ Limitar acceso a la sincronización
- ✅ Auditar cambios en inventario

---

## 📚 Recursos Útiles

- [Documentación del Plugin OCS en GLPI](https://plugins.glpi-project.org/)
- [Wiki de OCS Inventory](https://wiki.ocsinventory-ng.org/)
- [Foro GLPI en Español](https://glpi-project.org/es/)
- [Integración GLPI-OCS](https://community.glpi-project.org/)

---

**Última actualización**: Enero 2026  
**Versión**: 1.0
