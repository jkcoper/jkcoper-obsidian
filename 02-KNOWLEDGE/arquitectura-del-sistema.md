---
type: knowledge
category: architecture
tags: [system, architecture, design, patterns]
created: 2025-01-09
---
# Arquitectura del Sistema Obsidian AI
## 🏗️ Diseño General
### Capa de Datos
- **Markdown Files**: Fuente de verdad
- **Git Repository**: Versionamiento
- **Embeddings Index**: Búsqueda semántica
### Capa de Automatización
- **Sync Scripts**: Sincronización multi-plataforma
- **Python System**: Procesamiento de embeddings
- **Shell Scripts**: Operaciones del sistema
### Capa de Integración
- **REST API**: Interfaz programática
- **MCP Server**: Conexión con AI
- **OpenCode**: Asistente inteligente
## 🔄 Patrones de Diseño
### 1. Repository Pattern
```bash
obsidian-vault/
├── .git/           # Versionamiento
├── .obsidian/      # Configuración local
└── content/        # Contenido principal
2. Plugin Architecture
- Core: Funcionalidad básica
- Plugins: Extensiones modulares
- API: Interfaz de integración
3. Event-Driven Sync
- Watch Files: Detectar cambios
- Trigger Sync: Automatizar push
- Cross-Platform: Adaptar a OS
🛠️ Tecnologías
Frontend (Obsidian)
- Electron: Framework desktop
- Vue.js: Interfaz reactiva
- CodeMirror: Editor de texto
Backend (Scripts)
- Python: Procesamiento de datos
- Bash: Automatización sistema
- Git: Control de versiones
Integration
- REST API: Comunicación HTTP
- MCP: Model Context Protocol
- JSON: Formato de intercambio
---
#architecture #system #design #patterns #knowledge
