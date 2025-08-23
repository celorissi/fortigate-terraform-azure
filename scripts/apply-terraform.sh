#!/bin/bash
set -euo pipefail

# Caminhos principais
ENV_DIR="$(cd "$(dirname "$0")"/../envs/lab && pwd)"
LOG_DIR="$ENV_DIR/logs"
BACKUP_DIR="$ENV_DIR/backups"

# Cria diretórios se não existirem
mkdir -p "$LOG_DIR" "$BACKUP_DIR"

# Arquivo de log com timestamp
LOG_FILE="$LOG_DIR/terraform-apply-$(date +%F_%H-%M-%S).log"

# Redireciona stdout e stderr para tee (terminal + log)
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Iniciando deploy do Terraform ==="

# Checa se diretório do ambiente existe
if [ ! -d "$ENV_DIR" ]; then
    echo "Diretório $ENV_DIR não encontrado. Abortando."
    exit 1
fi
cd "$ENV_DIR"

# Inicializa Terraform
echo "==> Inicializando Terraform..."
terraform init -input=false

# Formata e valida
echo "==> Formatando arquivos Terraform..."
terraform fmt -check

echo "==> Validando configuração Terraform..."
terraform validate

# Cria plano
PLAN_FILE="plan.out"
echo "==> Criando plano de execução..."
terraform plan -out="$PLAN_FILE"

# Aplica plano
echo "==> Aplicando plano Terraform..."
terraform apply -auto-approve "$PLAN_FILE"

echo "✅ Terraform aplicado com sucesso! Logs em $LOG_FILE"
