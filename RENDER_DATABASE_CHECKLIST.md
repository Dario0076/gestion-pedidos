# 🔍 VERIFICACIÓN DE CONFIGURACIÓN EN RENDER

## 📋 Checklist de Configuración de Base de Datos

### 1. 🗄️ PostgreSQL Database Settings

**En el Dashboard de Render > PostgreSQL Database:**

#### A. Información General
- [ ] **Status**: Debe estar "Available" (verde)
- [ ] **Region**: Debe coincidir con el web service (Oregon)
- [ ] **Version**: PostgreSQL 13+ recomendado

#### B. Connection Details
- [ ] **Internal Database URL**: Verificar que coincida con la variable de entorno
- [ ] **External Database URL**: Debe estar habilitada para conexiones externas si es necesario

**URL esperada**:
```
postgresql://gestionpedidosdb_user:c6tI45Faxo8ft889S1I1WQ5efbhLXdYv@dpg-d1ibgr2li9vc73fp486g-a.oregon-postgres.render.com/gestionpedidosdb
```

#### C. Access Control / Network Settings
- [ ] **Allow connections from**: Debe incluir el web service
- [ ] **IP Whitelist**: Si existe, debe incluir las IPs del web service
- [ ] **SSL Mode**: Generalmente "require" o "prefer"

### 2. 🌐 Web Service Settings

**En el Dashboard de Render > Web Service:**

#### A. Environment Variables
- [ ] **DATABASE_URL**: Debe estar configurada
- [ ] **NODE_ENV**: production
- [ ] **Otras variables**: JWT_SECRET, PORT, etc.

**Para verificar**: 
```bash
# En Render Console del web service
echo $DATABASE_URL
```

#### B. Build & Deploy
- [ ] **Runtime**: Node.js
- [ ] **Build Command**: `npm install && npm run build`
- [ ] **Start Command**: `npm run deploy` o `npm start`
- [ ] **Root Directory**: Debe apuntar al backend

#### C. Health Checks
- [ ] **Health Check Path**: `/api/health` (opcional pero recomendado)
- [ ] **Port**: 3000 (o el configurado en el código)

### 3. 🔗 Connectivity Verification

#### A. Network Access
- [ ] **Same Region**: Web service y database en la misma región
- [ ] **Internal Network**: Render permite comunicación interna entre servicios
- [ ] **DNS Resolution**: El hostname de la DB debe resolver correctamente

#### B. Service Linking (si aplica)
- [ ] **Linked Services**: Verificar si hay opciones para vincular la DB al web service
- [ ] **Automatic Environment Variables**: Render puede configurar automáticamente DATABASE_URL

## 🧪 Comandos de Diagnóstico

### En Render Web Service Console:

```bash
# 1. Verificar variables de entorno
env | grep DATABASE

# 2. Probar conectividad básica
ping dpg-d1ibgr2li9vc73fp486g-a.oregon-postgres.render.com

# 3. Probar conexión a la base de datos
node -e "
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
prisma.\$queryRaw\`SELECT 1\`.then(console.log).catch(console.error);
"

# 4. Verificar que Prisma esté compilado
npx prisma generate

# 5. Probar el seed
npm run db:seed
```

### Desde el navegador:

```
# Nuevos endpoints de diagnóstico
https://backend-m4do.onrender.com/api/health
https://backend-m4do.onrender.com/api/db-status
```

## 🚨 Problemas Comunes y Soluciones

### Problema 1: "Connection Timeout"
**Causa**: La DB no acepta conexiones del web service
**Solución**: 
- Verificar que estén en la misma región
- Revisar configuración de red de la DB
- Reiniciar la base de datos

### Problema 2: "Authentication Failed"
**Causa**: Credenciales incorrectas en DATABASE_URL
**Solución**:
- Regenerar credenciales de la DB
- Actualizar DATABASE_URL en el web service
- Redeployar

### Problema 3: "Database Not Found"
**Causa**: Nombre de base de datos incorrecto
**Solución**:
- Verificar el nombre en la URL de conexión
- Debe ser: `gestionpedidosdb`

### Problema 4: "SSL Connection Required"
**Causa**: La DB requiere SSL pero la aplicación no lo usa
**Solución**:
- Agregar `?sslmode=require` al final de DATABASE_URL
- O configurar SSL en Prisma

## 🔧 Acciones Inmediatas Recomendadas

### 1. Verificar Status de Servicios
- [ ] Database status: Available/Running
- [ ] Web service status: Live/Deployed
- [ ] Última deploment exitoso

### 2. Revisar Logs
- [ ] **Database logs**: Buscar errores de conexión
- [ ] **Web service logs**: Buscar errores de Prisma/DB
- [ ] **Deploy logs**: Verificar que el build fue exitoso

### 3. Probar Conectividad
- [ ] **Desde Console**: Ejecutar comandos de diagnóstico
- [ ] **Desde API**: Probar `/api/db-status`
- [ ] **Desde App**: Usar el botón de crear usuario

## 📞 Si Todo Falla

### Último Recurso:
1. **Suspender y reactivar la base de datos**
2. **Redeployar el web service**
3. **Recrear la conexión DATABASE_URL**
4. **Contactar soporte de Render** si persiste

---

**🎯 Objetivo**: Confirmar que el web service puede conectarse a la base de datos PostgreSQL y que los usuarios de prueba existen.

*Una vez confirmado, el login en la app móvil debería funcionar perfectamente.*
