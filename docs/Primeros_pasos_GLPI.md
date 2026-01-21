# 🚀 Primeros Pasos para GLPI

Este documento te guía a través de la configuración inicial de GLPI después de levantarlo con Docker Compose.

## 📋 Índice

1. [Acceso Inicial](#acceso-inicial)
2. [Primera Conexión](#primera-conexión)
3. [Configuración del Sistema](#configuración-del-sistema)
4. [Gestión de Usuarios](#gestión-de-usuarios)
5. [Configuración de la Base de Datos](#configuración-de-la-base-de-datos)
6. [Configuración de Entidades](#configuración-de-entidades)
7. [Plugins Recomendados](#plugins-recomendados)
8. [Configuración de Seguridad](#configuración-de-seguridad)

---

## 🌐 Acceso Inicial

### Conexión a GLPI

Una vez que los contenedores estén funcionando, accede a GLPI en:

```
URL: http://localhost:8080
```

### Credenciales por Defecto

| Usuario | Contraseña | Rol |
|---------|-----------|-----|
| **glpi** | **glpi** | Administrador |
| **post-only** | **postonly** | Solo reportes |
| **tech** | **tech** | Técnico |

## 🔐 Primera Conexión

### Paso 1: Iniciar Sesión

1. Abre `http://localhost:8080` en tu navegador
2. Ingresa con el usuario `glpi` y contraseña `glpi`
3. Haz clic en **Conectarse**

![Pantalla de Login](./screenshots/glpi-login.png)

### Paso 2: Panel de Control

Después de iniciar sesión, verás el panel de control principal con:
- **Resumen de tickets**
- **Eventos recientes**
- **Inventario de activos**
- **Mis preferencias**

---

## ⚙️ Configuración del Sistema

### 1. Cambiar Idioma y Preferencias

1. Haz clic en tu usuario en la esquina superior derecha
2. Selecciona **Mi Perfil**
3. En la pestaña **Preferencias**:
   - **Idioma**: Selecciona **Español**
   - **Tema**: Elige tu preferencia (claro/oscuro)
   - **Moneda**: EUR o USD según tu región
   - **Zona horaria**: Europe/Madrid (o tu zona)

4. Haz clic en **Guardar**

### 2. Configuración General del Sistema

1. Ve a **Configuración → Configuración General**
2. En la pestaña **Sistema**:
   - **Nombre de la aplicación**: "Mi Empresa - Gestión IT"
   - **URL de base**: `http://localhost:8080`
   - **Correo administrativo**: `admin@miempresa.com`

3. En la pestaña **Validación**:
   - **Validación de compras**: Activa si es necesario
   - **Validación de cambios**: Activa para mayor control

4. Haz clic en **Guardar**

---

## 👥 Gestión de Usuarios

### 1. Crear Nuevos Usuarios

1. Ve a **Administración → Usuarios**
2. Haz clic en **+** (Agregar usuario)
3. Rellena los datos:
   - **Nombre de usuario**: usuario_unico
   - **Apellido**: Apellido
   - **Nombre**: Nombre
   - **Correo electrónico**: usuario@miempresa.com
   - **Contraseña**: Una contraseña segura

4. En la pestaña **Permisos**:
   - Asigna perfiles (Técnico, Usuario, etc.)
   - Selecciona entidades (si tienes múltiples)

5. Haz clic en **Agregar**

### 2. Definir Perfiles de Usuario

1. Ve a **Administración → Perfiles**
2. Revisa los perfiles disponibles:
   - **Administrador**: Acceso total
   - **Supervisor**: Gestión de tickets y equipos
   - **Técnico**: Soporte técnico
   - **Usuario**: Solo ver y crear tickets

3. Para crear un nuevo perfil:
   - Haz clic en **+**
   - Configura los permisos deseados
   - Guarda los cambios

### 3. Configurar Grupos

1. Ve a **Administración → Grupos**
2. Haz clic en **+** para crear un grupo
3. Nombre: "Soporte Técnico"
4. Añade usuarios haciendo clic en **Usuarios**
5. Selecciona los usuarios a incluir
6. Guarda

---

## 🗄️ Configuración de la Base de Datos

### 1. Verificar Conexión a BD

1. Ve a **Configuración → Información del Sistema**
2. En la sección **Base de datos**, verifica:
   - **Servidor**: db_glpi
   - **Usuario**: glpi
   - **Base de datos**: glpidb

### 2. Hacer Backup de la Base de Datos

Desde PowerShell (en el directorio raíz del proyecto):

```powershell
# Hacer backup de la BD de GLPI
docker exec glpi_db mysqldump -u glpi -pglpipass glpidb > backup_glpi.sql

# Hacer backup de la BD de OCS
docker exec ocs_db mysqldump -u ocs -pocspass ocsdb > backup_ocs.sql
```

### 3. Restaurar Backup

```powershell
# Restaurar GLPI
docker exec -i glpi_db mysql -u glpi -pglpipass glpidb < backup_glpi.sql

# Restaurar OCS
docker exec -i ocs_db mysql -u ocs -pocspass ocsdb < backup_ocs.sql
```

---

## 🏢 Configuración de Entidades

Las entidades en GLPI representan divisiones de tu organización (sedes, departamentos, etc.).

### 1. Crear Entidades

1. Ve a **Administración → Entidades**
2. Haz clic en **+** para crear una nueva entidad
3. Rellena:
   - **Nombre**: Sede Principal
   - **Código**: SP
   - **Teléfono**: +34 XXX XXX XXX
   - **Correo**: contacto@miempresa.com
   - **Director**: Selecciona responsable
   - **Ubicación**: Tu dirección

4. En la pestaña **Información financiera**:
   - Número de IBAN
   - Número de impuesto

5. Guarda

### 2. Asignar Usuarios a Entidades

1. Ve a **Administración → Usuarios**
2. Selecciona un usuario
3. En **Derechos**, agrega las entidades a las que tiene acceso
4. Guarda

---

## 🔌 Plugins Recomendados

GLPI permite extender funcionalidad con plugins.

### 1. Instalar Plugins

1. Ve a **Configuración → Plugins**
2. Haz clic en **Instalar un plugin**
3. Descarga plugins desde [GLPIProject](https://plugins.glpi-project.org/)
4. Sube el archivo ZIP
5. Activa el plugin

### Plugins Recomendados:

- **PDF** - Exportar a PDF
- **Dashboard** - Dashboards personalizados
- **Ocsinventory** - Integración con OCS Inventory
- **Shellcommands** - Ejecutar comandos
- **Datainjection** - Importar datos

---

## 🔒 Configuración de Seguridad

### 1. Cambiar Contraseña del Administrador

1. Haz clic en tu usuario (esquina superior derecha)
2. Selecciona **Mi Perfil**
3. Ve a la pestaña **Contraseña**
4. Ingresa una **nueva contraseña segura**
5. Guarda

### 2. Configurar Seguridad del Sistema

1. Ve a **Configuración → Seguridad**
2. En la pestaña **Información del sistema**:
   - **Contraseña SQL**: Cambia si es necesario
   - **Token de API**: Genera tokens para integraciones

3. En **Acceso**:
   - **Permitir login sin usuario**: Desactiva
   - **Usar LDAP**: Configura si tienes servidor LDAP
   - **Usar correo**: Integra autenticación por correo

### 3. Configurar Sesiones

1. Ve a **Configuración → Sesiones**
2. Define:
   - **Tiempo de inactividad**: 30 minutos
   - **Duración máxima**: 12 horas
   - **Recordar sesión**: Según política de seguridad

---

## 🖥️ Configuración de Inventario

### 1. Crear Categorías de Equipos

1. Ve a **Activos → Equipos**
2. En el panel izquierdo, ve a **Tipos**
3. Crea categorías:
   - Ordenadores
   - Impresoras
   - Servidores
   - Otros dispositivos

### 2. Añadir Ubicaciones

1. Ve a **Administración → Ubicaciones**
2. Haz clic en **+**
3. Crea ubicaciones:
   - Sala de Servidores
   - Despacho 101
   - Almacén
   - etc.

### 3. Crear un Equipo de Ejemplo

1. Ve a **Activos → Equipos**
2. Haz clic en **+**
3. Rellena:
   - **Nombre**: PC-ADMIN-01
   - **Tipo**: Ordenador
   - **Entidad**: Tu entidad
   - **Ubicación**: Despacho 101
   - **Modelo**: DELL OptiPlex 7080
   - **Número de serie**: XXXXX
   - **Responsable técnico**: Selecciona usuario
   - **Usuario**: Asigna usuario

4. En la pestaña **Componentes**:
   - Agrega CPU, RAM, Disco Duro
   - Especifica modelos y cantidades

5. Guarda

---

## 🎫 Configuración de Tickets

### 1. Crear Categorías de Tickets

1. Ve a **Administración → Categorías de tickets**
2. Crea categorías:
   - Hardware
   - Software
   - Red
   - Soporte General

### 2. Configurar Urgencias y Estados

1. Ve a **Administración → Urgencias**
   - Crítica (Rojo)
   - Alta (Naranja)
   - Media (Amarillo)
   - Baja (Verde)

2. Ve a **Administración → Estados**
   - Nuevo
   - En proceso
   - En espera
   - Resuelto
   - Cerrado

### 3. Crear un Ticket de Prueba

1. Ve a **Centro de servicios → Tickets**
2. Haz clic en **Crear un ticket**
3. Rellena:
   - **Título**: "Problema con impresora"
   - **Descripción**: Detalle del problema
   - **Categoría**: Hardware
   - **Urgencia**: Media
   - **Impacto**: Departamento/Usuario

4. Haz clic en **Crear**

---

## 📞 Pasos Siguientes

Después de la configuración inicial, considera:

✅ **Integración con OCS Inventory** para sincronizar equipos automáticamente  
✅ **Configurar notificaciones por correo** para alertas de tickets  
✅ **Crear plantillas de tickets** para problemas comunes  
✅ **Configurar contratos** para equipos en garantía  
✅ **Hacer backup regular** de la base de datos  
✅ **Configurar informes** para seguimiento de KPIs  

---

## 🆘 Solución de Problemas

### No puedo acceder a GLPI

**Problema**: Error de conexión a localhost:8080  
**Solución**:
```powershell
# Verifica que los contenedores estén corriendo
docker ps | findstr glpi

# Si no están, inicia docker-compose
cd docker
docker compose -f docker-compose.glpi.yml up -d
```

### Olvide la contraseña

**Solución**: Accede a la base de datos y resetea:
```powershell
docker exec glpi_db mysql -u glpi -pglpipass glpidb

# En la consola de MySQL:
UPDATE glpi_users SET password = '5f4dcc3b5aa765d61d8327deb882cf99' WHERE name = 'glpi';
# Esta es la contraseña MD5 de "glpi"
```

### GLPI muy lento

**Solución**:
1. Verifica espacio en disco: `docker system df`
2. Optimiza la BD: `docker exec glpi_db mysqlcheck -u glpi -pglpipass --optimize glpidb`
3. Aumenta memoria del contenedor en docker-compose.yml

---

## 📚 Recursos Útiles

- [Documentación oficial de GLPI](https://glpi-project.org/es/)
- [Foro de GLPI en español](https://glpi-project.org/es/ayuda/)
- [Plugins disponibles](https://plugins.glpi-project.org/)
- [Repositorio GitHub](https://github.com/glpi-project/glpi)

---

**Última actualización**: Enero 2026  
**Versión**: 1.0
