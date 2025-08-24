# FortiGate Azure Lab

Este repositório contém instruções e código Terraform para a
implementação de um laboratório com **FortiGate no Microsoft Azure**.\
Existem duas formas principais de configuração:

------------------------------------------------------------------------

## 🔹 Opção 1 -- Configuração manual completa

-   Seguir todos os passos descritos na documentação
    `/docs/documentacao.md` (itens 1 a 8).
-   Todos os recursos (Resource Group, VNET, Subnets, NSGs, UDRs e VM
    FortiGate) devem ser criados manualmente pelo portal do Azure ou
    CLI.

------------------------------------------------------------------------

## 🔹 Opção 2 -- Provisionamento via Terraform IaC (com configuração manual da VM do Fortigate)

Observação: A criação da VM FortiGate via Terraform possui limitações
devido à plataforma **Azure Marketplace**.\
Algumas configurações internas da VM, como licenciamento e ajustes
específicos de interface, precisam ser feitas manualmente no portal do
Azure após o deploy.

Por isso, este laboratório automatiza a **infraestrutura de rede**, mas
a configuração **interna da VM FortiGate** deve ser realizada
manualmente.

-   Utilizar **Terraform** para provisionar toda a infraestrutura de
    rede:

    -   Network Security Groups (NSG)
    -   Virtual Network (VNET)
    -   Subnets
    -   Virtual Machine (VM FortiGate)
    -   User Defined Routes (UDR)

-   Após o deploy, a configuração **interna da VM FortiGate** deve ser
    feita manualmente no portal do Azure.

------------------------------------------------------------------------

## 🔹 Pré-requisitos

Antes de iniciar, instale os seguintes componentes na sua máquina local:

### 1. **Azure CLI**

O Azure CLI é utilizado para autenticação e interação com a nuvem Azure.

📖 Documentação oficial: [Instalar Azure
CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)

**Instalação rápida (Linux/macOS):**

``` bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

**Windows (PowerShell):**

``` powershell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
```

**Verificar instalação:**

``` bash
az version
```

------------------------------------------------------------------------

### 2. **Terraform**

O Terraform é o IaC utilizado para provisionar os recursos no Azure.

📖 Documentação oficial: [Instalar
Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

**Instalação rápida (Linux/macOS via script):**

``` bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**Windows (Chocolatey):**

``` powershell
choco install terraform
```

**Verificar instalação:**

``` bash
terraform -version
```

------------------------------------------------------------------------

## 🔹 Estrutura de diretórios

    envs/lab/          # Diretório do ambiente Terraform
    scripts/           # Scripts: apply-terraform.sh, destroy-terraform.sh, clean-terraform.sh, git_cli.sh
    logs/              # Logs de execução (gerados automaticamente)
    backups/           # Backups do Terraform state (gerados automaticamente)

------------------------------------------------------------------------

## 🔹 Scripts disponíveis

  ------------------------------------------------------------------------------------------
  Script                   Função         O que é mantido         O que é removido
  ------------------------ -------------- ----------------------- --------------------------
  `apply-terraform.sh`     Cria os        `logs/`, `backups/`,    State temporário,
                           recursos do    `.terraform.lock.hcl`   plan.out, cache
                           laboratório                            

  `destroy-terraform.sh`   Destroi todos  Backup do state em      Recursos na nuvem
                           os recursos do `backups/`              
                           ambiente                               

  `clean-terraform.sh`     Reseta o       Nenhum (logs e backups  Todos os arquivos locais
                           laboratório    serão recriados no      do Terraform, cache,
                           local          próximo apply)          diretórios temporários

  `git_cli.sh`             Auxilia        Nenhum                  Nenhum
                           operações Git                          
  ------------------------------------------------------------------------------------------

------------------------------------------------------------------------

## 🔹 Fluxo recomendado com fluxograma

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

------------------------------------------------------------------------

## 🔹 Fluxo de uso recomendado

1.  **Deploy inicial:**

``` bash
./scripts/apply-terraform.sh
```

2.  **Quando quiser destruir recursos:**

``` bash
./scripts/destroy-terraform.sh
```

3.  **Reset completo do laboratório (apaga arquivos locais):**

``` bash
./scripts/clean-terraform.sh
```

4.  **Novo deploy limpo:**

``` bash
./scripts/apply-terraform.sh
```

------------------------------------------------------------------------

## 🔹 Observações

-   Os diretórios `logs/` e `backups/` são recriados automaticamente no
    próximo `apply`.
-   Este laboratório é público; todos os arquivos temporários são limpos
    para evitar conflitos em clones.
-   Mantenha o backup do state se quiser restaurar algum recurso ou
    auditar a execução anterior.
