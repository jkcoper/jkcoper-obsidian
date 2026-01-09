---
type: guide
platform: windows
tags: [windows, setup, installation, cross-platform]
created: 2025-01-09
---
# Windows Setup Guide - Obsidian AI Integration
## 🪟 Instalación en Windows
### 1. Prerrequisitos
- **Windows 10/11** (64-bit)
- **Git for Windows** (Descargar desde git-scm.com)
- **Python 3.8+** (Descargar desde python.org)
- **Obsidian** (Descargar desde obsidian.md)
### 2. Instalación de Git
```powershell
# Descargar e instalar Git for Windows
# https://git-scm.com/download/win
# Verificar instalación (PowerShell/CMD)
git --version
3. Instalación de Python
# Descargar e instalar Python desde python.org
# Marcar "Add Python to PATH" durante instalación
# Verificar instalación (PowerShell)
python --version
pip --version
4. Instalación de Obsidian
1. Descargar desde https://obsidian.md/download
2. Ejecutar instalador
3. Abrir Obsidian
🔄 Configuración del Vault
1. Clonar Repositorio
# En PowerShell o CMD
cd C:\Users\%USERNAME%\
git clone https://github.com/jkcoper/jkcoper-obsidian.git obsidian-vault
cd obsidian-vault
2. Configurar Git Credentials
# Opción A: Configurar credential helper
git config --global credential.helper store
# Opción B: Usar token en cada push
git remote set-url origin https://jkcoper:TOKEN@github.com/jkcoper/jkcoper-obsidian.git
3. Abrir Vault en Obsidian
1. Abrir Obsidian
2. "Open folder as vault"
3. Seleccionar C:\Users\%USERNAME%\obsidian-vault
🤖 Configuración de Scripts
1. Adaptar Scripts para Windows
Los scripts ya están preparados para Windows. Solo ejecutar:
# En PowerShell
cd C:\Users\%USERNAME%\obsidian-vault
.\scripts\cross-platform-sync.sh
2. Crear Acceso Directo
1. Botón derecho en escritorio → Nuevo → Acceso directo
2. Ruta: powershell.exe -ExecutionPolicy Bypass -File "C:\Users\%USERNAME%\obsidian-vault\scripts\cross-platform-sync.sh"
3. Nombre: "Obsidian Sync"
🔧 Integración con OpenCode
1. Configurar OpenCode en Windows
OpenCode ya puede interactuar directamente con los archivos .md del vault.
2. Rutas Importantes
- Vault: C:\Users\%USERNAME%\obsidian-vault
- Scripts: C:\Users\%USERNAME%\obsidian-vault\scripts
- Config: C:\Users\%USERNAME%\obsidian-vault\.obsidian
3. Comandos Útiles
# Sincronizar vault
cd C:\Users\%USERNAME%\obsidian-vault
.\scripts\cross-platform-sync.sh
# Actualizar embeddings
python scripts\embeddings-system.py
# Ver estado de git
git status
📊 Verificación del Sistema
1. Probar Sincronización
cd C:\Users\%USERNAME%\obsidian-vault
.\scripts\cross-platform-sync.sh
2. Probar Embeddings
python scripts\embeddings-system.py
3. Verificar en Obsidian
- Abrir Obsidian
- Verificar que aparezcan las notas
- Probar crear nueva nota
- Ejecutar sync y verificar que sube a GitHub
🚨 Solución de Problemas
Git Issues
# Si git no está en PATH
# Reinstalar Git for Windows marcando "Add Git to PATH"
# Si hay problemas de permisos
# Ejecutar PowerShell como Administrador
Python Issues
# Si python no se reconoce
# Reinstalar Python marcando "Add Python to PATH"
# Si hay problemas de módulos
pip install --upgrade pip
Script Issues
# Si los scripts no ejecutan
# En PowerShell (como Admin):
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
🔄 Flujo de Trabajo Windows
1. Abrir Obsidian → Trabajar en notas
2. Guardar cambios → Obsidian guarda automáticamente
3. Ejecutar sync → .\scripts\cross-platform-sync.sh
4. Verificar en GitHub → Cambios reflejados
5. Switch a Linux → Pull cambios y continuar
📈 Métricas y Monitoreo
El script cross-platform genera reportes automáticos con:
- Total de archivos .md
- Tamaño del vault
- Estado de embeddings
- Última sincronización
---
#windows #setup #guide #cross-platform #installation
