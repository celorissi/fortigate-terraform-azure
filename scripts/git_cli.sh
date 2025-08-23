#!/bin/bash

# Caminho para o repositório raiz
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)/.."
cd "$ROOT_DIR" || exit

echo "==> Mostrando status do Git..."
git status

# Adiciona arquivos modificados/deletados
git add -u

# Adiciona arquivos novos de diretórios e root
git add docs/ imgs/ scripts/ envs/**/*.tf* README.md .gitignore

# Verifica se há algo para commitar
if git diff-index --quiet HEAD --; then
    echo "Nada para commitar."
    exit 0
fi

# Commit com mensagem padrão
git commit -m "Atualização do projeto Terraform FortiGate Azure"

# Atualiza branch local com rebase
git pull origin main --rebase

# Envia para o remoto
git push origin main

echo "==> Git atualizado com sucesso!"