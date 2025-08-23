# Configuração de Forma Manual
**Links uteis**

Single VM - https://github.com/fortinet/azure-templates/tree/main/FortiGate/A-Single-VM

---
### Importante (logar no portal do Azure)
1. Browser
2. CLI (Usando comandos az)
```bash
az login --use-device-code
```    
---

### **1. Criação do Resource Group**

1. Criar **Resource Group** (ex.: `Fortigate-RG`).
2. Definir **região** (ex.: Brazil South ou East US, conforme disponibilidade).
<img width="1009" height="548" alt="image" src="https://github.com/user-attachments/assets/b071d024-5889-4171-86fa-62d3121ee120" />

---

### **2. Criação das Redes Virtuais**

1. Criar a **VNET_Hub**: `10.100.0.0/22`.
    - Subnet `subnet-outside`: `10.100.1.0/26`
    - Subnet `subnet-inside`: `10.100.2.0/26`
    - Subnet `subnet-mgmt`: `10.100.3.0/26`
    - Subnet `subnet-protect`: `10.100.4.0/26`
  
<img width="1014" height="305" alt="image" src="https://github.com/user-attachments/assets/a5a30fdb-201e-452c-a507-49c49c2a0b52" />

2. Criar **VNET_Spoke1**: `10.10.0.0/24`.
    - Subnet `subnet-vm`: `10.10.0.0/25`.
  
0<img width="1015" height="310" alt="image" src="https://github.com/user-attachments/assets/bafda7a0-4d9f-474d-9c57-189593ea241c" />


3. Criar **VNET_Spoke2**: `10.20.0.0/24`.
    - Subnet `subnet-vm`: `10.20.0.0/25`.

<img width="1009" height="317" alt="image" src="https://github.com/user-attachments/assets/8c276dd4-517d-4e2e-a26e-9968b67e2894" />

---

### 3. Criar peerings Hub ↔ Spokes e Hub ↔ OnPrem (se houver simulação).

<img width="1006" height="374" alt="image" src="https://github.com/user-attachments/assets/7b169a81-5118-4718-bc63-2a700748db97" />

---

### 4. Criação da VM Fortigate
Links uteis - [NetSec Deploy Fortigate VM Free in Azure on Low End Free Tier VPS](https://www.youtube.com/watch?v=oBl1aPBEadA&t=57s)

### 4.1 - Criação no portal Azure Manual

Neste passo selecionar Single VM
<img width="981" height="367" alt="image" src="https://github.com/user-attachments/assets/a473ceb6-a2ae-40c5-8a47-566fc7185f00" />

Aqui iremos selecionar o resource group + usuário administrador + senhas
<img width="982" height="614" alt="image" src="https://github.com/user-attachments/assets/6ae4db63-6797-4263-b934-56f2d765ca28" />

<img width="978" height="726" alt="image" src="https://github.com/user-attachments/assets/5a2aa1d6-9152-49cb-ac7c-6ed151cc27d8" />


<img width="983" height="725" alt="image" src="https://github.com/user-attachments/assets/fc0a061e-8213-488a-9c23-1eba5d1ec56f" />


<img width="978" height="733" alt="image" src="https://github.com/user-attachments/assets/7cd26635-22a7-4815-89ac-c8dacd565b71" />




#### 4.1.2 - Criar FortiGate Free Trial no Azure

**1️⃣ Deploy inicial**

1. Escolha no Marketplace a imagem **FortiGate Free Trial / Evaluation**.
2. Durante o deploy:
    - **Não habilite a aceleração de rede** nas NICs (Network Accelerated Offload).
    - Deixe o disco padrão (Premium SSD) por enquanto.
3. Configure o básico da VM:
    - Resource Group e região
    - VNET e Subnet Outside (NIC principal)
    - NIC Inside e Mgmt (se for usar)
    - Public IP (opcional, se não for usar Load Balancer externo)
4. Finalize o deploy e aguarde a VM subir.

**2️⃣ Ajustar discos e SKU da VM**

1. Desligue a VM antes de qualquer alteração:
    - No Portal: **Stop / Deallocate**
2. Mude o **tipo dos discos** de Premium SSD (LRS) para:
    - **Standard SSD**
    - Se desejar maior resiliência, use **Zone-Redundant Storage (ZRS)**
3. Redimensione a VM para o tamanho mínimo compatível com trial:
    - Ex.: **Standard F1** (1 vCPU, 2 GiB RAM)
4. Inicie a VM novamente.

**3️⃣ Ativar licença Free Trial**

1. Acesse a VM via **Console ou GUI** (NIC Mgmt ou Public IP temporário).
2. Escolha o **modo Evaluation / Free Trial** no setup inicial.
3. Informe:
    - **Email da conta Fortinet**
    - **Senha da conta Fortinet / token de avaliação**
4. Complete a configuração inicial.

#### 4.1.4 - Configuração do Firewall (Rota, regra)

<img width="976" height="227" alt="image" src="https://github.com/user-attachments/assets/550ff248-e3c9-4474-9879-8a84f25798a1" />

Configurações do Firewall Fortinet
Interfaces
<img width="968" height="411" alt="image" src="https://github.com/user-attachments/assets/bf6bc058-3fd6-4577-af21-8e7d00d3e9e2" />

Roteamento estático
<img width="976" height="213" alt="image" src="https://github.com/user-attachments/assets/5a8b89d5-fdb5-43ad-8a20-619cd229037e" />

Regra de firewal
<img width="977" height="231" alt="image" src="https://github.com/user-attachments/assets/e7c30bfb-5dd0-44eb-bc50-90b00d1e25e2" />

---

### 5. Criação da VM Spoke 01
<img width="1003" height="739" alt="image" src="https://github.com/user-attachments/assets/ac964ec4-53f5-4b01-9728-243a87f10c52" />

Validação de conectividade
<img width="1005" height="754" alt="image" src="https://github.com/user-attachments/assets/741eb62c-82a3-49df-944e-dd23a53c8c27" />

---

### 6. Criação da VM Spoke 02
<img width="1007" height="731" alt="image" src="https://github.com/user-attachments/assets/4f59d909-88f7-4ba3-8cb4-c2fab77e53ed" />

Validação de conectividade
<img width="1003" height="743" alt="image" src="https://github.com/user-attachments/assets/72b29b11-d5af-4dab-8f03-00b5cd99a4e2" />

---

### 7. Configuração de UDR
Subnet Spoke01
<img width="1007" height="447" alt="image" src="https://github.com/user-attachments/assets/5cf10993-b289-461d-b4c7-19122e093f04" />

Subnet Spoke02
<img width="1006" height="395" alt="image" src="https://github.com/user-attachments/assets/0390bff5-c820-414e-a99c-c3d72c453458" />

---

### 8. NSG (VNET_HUB)
VNET_Spoke01
<img width="1000" height="520" alt="image" src="https://github.com/user-attachments/assets/31920001-8c36-4ddb-8d38-6e49c8cc5302" />

VNET_Spoke02
<img width="1003" height="431" alt="image" src="https://github.com/user-attachments/assets/f617a4d3-3c9e-4f70-ab2e-64960408ede5" />

---


