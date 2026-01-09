#!/bin/bash
# Cross-Platform Obsidian Sync Script
# Funciona en Linux, macOS y Windows (WSL/Git Bash)
set -e
# Detectar sistema operativo
detect_os() {
    case "$(uname -s)" in
        Linux*)     OS="Linux";;
        Darwin*)    OS="macOS";;
        CYGWIN*)    OS="Windows/Cygwin";;
        MINGW*)     OS="Windows/MinGW";;
        MSYS*)      OS="Windows/MSYS";;
        *)         OS="Unknown";;
    esac
    echo "$OS"
}
# Configuración según OS
setup_paths() {
    case $OS in
        "Linux"|"macOS")
            VAULT_PATH="$HOME/obsidian-vault"
            SCRIPT_PATH="$VAULT_PATH/scripts"
            PYTHON_CMD="python3"
            ;;
        "Windows/Cygwin"|"Windows/MinGW"|"Windows/MSYS")
            VAULT_PATH="$USERPROFILE/obsidian-vault"
            SCRIPT_PATH="$VAULT_PATH/scripts"
            PYTHON_CMD="python"
            ;;
        *)
            echo "❌ Sistema operativo no soportado: $OS"
            exit 1
            ;;
    esac
}
# Colores según OS
setup_colors() {
    if command -v tput >/dev/null 2>&1; then
        RED=$(tput setaf 1)
        GREEN=$(tput setaf 2)
        YELLOW=$(tput setaf 3)
        BLUE=$(tput setaf 4)
        NC=$(tput sgr0)
    else
        RED='\033[0;31m'
        GREEN='\033[0;32m'
        YELLOW='\033[1;33m'
        BLUE='\033[0;34m'
        NC='\033[0m'
    fi
}
# Logging
log() {
    echo -e "${GREEN}[$(date '+%H:%M:%S')]${NC} $1"
}
error() {
    echo -e "${RED}[ERROR]${NC} $1"
}
warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}
# Verificar dependencias
check_dependencies() {
    info "Verificando dependencias en $OS..."
    
    # Verificar git
    if ! command -v git >/dev/null 2>&1; then
        error "Git no está instalado"
        return 1
    fi
    
    # Verificar Python
    if ! command -v $PYTHON_CMD >/dev/null 2>&1; then
        error "Python no está instalado"
        return 1
    fi
    
    # Verificar vault
    if [ ! -d "$VAULT_PATH" ]; then
        error "Vault no encontrado: $VAULT_PATH"
        return 1
    fi
    
    log "✅ Dependencias verificadas"
}
# Sincronizar Git
sync_git() {
    info "Iniciando sincronización Git..."
    
    cd "$VAULT_PATH"
    
    # Verificar cambios
    if [ -n "$(git status --porcelain)" ]; then
        log "📝 Cambios detectados"
        git add .
        
        COMMIT_MSG="Auto-sync from $OS: $(date '+%Y-%m-%d %H:%M:%S')"
        git commit -m "$COMMIT_MSG"
        
        # Push si hay remote
        if git remote get-url origin &>/dev/null; then
            git push origin main
            log "🚀 Cambios enviados al repositorio"
        else
            warning "⚠️ No hay remote configurado"
        fi
    else
        log "✅ No hay cambios pendientes"
    fi
}
# Actualizar embeddings
update_embeddings() {
    info "Actualizando sistema de embeddings..."
    
    if [ -f "$SCRIPT_PATH/embeddings-system.py" ]; then
        cd "$VAULT_PATH"
        $PYTHON_CMD "$SCRIPT_PATH/embeddings-system.py"
        log "✅ Embeddings actualizados"
    else
        warning "⚠️ Script de embeddings no encontrado"
    fi
}
# Generar reporte
generate_report() {
    info "Generando reporte del vault..."
    
    cd "$VAULT_PATH"
    
    TOTAL_FILES=$(find . -name "*.md" -not -path "./.git/*" -not -path "./.obsidian/*" | wc -l)
    TOTAL_SIZE=$(du -sh . 2>/dev/null | cut -f1 || echo "Unknown")
    
    echo ""
    log "📊 Reporte del Vault - $OS"
    log "📁 Archivos .md: $TOTAL_FILES"
    log "💾 Tamaño: $TOTAL_SIZE"
    log "🕐 Última sync: $(date)"
    log "🖥️  Sistema: $OS"
    
    if [ -f ".obsidian/search_index.json" ]; then
        log "🔍 Embeddings: Activo"
    else
        warning "⚠️ Embeddings: Inactivo"
    fi
}
# Función principal
main() {
    OS=$(detect_os)
    setup_paths
    setup_colors
    
    echo ""
    log "🚀 Iniciando Cross-Platform Obsidian Sync"
    log "🖥️  Sistema detectado: $OS"
    log "📁 Vault path: $VAULT_PATH"
    echo ""
    
    check_dependencies || exit 1
    sync_git
    update_embeddings
    generate_report
    
    echo ""
    log "✅ Sincronización completada exitosamente"
}
# Ejecutar función principal
main "$@"
