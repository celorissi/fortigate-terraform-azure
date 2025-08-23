# 📘 Guia de Deploy Manual do FortiGate no Azure

## 🔐 Etapa 0 - Autenticação no Azure
1. Login via Browser  
2. Login via CLI:  
   ```bash
   az login --use-device-code
   ```

## 🏗️ Etapa 1 - Criação do Resource Group
- Criar o **Resource Group** (ex.: `Fortigate-RG`)  
- Definir a **região** (ex.: `Brazil South` ou `East US`)  

## 🌐 Etapa 2 - Criação das Redes Virtuais
**VNET_Hub – `10.100.0.0/16`**  
- Subnet `subnet-outside`: `10.100.1.0/26`  
- Subnet `subnet-inside`: `10.100.2.0/26`  
- Subnet `subnet-mgmt`: `10.100.3.0/26`  
- Subnet `subnet-protect`: `10.100.4.0/26`  

**VNET_Spoke1 – `10.10.0.0/24`**  
- Subnet `subnet-vm`: `10.10.0.0/25`  

**VNET_Spoke2 – `10.20.0.0/24`**  
- Subnet `subnet-vm`: `10.20.0.0/25`  

## 🔗 Etapa 3 - Peerings
- Criar peering **Hub ↔ Spoke1**  
- Criar peering **Hub ↔ Spoke2**  
- Criar peering **Hub ↔ OnPrem** (caso exista simulação)  

## 🔥 Etapa 4 - Criação da VM FortiGate

### 4.1 Criação Manual
- Selecionar **Single VM** no Marketplace  
- Definir Resource Group, usuário administrador e senha  
- Configurar NICs (Outside, Inside, Mgmt) e Public IP (opcional)  

### 4.2 Deploy Free Trial
1. Escolher a imagem **FortiGate Free Trial / Evaluation**  
2. Configurações iniciais:  
   - Network Accelerated Offload **desativado**  
   - Disco padrão (Premium SSD)  
   - Configuração básica (RG, região, NICs, IP)  
3. Após o deploy:  
   - Desligar a VM (**Stop / Deallocate**)  
   - Ajustar discos de Premium SSD → Standard SSD (ou ZRS)  
   - Redimensionar para **Standard F1** (1 vCPU, 2 GiB RAM)  
   - Iniciar a VM  
4. Ativar licença **Free Trial**:  
   - Acessar via Mgmt ou Public IP  
   - Selecionar modo *Evaluation / Free Trial*  
   - Inserir conta Fortinet e token de avaliação  

### 4.3 Configuração Inicial do Firewall
- Configurar **interfaces** com IPs  
- Criar **rota estática** (saída internet → outside)  
- Criar **política de firewall** (inside ↔ outside)  

## 💻 Etapa 5 - Criação da VM Spoke01
- Deploy VM simples dentro da **VNET_Spoke1**  
- Validar conectividade com Hub via UDR + FortiGate  

## 💻 Etapa 6 - Criação da VM Spoke02
- Deploy VM simples dentro da **VNET_Spoke2**  
- Validar conectividade com Hub via UDR + FortiGate  

## 🛣️ Etapa 7 - Configuração de UDR
- Associar tabelas de rotas às subnets **Spoke01** e **Spoke02**  
- Definir FortiGate como **Next Hop**  

## 🔒 Etapa 8 - Configuração de NSG
- Criar **NSGs** para `VNET_Hub`, `VNET_Spoke01` e `VNET_Spoke02`  
- Regras recomendadas:  
  - Permitir **SSH/HTTPS** de gerenciamento  
  - Permitir tráfego **Spokes ↔ Hub**  
  - Bloquear acessos desnecessários da internet  
