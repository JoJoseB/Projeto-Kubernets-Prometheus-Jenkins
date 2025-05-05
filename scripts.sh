#!/bin/bash

# Caminho base (diretório onde o script está)
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Buscando arquivos YAML em subdiretórios de: $BASE_DIR"

# Encontra e aplica todos os arquivos .yaml e .yml, ignorando arquivos chamados exatamente "config.yaml"
find "$BASE_DIR" -type f \( -name "*.yaml" -o -name "*.yml" \) ! -name "config.yaml" | while read -r file; do
  echo "Aplicando: $file"
  kubectl apply -f "$file"
  
  if [ $? -ne 0 ]; then
    echo "Erro ao aplicar: $file"
    exit 1
  fi
done

echo "Todos os arquivos YAML foram aplicados com sucesso"