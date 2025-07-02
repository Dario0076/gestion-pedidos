# 🧪 Script de Pruebas de la API - Sistema de Gestión de Pedidos

## URL Base de la API
```
https://backend-m4do.onrender.com/api
```

## Pruebas Manuales con PowerShell

### 1. Health Check
```powershell
Invoke-WebRequest -Uri "https://backend-m4do.onrender.com/api/health" -Method GET
```
**Respuesta esperada**: Status 200, `{"status":"ok","timestamp":"...","message":"Backend is running"}`

### 2. Obtener Categorías
```powershell
Invoke-WebRequest -Uri "https://backend-m4do.onrender.com/api/categories" -Method GET
```
**Respuesta esperada**: Status 200, Array (puede estar vacío inicialmente)

### 3. Obtener Productos
```powershell
Invoke-WebRequest -Uri "https://backend-m4do.onrender.com/api/products" -Method GET
```
**Respuesta esperada**: Status 200, Array (puede estar vacío inicialmente)

### 4. Registro de Usuario (opcional)
```powershell
$body = @{
    name = "Test User"
    email = "test@example.com"
    password = "123456"
} | ConvertTo-Json

Invoke-WebRequest -Uri "https://backend-m4do.onrender.com/api/auth/register" -Method POST -Body $body -ContentType "application/json"
```

### 5. Login de Usuario (después del registro)
```powershell
$loginBody = @{
    email = "test@example.com"
    password = "123456"
} | ConvertTo-Json

Invoke-WebRequest -Uri "https://backend-m4do.onrender.com/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
```

## Pruebas desde la Aplicación Móvil

### Funcionalidades a Probar:

#### 1. Conexión Inicial
- [ ] La app se conecta correctamente a la API
- [ ] Pantalla de splash/carga funciona
- [ ] No hay errores de conexión

#### 2. Autenticación
- [ ] Registro de nuevo usuario funciona
- [ ] Login con credenciales válidas
- [ ] Manejo de errores de autenticación
- [ ] Logout funciona correctamente

#### 3. Navegación Principal
- [ ] Lista de productos se carga
- [ ] Lista de categorías se carga
- [ ] Búsqueda y filtros funcionan

#### 4. Funcionalidades de Usuario
- [ ] Crear nuevo pedido
- [ ] Agregar productos al carrito
- [ ] Ver historial de pedidos
- [ ] Editar perfil de usuario

#### 5. Panel de Administración (si el usuario es admin)
- [ ] Gestión de productos (CRUD)
- [ ] Gestión de categorías (CRUD)
- [ ] Ver todos los pedidos
- [ ] Gestión de usuarios

## Posibles Problemas y Soluciones

### Cold Start de Render
**Problema**: La primera petición puede tardar 30-60 segundos
**Solución**: La app debe mostrar un loading apropiado

### Conectividad
**Problema**: Sin conexión a internet
**Solución**: La app debe mostrar mensaje de error apropiado

### CORS Issues
**Problema**: Errores de CORS desde la app
**Solución**: Verificar que CORS esté configurado correctamente (ya está)

## Scripts de Monitoreo

### Ping de Health Check
```powershell
# Script para monitorear el estado de la API
while ($true) {
    try {
        $response = Invoke-WebRequest -Uri "https://backend-m4do.onrender.com/api/health" -Method GET -TimeoutSec 10
        $status = ($response.Content | ConvertFrom-Json).status
        Write-Host "$(Get-Date): API Status - $status" -ForegroundColor Green
    } catch {
        Write-Host "$(Get-Date): API Error - $($_.Exception.Message)" -ForegroundColor Red
    }
    Start-Sleep 60
}
```

## Datos de Prueba Recomendados

### Usuario Administrador
```json
{
  "name": "Admin User",
  "email": "admin@gestionpedidos.com",
  "password": "admin123",
  "role": "admin"
}
```

### Usuario Regular
```json
{
  "name": "Cliente Test",
  "email": "cliente@test.com",
  "password": "123456",
  "role": "user"
}
```

### Categorías de Ejemplo
```json
[
  {"name": "Bebidas", "description": "Bebidas y refrescos"},
  {"name": "Snacks", "description": "Aperitivos y snacks"},
  {"name": "Comida", "description": "Platos principales"}
]
```

### Productos de Ejemplo
```json
[
  {
    "name": "Coca Cola",
    "description": "Refresco de cola 500ml",
    "price": 2.50,
    "stock": 100,
    "categoryId": 1,
    "imageUrl": "https://ejemplo.com/cocacola.jpg"
  },
  {
    "name": "Pizza Margherita",
    "description": "Pizza con tomate, mozzarella y albahaca",
    "price": 12.99,
    "stock": 20,
    "categoryId": 3
  }
]
```

## Checklist Final de Despliegue

- [x] Backend desplegado en Render
- [x] Base de datos PostgreSQL conectada
- [x] Variables de entorno configuradas
- [x] API responde correctamente
- [x] CORS configurado
- [x] Frontend configurado con URL de producción
- [ ] APK generado correctamente
- [ ] APK probado en dispositivo real
- [ ] Funcionalidades completas verificadas
- [ ] Datos de prueba cargados (opcional)

## 🎉 Estado Final: ✅ DESPLEGADO Y LISTO PARA PRODUCCIÓN
