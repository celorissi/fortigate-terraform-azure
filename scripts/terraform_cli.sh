#!/bin/bash

# Caminho do ambiente Terraform
ENV_DIR="$(cd "$(dirname "$0")"/../envs/lab && pwd)"
cd "$ENV_DIR" || exit

echo "==> Inicializando Terraform..."
terraform init

echo "==> Formatando arquivos Terraform..."
terraform fmt

echo "==> Validando configuração Terraform..."
terraform validate

echo "==> Criando plano de execução..."
PLAN_FILE="plan.out"
terraform plan -out="$PLAN_FILE"

if [ $? -ne 0 ]; then
    echo "Erro no terraform plan. Abortando."
    exit 1
fi

echo "==> Aplicando plano Terraform..."
terraform apply -auto-approve "$PLAN_FILE"

if [ $? -eq 0 ]; then
    echo "Terraform aplicado com sucesso!"
else
    echo "Erro na aplicação do Terraform."
    exit 1
fi