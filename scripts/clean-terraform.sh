#!/bin/bash
set -euo pipefail

# Caminho do ambiente
ENV_DIR="$(cd "$(dirname "$0")"/../envs/lab && pwd)"

echo "=== Reset completo do laboratório Terraform ==="

cd "$ENV_DIR"

# Apaga arquivos e diretórios do Terraform
rm -f terraform.tfstate terraform.tfstate.backup plan.out .terraform.lock.hcl
rm -rf .terraform logs backups

echo "✅ Laboratório completamente resetado."
echo "Os diretórios logs/ e backups/ serão recriados automaticamente no próximo apply."

