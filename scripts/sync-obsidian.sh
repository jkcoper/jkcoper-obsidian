#!/bin/bash
# Obsidian Git Sync Script
# Sistema de sincronización semi-automatizado para vault de Obsidian
set -e
VAULT_PATH="$HOME/obsidian-vault"
LOG_FILE="$VAULT_PATH/.obsidian/sync.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
# Función de logging
log() {
    echo -e "${GREEN}[$TIMESTAMP]${NC} $1" | tee -a "$LOG_FILE"
}
error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}
warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}
# Verificar si estamos en el directorio correcto
if [ ! -d "$VAULT_PATH" ]; then
    error "Vault path no encontrado: $VAULT_PATH"
    exit 1
fi
cd "$VAULT_PATH"
# Verificar si es un repositorio git
if [ ! -d ".git" ]; then
    error "No es un repositorio git. Ejecuta: git init"
    exit 1
fi
# Verificar cambios pendientes
if [ -n "$(git status --porcelain)" ]; then
    log "Cambios detectados, iniciando commit..."
    
    # Añadir todos los cambios
    git add .
    
    # Generar mensaje de commit automático
    COMMIT_MSG="Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
    
    # Contar archivos modificados
    CHANGED_FILES=$(git diff --cached --name-only | wc -l)
    
    if [ "$CHANGED_FILES" -gt 0 ]; then
        git commit -m "$COMMIT_MSG
📊 Estadísticas:
- Archivos modificados: $CHANGED_FILES
- Líneas añadidas: $(git diff --cached --numstat | awk '{sum += $1} END {print sum}')
- Líneas eliminadas: $(git diff --cached --numstat | awk '{sum += $2} END {print sum}')"
        
        log "Commit realizado: $CHANGED_FILES archivos"
    fi
else
    log "No hay cambios pendientes"
fi
# Verificar si hay remote configurado
if git remote get-url origin &>/dev/null; then
    log "Enviando cambios al remote..."
    git push origin main
    log "Sincronización completada"
else
    warning "No hay remote configurado. Configura con:"
    warning "git remote add origin <URL-del-repositorio>"
    warning "git push -u origin main"
fi
# Generar resumen del vault
TOTAL_FILES=$(find . -name "*.md" -not -path "./.git/*" | wc -l)
TOTAL_SIZE=$(du -sh . | cut -f1)
log "📊 Resumen del Vault:"
log "- Archivos .md: $TOTAL_FILES"
log "- Tamaño total: $TOTAL_SIZE"
log "- Última sincronización: $TIMESTAMP"
echo -e "\n${GREEN}✅ Sincronización completada exitosamente${NC}"
