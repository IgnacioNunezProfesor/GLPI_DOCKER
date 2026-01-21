# 🚀 Primeros Pasos para OCS Inventory

Este documento te guía a través de la configuración inicial de OCS Inventory después de levantarlo con Docker Compose.

## 📋 Índice

1. [Acceso Inicial](#acceso-inicial)
2. [Primera Conexión](#primera-conexión)
3. [Configuración del Servidor](#configuración-del-servidor)
4. [Gestión de Usuarios](#gestión-de-usuarios)
5. [Configuración de Agentes](#configuración-de-agentes)
6. [Inventario de Máquinas](#inventario-de-máquinas)
7. [Reportes](#reportes)
8. [Configuración de Seguridad](#configuración-de-seguridad)

---

## 🌐 Acceso Inicial

### Conexión a OCS Inventory

Una vez que los contenedores estén funcionando, accede a OCS Inventory en:

```
URL: http://localhost:8081
```

### Credenciales por Defecto

| Usuario | Contraseña | Rol |
|---------|-----------|-----|
| **admin** | **admin** | Administrador |

> **Importante**: Cambia estas credenciales inmediatamente después de la primera conexión.

---

## 🔐 Primera Conexión

### Paso 1: Iniciar Sesión

1. Abre `http://localhost:8081` en tu navegador
2. Ingresa con el usuario `admin` y contraseña `admin`
3. Haz clic en **Login** o **Conectarse**

### Paso 2: Panel de Control

Después de iniciar sesión, verás:
- **Resumen de máquinas inventariadas**
- **Equipos sin inventariar**
- **Actualizaciones disponibles**
- **Estadísticas de hardware**

---

## ⚙️ Configuración del Servidor

### 1. Cambiar Contraseña del Administrador

1. Haz clic en tu usuario en la esquina superior derecha
2. Selecciona **Preferences** o **Preferencias**
3. En el campo **Contraseña**:
   - Ingresa una contraseña nueva
   - Repítela para confirmar
4. Haz clic en **Save** o **Guardar**

### 2. Configuración General

1. Ve a **Configuration** → **General**
2. Configura:
   - **FQDN del servidor**: `localhost:8081` o tu dominio real
   - **Nombre de la organización**: "Mi Empresa"
   - **Correo de contacto**: `admin@miempresa.com`
   - **Lenguaje por defecto**: Spanish (Español)

3. En **Logging**:
   - **Nivel de log**: INFO (para producción)
   - **Directorio de logs**: `/var/lib/ocsinventory-reports/logs`

4. Guarda los cambios

### 3. Configuración de Base de Datos

1. Ve a **Configuration** → **Database**
2. Verifica la conexión:
   - **Servidor**: ocs_db
   - **Usuario**: ocs
   - **Base de datos**: ocsdb
   - **Puerto**: 3306

3. Haz clic en **Test Connection** para verificar
4. Si es necesario, ajusta los parámetros de conexión

### 4. Configuración de Servidor

1. Ve a **Configuration** → **Server**
2. Configura:
   - **Puerto de escucha**: 80 (por defecto en Docker)
   - **Timeout de comunicación**: 300 segundos
   - **Máximo de intentos**: 3
   - **Intervalo de reintentos**: 30 segundos

3. En **Seguridad**:
   - Habilita **SSL/TLS** si tienes certificado
   - Configura token de comunicación (opcional)

---

## 👥 Gestión de Usuarios

### 1. Crear Nuevos Usuarios

1. Ve a **Configuration** → **Users Management**
2. Haz clic en **Add a new user**
3. Rellena:
   - **Username**: usuario_unico
   - **Password**: Contraseña segura
   - **First Name**: Nombre
   - **Last Name**: Apellido
   - **Email**: usuario@miempresa.com

4. En la sección **Permissions**:
   - **Admin**: Si tiene acceso administrativo
   - **Read Only**: Si solo puede ver reportes
   - **Group Manager**: Si gestiona grupos

5. Haz clic en **Add**

### 2. Crear Grupos de Máquinas

1. Ve a **Configuration** → **Groups**
2. Haz clic en **Create a new group**
3. Nombre del grupo:
   - "Departamento IT"
   - "Oficinas"
   - "Servidores"
   - etc.

4. Descripción (opcional)
5. Asigna máquinas al grupo
6. Guarda

### 3. Gestionar Permisos por Grupo

1. Ve a **Configuration** → **Groups**
2. Selecciona un grupo
3. En **User Visibility**:
   - Define qué usuarios pueden ver este grupo
   - Define qué usuarios pueden modificar

---

## 🖥️ Configuración de Agentes

Los agentes son los clientes OCS que recopilan información de los equipos.

### 1. Descargar Agente OCS

1. Ve a **Deployment** → **Agents Download**
2. Descarga el agente según tu SO:
   - **Windows**: `OCS-Windows-Agent-*.exe`
   - **Linux**: `Ocsinventory-Agent_*.tar.gz`
   - **Mac**: `ocsinventory-agent-*.dmg`

### 2. Configurar Agente en Windows

#### Instalación:

1. Descarga `OCS-Windows-Agent-2.x.exe`
2. Ejecuta el instalador
3. En **Server Details**:
   - **Server address**: `localhost:8081` (o tu servidor)
   - **Port**: `80`
   - **Proxy**: Deja en blanco si no usas proxy

4. En **Agent Configuration**:
   - **Computer Name**: Nombre único del equipo
   - **Local Users**: Detectar usuarios locales (opcional)
   - **Software**: Inventariar software (recomendado)

5. Completa la instalación

#### Forzar Inventario Inicial:

```powershell
# Abre CMD como administrador
cd "C:\Program Files (x86)\OCS Inventory Agent"

# Ejecuta el agente
OCSInventory.exe /server:localhost:8081 /ssl:0 /local
```

### 3. Configurar Agente en Linux

#### Instalación en Ubuntu/Debian:

```bash
# Descarga e instala
tar xzf Ocsinventory-Agent_*.tar.gz
cd Ocsinventory-Agent_*
sudo ./setup.sh

# Configura el servidor
sudo nano /etc/ocsinventory/ocsinventory-agent.cfg

# Busca y edita:
# server = localhost:8081
# ssl = 0
```

#### Ejecutar inventario:

```bash
sudo /usr/bin/ocsinventory-agent
```

---

## 🔍 Inventario de Máquinas

### 1. Ver Máquinas Inventariadas

1. Ve a **Inventory** → **Computers**
2. Verás una lista de todas las máquinas que han reportado

### 2. Detalles de una Máquina

1. Haz clic en una máquina
2. Verás información detallada:
   - **Hardware**: Componentes detectados
   - **Software**: Software instalado
   - **Network**: Información de red
   - **Monitors**: Pantallas conectadas
   - **Printers**: Impresoras detectadas
   - **Modems**: Módems instalados
   - **Storage**: Discos duros y particiones

### 3. Agrupar Máquinas

1. En la lista de máquinas, selecciona varios equipos
2. Haz clic en **Add selected items to group**
3. Selecciona el grupo destino
4. Confirma

### 4. Eliminar Máquinas del Inventario

1. Selecciona la máquina
2. Haz clic en **Delete**
3. Confirma la eliminación

> **Nota**: La máquina reaparecerá si vuelve a reportar su inventario

---

## 📊 Reportes

### 1. Reportes Disponibles

1. Ve a **Reports**
2. Explora reportes por categoría:
   - **Hardware Reports**: Análisis de hardware
   - **Software Reports**: Licencias, software instalado
   - **Network Reports**: Información de red
   - **System Reports**: Información de sistema

### 2. Generar Reporte Personalizado

1. Ve a **Reports** → **Custom Report**
2. Selecciona:
   - **Type**: Tipo de datos (Hardware, Software, etc.)
   - **Format**: PDF, CSV, HTML
   - **Filter**: Filtros para las máquinas

3. Haz clic en **Generate**
4. Descarga el reporte

### 3. Exportar Datos

1. En cualquier lista (máquinas, software, etc.)
2. Busca el botón **Export** o **Descargar**
3. Selecciona formato:
   - CSV: Para Excel
   - PDF: Para visualización
   - XML: Para integración

---

## 🔒 Configuración de Seguridad

### 1. Cambiar Contraseña de Administrador

1. Haz clic en tu usuario
2. Selecciona **Preferences**
3. En el campo **Change Password**:
   - **Current Password**: Tu contraseña actual
   - **New Password**: Nueva contraseña
   - **Confirm Password**: Repetir

4. Guarda

### 2. Gestionar Tokens de API

1. Ve a **Configuration** → **Security**
2. En la sección **API Tokens**:
   - Genera nuevos tokens
   - Revoca tokens antiguos
   - Define permisos por token

### 3. Configurar Autenticación LDAP

1. Ve a **Configuration** → **Authentication**
2. Selecciona **LDAP**
3. Configura:
   - **LDAP Server**: tu.servidor.ldap.com
   - **Port**: 389 (o 636 para LDAPS)
   - **Base DN**: dc=miempresa,dc=com
   - **Admin DN**: cn=admin,dc=miempresa,dc=com

4. Prueba la conexión
5. Guarda

### 4. Configurar SSL/TLS

1. Ve a **Configuration** → **Server**
2. En **SSL Configuration**:
   - **Enable SSL**: Activa
   - **Certificate Path**: `/path/to/certificate.crt`
   - **Key Path**: `/path/to/key.key`

3. Reinicia el servicio

---

## 📈 Mantenimiento

### 1. Limpiar Máquinas Inactivas

Máquinas que no han reportado en X días:

1. Ve a **Configuration** → **Maintenance**
2. En **Inactive Computers**:
   - Establece días de inactividad: 180 (6 meses)
   - Haz clic en **Clean**

3. Confirma para eliminar

### 2. Optimizar Base de Datos

Desde terminal/PowerShell:

```powershell
# Optimizar tablas
docker exec ocs_db mysqlcheck -u ocs -pocspass --optimize ocsdb

# Ver espacio usado
docker exec ocs_db mysql -u ocs -pocspass -e "SELECT table_name, ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size in MB' FROM information_schema.tables WHERE table_schema = 'ocsdb';"
```

### 3. Hacer Backup

```powershell
# Backup completo
docker exec ocs_db mysqldump -u ocs -pocspass ocsdb > backup_ocs_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql

# Backup solo estructura
docker exec ocs_db mysqldump -u ocs -pocspass --no-data ocsdb > backup_ocs_estructura.sql
```

---

## 🆘 Solución de Problemas

### Agente no se conecta

**Síntoma**: La máquina no aparece en OCS Inventory

**Soluciones**:
1. Verifica conectividad al servidor:
   ```powershell
   Test-NetConnection -ComputerName localhost -Port 8081
   ```

2. Comprueba logs del agente:
   - **Windows**: `C:\Program Files (x86)\OCS Inventory Agent\logs`
   - **Linux**: `/var/log/ocsinventory/`

3. Reinicia el agente:
   ```powershell
   # Windows
   net stop "OCS Inventory Agent"
   net start "OCS Inventory Agent"
   ```

### Base de datos no responde

**Síntoma**: Error de conexión a BD

**Solución**:
```powershell
# Verifica que el contenedor de BD está corriendo
docker ps | findstr ocs_db

# Si no está, reinicia
docker restart ocs_db

# Verifica logs
docker logs ocs_db
```

### Servidor lento

**Síntoma**: OCS Inventory responde lentamente

**Soluciones**:
1. Limpia máquinas inactivas (ver Mantenimiento)
2. Optimiza la base de datos
3. Aumenta recursos del contenedor en docker-compose.yml:
   ```yaml
   ocs:
     mem_limit: 1g
   ```

### No puedo acceder después de cambiar contraseña

**Solución**: Resetea en la BD:
```powershell
docker exec ocs_db mysql -u ocs -pocspass ocsdb

# En la consola MySQL:
UPDATE users SET password = MD5('admin') WHERE login = 'admin';
EXIT;
```

---

## 📚 Recursos Útiles

- [Documentación oficial de OCS Inventory](https://wiki.ocsinventory-ng.org/)
- [Foro de OCS Inventory](https://community.ocsinventory-ng.org/)
- [Descargas de Agentes](https://ocsinventory-ng.org/en/download/)
- [Configuración de Agentes](https://wiki.ocsinventory-ng.org/index.php?title=Agents)

---

**Última actualización**: Enero 2026  
**Versión**: 1.0
