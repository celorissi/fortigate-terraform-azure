# Terraform FortiGate Azure Lab

Este repositório contém instruções e código Terraform para a implementação de um laboratório com **FortiGate no Microsoft Azure**.  
Existem duas formas principais de configuração:

---

## 🔹 Opção 1 – Configuração manual completa
- Seguir todos os passos descritos na documentação (itens 1 a 8).  
- Todos os recursos (Resource Group, VNET, Subnets, NSGs, UDRs e VM FortiGate) devem ser criados manualmente pelo portal do Azure ou CLI.

---

## 🔹 Opção 2 – Provisionamento via Terraform (com configuração manual da VM)
- Utilizar **Terraform** para provisionar toda a infraestrutura de rede:
  - Network Security Groups (NSG)  
  - Virtual Network (VNET)  
  - Subnets  
  - Virtual Machine (VM FortiGate)  
  - User Defined Routes (UDR)  
- Após o deploy, a configuração **interna da VM FortiGate** deve ser feita manualmente no portal do Azure.  
  - *Motivo:* existem limitações e incompatibilidades conhecidas entre o **Azure Marketplace** e o uso direto via Terraform para FortiGate.

---