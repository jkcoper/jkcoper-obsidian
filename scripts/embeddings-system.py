#!/usr/bin/env python3
"""
Obsidian Embeddings System
Sistema de indexación semántica para navegación rápida y resúmenes
"""
import os
import json
import hashlib
from pathlib import Path
from datetime import datetime
class ObsidianEmbeddings:
    def __init__(self, vault_path):
        self.vault_path = Path(vault_path)
        self.embeddings_file = self.vault_path / ".obsidian" / "embeddings.json"
        self.index_file = self.vault_path / ".obsidian" / "search_index.json"
        
    def scan_vault(self):
        """Escanea todos los archivos .md del vault"""
        md_files = list(self.vault_path.rglob("*.md"))
        # Excluir .git y .obsidian
        md_files = [f for f in md_files if ".git" not in str(f) and ".obsidian" not in str(f)]
        return md_files
    
    def extract_metadata(self, file_path):
        """Extrae metadatos básicos de un archivo"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Extraer frontmatter (entre ---)
            frontmatter = {}
            if content.startswith('---'):
                try:
                    end = content.index('---', 3)
                    frontmatter_text = content[3:end]
                    for line in frontmatter_text.split('\n'):
                        if ':' in line:
                            key, value = line.split(':', 1)
                            frontmatter[key.strip()] = value.strip()
                except ValueError:
                    pass
            
            # Extraer títulos (líneas que empiezan con #)
            titles = []
            for line in content.split('\n'):
                if line.strip().startswith('#'):
                    titles.append(line.strip())
            
            # Extraer enlaces [[wikilinks]]
            wikilinks = []
            import re
            wikilinks = re.findall(r'\[\[(.*?)\]\]', content)
            
            # Extraer etiquetas #tags
            tags = re.findall(r'#(\w+)', content)
            
            # Generar hash del contenido
            content_hash = hashlib.md5(content.encode()).hexdigest()
            
            return {
                'path': str(file_path.relative_to(self.vault_path)),
                'size': len(content),
                'modified': datetime.fromtimestamp(file_path.stat().st_mtime).isoformat(),
                'frontmatter': frontmatter,
                'titles': titles,
                'wikilinks': wikilinks,
                'tags': tags,
                'hash': content_hash,
                'word_count': len(content.split()),
                'line_count': len(content.split('\n'))
            }
        except Exception as e:
            print(f"Error procesando {file_path}: {e}")
            return None
    
    def build_index(self):
        """Construye índice de búsqueda"""
        print("🔍 Escaneando vault...")
        files = self.scan_vault()
        
        index = {
            'vault_path': str(self.vault_path),
            'created': datetime.now().isoformat(),
            'files': [],
            'stats': {
                'total_files': len(files),
                'total_size': 0,
                'total_words': 0,
                'unique_tags': set(),
                'unique_links': set()
            }
        }
        
        for file_path in files:
            metadata = self.extract_metadata(file_path)
            if metadata:
                index['files'].append(metadata)
                index['stats']['total_size'] += metadata['size']
                index['stats']['total_words'] += metadata['word_count']
                index['stats']['unique_tags'].update(metadata['tags'])
                index['stats']['unique_links'].update(metadata['wikilinks'])
        
        # Convertir sets a lists para JSON
        index['stats']['unique_tags'] = list(index['stats']['unique_tags'])
        index['stats']['unique_links'] = list(index['stats']['unique_links'])
        
        # Guardar índice
        self.index_file.parent.mkdir(exist_ok=True)
        with open(self.index_file, 'w', encoding='utf-8') as f:
            json.dump(index, f, indent=2, ensure_ascii=False)
        
        print(f"✅ Índice creado: {len(files)} archivos indexados")
        return index
    
    def search_by_tag(self, tag):
        """Busca archivos por etiqueta"""
        if not self.index_file.exists():
            self.build_index()
        
        with open(self.index_file, 'r', encoding='utf-8') as f:
            index = json.load(f)
        
        results = []
        for file_data in index['files']:
            if tag in file_data['tags']:
                results.append(file_data['path'])
        
        return results
    
    def get_file_summary(self, file_path):
        """Genera resumen de un archivo específico"""
        metadata = self.extract_metadata(Path(file_path))
        if metadata:
            return {
                'path': metadata['path'],
                'titles': metadata['titles'][:3],  # Primeros 3 títulos
                'tags': metadata['tags'][:10],     # Primeras 10 etiquetas
                'wikilinks': metadata['wikilinks'][:10],  # Primeros 10 enlaces
                'word_count': metadata['word_count'],
                'modified': metadata['modified']
            }
        return None
if __name__ == "__main__":
    import sys
    
    vault_path = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser("~/obsidian-vault")
    
    embeddings = ObsidianEmbeddings(vault_path)
    
    if len(sys.argv) > 2 and sys.argv[2] == "search":
        tag = sys.argv[3] if len(sys.argv) > 3 else ""
        results = embeddings.search_by_tag(tag)
        print(f"🔍 Resultados para '#{tag}': {len(results)} archivos")
        for result in results:
            print(f"  📄 {result}")
    else:
        embeddings.build_index()
