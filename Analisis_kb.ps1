# Desarrollado por: Cristian Omar Jiménez Sánchez
# Github: crisomarjs

### ==============================
### Crear carpetas si no existen
### ==============================

$BasePath   = "C:\PSWindowsUpdate"
$LogPath    = "$BasePath\Logs"
$ScriptPath = "$BasePath\Script"

if (!(Test-Path $BasePath)) {
    New-Item -Path $BasePath -ItemType Directory -Force | Out-Null
}

if (!(Test-Path $LogPath)) {
    New-Item -Path $LogPath -ItemType Directory -Force | Out-Null
}

if (!(Test-Path $ScriptPath)) {
    New-Item -Path $ScriptPath -ItemType Directory -Force | Out-Null
}

# Forzar la política de ejecución para la sesión actual antes de cargar módulos
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

### ==============================
### Instalar módulo si no existe
### ==============================

if (!(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module PSWindowsUpdate -Force -Confirm:$false -SkipPublisherCheck -AllowClobber
}

Import-Module PSWindowsUpdate -Force


$logFile = "$LogPath\WindowsUpdate_History.log"

"`n`n"                                      | Out-File $logFile -Append
"=========================================" | Out-File $logFile -Append
"INICIO DE EJECUCION: $(Get-Date)"          | Out-File $logFile -Append
"Servidor: $env:COMPUTERNAME"               | Out-File $logFile -Append
"=========================================" | Out-File $logFile -Append

### ==============================
### Obtener último parche instalado
### ==============================

""                                          | Out-File $logFile -Append
"ULTIMO PARCHE INSTALADO"                   | Out-File $logFile -Append
"-----------------------------------------" | Out-File $logFile -Append

$LastPatch = Get-HotFix |
Sort-Object InstalledOn -Descending |
Select-Object -First 1

$LastPatch |
Select-Object HotFixID, Description, InstalledOn |
Format-List |
Out-String |
Out-File $logFile -Append

### ==============================
### Buscar actualizaciones disponibles
### ==============================

""                                          | Out-File $logFile -Append
"ACTUALIZACIONES DISPONIBLES"               | Out-File $logFile -Append
"-----------------------------------------" | Out-File $logFile -Append

try {
    $AvailableUpdates = Get-WindowsUpdate
    $SecurityUpdates = $AvailableUpdates | Where-Object {
        $_.Title -match "Security|Cumulative|Rollup"
    }

    if ($SecurityUpdates) {
        $SecurityUpdates |
        Select-Object KB, Size, Title |
        Format-Table -Wrap -AutoSize |
        Out-String |
        Out-File $logFile -Append
    }
    else {
        "No hay actualizaciones de seguridad pendientes." |
        Out-File $logFile -Append
    }
}
catch {
    "ERROR AL CONSULTAR WINDOWS UPDATE"     | Out-File $logFile -Append
    $_.Exception.Message                    | Out-File $logFile -Append
}

### ==============================
### Mostrar categorías detectadas
### ==============================

""                                          | Out-File $logFile -Append
"CATEGORIAS DETECTADAS EN WINDOWS UPDATE"   | Out-File $logFile -Append
"-----------------------------------------" | Out-File $logFile -Append

try {
    $AvailableUpdates |
    Select-Object Title, Categories |
    Format-List |
    Out-String |
    Out-File $logFile -Append
}
catch {
    "No fue posible obtener categorías." |
    Out-File $logFile -Append
}

### ==============================
### Fin del script
### ==============================

""                                          | Out-File $logFile -Append
"Script finalizado: $(Get-Date)"            | Out-File $logFile -Append
"-----------------------------------------" | Out-File $logFile -Append

### ==============================
### Mostrar ruta del log
### ==============================

Write-Host ""
Write-Host "Historial actualizado en:"
Write-Host $logFile -ForegroundColor Green