# FortiGate Azure Lab

Este repositório contém instruções e código Terraform para a implementação de um laboratório com **FortiGate no Microsoft Azure**.
Existem duas formas principais de configuração:

---

## 🔹 Opção 1 – Configuração manual completa

* Seguir todos os passos descritos na documentação /docs/documentacao.md (itens 1 a 8).
* Todos os recursos (Resource Group, VNET, Subnets, NSGs, UDRs e VM FortiGate) devem ser criados manualmente pelo portal do Azure ou CLI.

---

## 🔹 Opção 2 – Provisionamento via Terraform IaC (com configuração manual da VM do Fortigate)

Observação: A criação da VM FortiGate via Terraform possui limitações devido à plataforma Azure Marketplace. Algumas configurações internas da VM, como licenciamento e ajustes específicos de interface, precisam ser feitas manualmente no portal do Azure após o deploy. Por isso, este laboratório automatiza a infraestrutura de rede, mas a configuração interna da VM deve ser realizada manualmente.

* Utilizar **Terraform** para provisionar toda a infraestrutura de rede:

  * Network Security Groups (NSG)
  * Virtual Network (VNET)
  * Subnets
  * Virtual Machine (VM FortiGate)
  * User Defined Routes (UDR)

* Após o deploy, a configuração **interna da VM FortiGate** deve ser feita manualmente no portal do Azure.

---

## 🔹 Estrutura de diretórios

```
envs/lab/          # Diretório do ambiente Terraform
scripts/           # Scripts: apply-terraform.sh, destroy-terraform.sh, clean-terraform.sh, git_cli.sh
logs/              # Logs de execução (gerados automaticamente)
backups/           # Backups do Terraform state (gerados automaticamente)
```

---

## 🔹 Scripts disponíveis

| Script                 | Função                                | O que é mantido                                          | O que é removido                                                     |
| ---------------------- | ------------------------------------- | -------------------------------------------------------- | -------------------------------------------------------------------- |
| `apply-terraform.sh`   | Cria os recursos do laboratório       | `logs/`, `backups/`, `.terraform.lock.hcl`               | State temporário, plan.out, cache                                    |
| `destroy-terraform.sh` | Destroi todos os recursos do ambiente | Backup do state em `backups/`                            | Recursos na nuvem                                                    |
| `clean-terraform.sh`   | Reseta o laboratório local            | Nenhum (logs e backups serão recriados no próximo apply) | Todos os arquivos locais do Terraform, cache, diretórios temporários |
| `git_cli.sh`           | Auxilia operações Git                 | Nenhum                                                   | Nenhum                                                               |

---

## 🔹 Fluxo recomendado com fluxograma

```
       ┌─────────────────────┐
       │ apply-terraform.sh  │
       │      (Deploy)       │
       └───────────┬─────────┘
                   │
                   ▼
         Recursos criados
                   │
                   │
       ┌───────────┴───────────┐
       │ destroy-terraform.sh   │
       │       (Destruir)       │
       └───────────┬───────────┘
                   │
                   ▼
         Recursos destruídos
                   │
                   │
       ┌───────────┴───────────┐
       │ clean-terraform.sh     │
       │        (Reset)         │
       └───────────┬───────────┘
                   │
                   ▼
        Laboratório resetado
                   │
                   ▼
           Novo apply → reinício do ciclo
```

---

## 🔹 Fluxo de uso recomendado

1. **Deploy inicial:**

```bash
./scripts/apply-terraform.sh
```

2. **Quando quiser destruir recursos:**

```bash
./scripts/destroy-terraform.sh
```

3. **Reset completo do laboratório (apaga arquivos locais):**

```bash
./scripts/clean-terraform.sh
```

4. **Novo deploy limpo:**

```bash
./scripts/apply-terraform.sh
```

---

## 🔹 Observações

* Os diretórios `logs/` e `backups/` são recriados automaticamente no próximo `apply`.
* Este laboratório é público; todos os arquivos temporários são limpos para evitar conflitos em clones.
* Mantenha o backup do state se quiser restaurar algum recurso ou auditar a execução anterior.
