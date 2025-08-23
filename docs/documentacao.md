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
<img width="725" height="393" alt="image" src="https://github.com/user-attachments/assets/ebd73044-3912-4f0d-ae77-247a535df353" />

---

### **2. Criação das Redes Virtuais**

1. Criar a **VNET_Hub**: `10.100.0.0/22`.
    - Subnet `subnet-outside`: `10.100.1.0/26`
    - Subnet `subnet-inside`: `10.100.2.0/26`
    - Subnet `subnet-mgmt`: `10.100.3.0/26`
    - Subnet `subnet-protect`: `10.100.4.0/26`
  
<img width="1004" height="305" alt="image" src="https://github.com/user-attachments/assets/e27fa85a-9bfb-4e1a-bd0c-7531b30cddac" />

2. Criar **VNET_Spoke1**: `10.10.0.0/24`.
    - Subnet `subnet-vm`: `10.10.0.0/25`.
  
<img width="1006" height="313" alt="image" src="https://github.com/user-attachments/assets/e596ca96-9a8c-4223-8d76-05e58b584eff" />

3. Criar **VNET_Spoke2**: `10.20.0.0/24`.
    - Subnet `subnet-vm`: `10.20.0.0/25`.

<img width="1000" height="312" alt="image" src="https://github.com/user-attachments/assets/74dff91a-ec2b-48ec-a469-a7b722545b1c" />

---

### 3. Criar peerings Hub ↔ Spokes e Hub ↔ OnPrem (se houver simulação).

<img width="1007" height="372" alt="image" src="https://github.com/user-attachments/assets/9ca360a2-dfd2-4d56-8764-eb1a16ffd211" />

---

### 4. Criação da VM Fortigate
Links uteis - [NetSec Deploy Fortigate VM Free in Azure on Low End Free Tier VPS](https://www.youtube.com/watch?v=oBl1aPBEadA&t=57s)

### 4.1 - Criação no portal Azure Manual

Neste passo selecionar Single VM
<img width="976" height="363" alt="image" src="https://github.com/user-attachments/assets/baa742e0-979e-4ae7-a414-bbcce44ce5b2" />

Aqui iremos selecionar o resource group + usuário administrador + senhas
<img width="977" height="613" alt="image" src="https://github.com/user-attachments/assets/06e72a2f-4bb1-43cf-9e3f-8741668d880e" />

<img width="976" height="592" alt="image" src="https://github.com/user-attachments/assets/7f00a678-5f4e-4643-934d-f51c749b684c" />

<img width="975" height="720" alt="image" src="https://github.com/user-attachments/assets/12d920c0-84ba-4f11-978c-776204a7ed1b" />

<img width="977" height="732" alt="image" src="https://github.com/user-attachments/assets/e5ea7c79-9e72-4ae3-a3b3-b0f65724f840" />

<img width="981" height="715" alt="image" src="https://github.com/user-attachments/assets/aa308c3d-1a20-450c-919b-14a3f806c256" />

<img width="977" height="726" alt="image" src="https://github.com/user-attachments/assets/07074b4f-081f-4ebf-9970-ed3b39ea8550" />

<img width="976" height="544" alt="image" src="https://github.com/user-attachments/assets/d4a97141-c2fe-4047-a297-54adb31ba09a" />

<img width="975" height="522" alt="image" src="https://github.com/user-attachments/assets/1a8257f6-ff3a-408f-b6b3-d775b7d3b421" />

<img width="976" height="665" alt="image" src="https://github.com/user-attachments/assets/7c303763-84d0-4760-be38-e008e5ecd2f5" />

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


