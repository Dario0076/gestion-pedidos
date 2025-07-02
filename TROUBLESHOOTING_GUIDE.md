# 🔧 Guía de Solución de Problemas - Gestión de Pedidos

## ⚠️ Problema Reportado
**Error**: "Error en el estatus" pero Render dice "live"

## 🔍 Diagnóstico Paso a Paso

### 1. Verificar Estado del Backend
```powershell
# Test básico de conectividad
Invoke-WebRequest -Uri "https://backend-m4do.onrender.com/api/health" -Method GET

# Verificar endpoint raíz
Invoke-WebRequest -Uri "https://backend-m4do.onrender.com/api" -Method GET
```

**Resultado esperado**: Status 200 OK

### 2. Problemas Comunes y Soluciones

#### A. Cold Start de Render
**Síntoma**: Primera conexión tarda 30-60 segundos
**Solución**: 
- Aumentados timeouts a 30 segundos en el APK
- La app debe mostrar loading apropiado

#### B. Problemas de Red del Dispositivo
**Síntoma**: App no conecta pero API funciona en navegador
**Soluciones**:
- Verificar conexión Wi-Fi del dispositivo
- Probar con datos móviles
- Verificar que no haya firewall bloqueando la app

#### C. Problemas de DNS
**Síntoma**: No resuelve backend-m4do.onrender.com
**Soluciones**:
- Cambiar DNS del dispositivo a 8.8.8.8 (Google)
- Reiniciar router/conexión de red

### 3. Nueva Funcionalidad: Test de Conexión

El nuevo APK incluye una pantalla de test de conexión:

1. **Acceso**: Desde la pantalla de login → "Test de Conexión"
2. **Funcionalidad**: 
   - Prueba conexión a todos los endpoints
   - Mide tiempo de respuesta
   - Muestra errores detallados
   - Verifica conectividad general

### 4. Configuración Actual de Timeouts

**Anteriormente**: 10 segundos
**Nuevo**: 30 segundos

```dart
// lib/services/api_service.dart
connectTimeout: const Duration(seconds: 30),
receiveTimeout: const Duration(seconds: 30),

// lib/providers/connection_provider.dart  
connectTimeout: const Duration(seconds: 30),
receiveTimeout: const Duration(seconds: 30),
```

### 5. URLs que Prueba la App

La app prueba estas URLs en orden:
1. `https://backend-m4do.onrender.com/api/health` (Principal - Render)
2. `http://192.168.1.4:3000/api/health` (Backup local)
3. `http://172.23.208.1:3000/api/health` (WSL)
4. `http://10.0.2.2:3000/api/health` (Emulador)
5. `http://127.0.0.1:3000/api/health` (Localhost)
6. `http://localhost:3000/api/health` (Localhost alternativo)

### 6. Pasos para Debugging

#### Paso 1: Verificar API desde PC
```powershell
# Verificar que la API funciona
Invoke-WebRequest -Uri "https://backend-m4do.onrender.com/api/health" -Method GET
```

#### Paso 2: Instalar APK Actualizado
```bash
# Ubicación del nuevo APK
C:\Users\User\Downloads\GestionPedidos\frontend\build\app\outputs\flutter-apk\app-release.apk

# Instalar (con dispositivo conectado)
flutter install
```

#### Paso 3: Usar Test de Conexión en la App
1. Abrir la app
2. En pantalla de login, tocar "Test de Conexión"
3. Ejecutar pruebas
4. Revisar resultados detallados

#### Paso 4: Verificar Conectividad del Dispositivo
```bash
# Desde terminal Android (si tienes ADB)
adb shell ping google.com
adb shell ping backend-m4do.onrender.com
```

### 7. Mensajes de Error Típicos

#### "Network Error"
- **Causa**: Sin conexión a internet
- **Solución**: Verificar Wi-Fi/datos móviles

#### "Timeout"
- **Causa**: Render en cold start o red lenta
- **Solución**: Esperar y reintentar

#### "DNS Resolution Failed"
- **Causa**: Problema de DNS
- **Solución**: Cambiar DNS del dispositivo

#### "SSL Certificate Error"
- **Causa**: Problemas de certificado (raro)
- **Solución**: Verificar fecha/hora del dispositivo

### 8. Logs de Debugging

Para desarrollo, puedes ver los logs con:
```bash
flutter logs
```

### 9. Configuración de Red Recomendada

**DNS Primario**: 8.8.8.8 (Google)
**DNS Secundario**: 8.8.4.4 (Google)

### 10. Contacto de Soporte

Si persisten los problemas:
1. Ejecutar test de conexión desde la app
2. Copiar resultados completos
3. Verificar que https://backend-m4do.onrender.com/api/health funciona desde navegador
4. Reportar detalles específicos del error

## ✅ Estado Actual del Sistema

- **Backend**: ✅ Funcionando en Render
- **API**: ✅ Respondiendo correctamente
- **APK**: ⏳ Generando versión mejorada
- **Timeouts**: ✅ Aumentados a 30 segundos
- **Debug**: ✅ Pantalla de test agregada

**Próximos pasos**: Instalar APK actualizado y probar con la función de test de conexión.
