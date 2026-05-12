# PowerShell Windows Update Checker 🛠️

Este script de PowerShell automatiza la auditoría de actualizaciones de Windows. Prepara el entorno, verifica el estado del sistema y genera un reporte detallado (log) de las actualizaciones de seguridad pendientes.

## 🚀 Funcionalidades

* **Configuración Automática:** Crea la estructura de carpetas en `C:\PSWindowsUpdate` (Logs y Script) si no existen.
* **Gestión de Módulos:** Verifica, instala e importa el módulo `PSWindowsUpdate` de forma automática.
* **Auditoría de Parches:** Identifica y registra el último parche instalado en el sistema.
* **Filtro de Seguridad:** Busca actualizaciones disponibles filtrando específicamente por críticas, acumulativas y de seguridad.
* **Reportes Detallados:** Genera un archivo `.log` único por cada ejecución con marca de tiempo.

## 📂 Estructura del Proyecto

El script organiza los datos en la siguiente ruta local:
* `C:\PSWindowsUpdate\Logs`: Almacena los reportes históricos.
* `C:\PSWindowsUpdate\Script`: Espacio destinado para almacenar el código fuente.

## 📋 Requisitos

* **Permisos:** El script debe ejecutarse como **Administrador**.
* **Internet:** Se requiere conexión para la descarga inicial del módulo `PSWindowsUpdate` (solo la primera vez).
* **Sistemas:** Compatible con Windows 10, 11 y Windows Server.

## 💻 Instrucciones de Uso

1.  Copia el código del script en un archivo llamado `Analisis_kb.ps1`.
2.  Abre PowerShell como **Administrador**.
3.  Ejecuta el script:
    ```powershell
    .\Analisis_kb.ps1
    ```
4.  Revisa la consola para ver la ruta del archivo log generado.

## 📝 Ejemplo de Salida del Log

El archivo log incluirá secciones como:
* **Datos del Servidor:** Nombre del equipo y fecha de inicio.
* **Último Parche:** Detalle del HotFix más reciente instalado.
* **Updates Disponibles:** Tabla con KB, Tamaño y Título de actualizaciones pendientes.
* **Categorías:** Clasificación de los parches encontrados.

## 🛠️ Detalles Técnicos

El script utiliza el comando `Get-WindowsUpdate` para consultar el agente de Windows y filtra los resultados mediante expresiones regulares (`Security|Cumulative|Rollup`) para priorizar la seguridad del sistema.
