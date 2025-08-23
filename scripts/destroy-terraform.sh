#!/bin/bash
set -euo pipefail

# Caminhos principais
ENV_DIR="$(cd "$(dirname "$0")"/../envs/lab && pwd)"
LOG_DIR="$ENV_DIR/logs"
BACKUP_DIR="$ENV_DIR/backups"

# Cria diretórios se não existirem
mkdir -p "$LOG_DIR" "$BACKUP_DIR"

# Arquivo de log com timestamp
LOG_FILE="$LOG_DIR/terraform-destroy-$(date +%F_%H-%M-%S).log"
STATE_FILE="$ENV_DIR/terraform.tfstate"

# Redireciona stdout e stderr para tee (terminal + log)
exec > >(tee -a "$LOG_FILE") 2>&1

echo "⚠️  ATENÇÃO: Este comando vai destruir todos os recursos deste ambiente."
read -p "Deseja continuar? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Abortado pelo usuário."
    exit 0
fi

# Checa se diretório do ambiente existe
if [ ! -d "$ENV_DIR" ]; then
    echo "Diretório $ENV_DIR não encontrado. Abortando."
    exit 1
fi
cd "$ENV_DIR"

# Backup do state, se existir
if [ -f "$STATE_FILE" ]; then
    BACKUP_FILE="$BACKUP_DIR/terraform.tfstate-$(date +%F_%H-%M-%S).bak"
    cp "$STATE_FILE" "$BACKUP_FILE"
    echo "==> Backup do state criado em $BACKUP_FILE"
fi

# Inicializa Terraform
echo "==> Inicializando Terraform..."
terraform init -input=false

# Valida configuração
echo "==> Validando configuração Terraform..."
terraform validate

# Destrói recursos
echo "==> Destruindo recursos Terraform..."
terraform destroy -auto-approve

echo "✅ Recursos destruídos com sucesso! Logs em $LOG_FILE"
