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

1. Criar a **VNET_Hub**: `10.100.0.0/16`.
    - Subnet `subnet-outside`: `10.100.1.0/26`
    - Subnet `subnet-inside`: `10.100.2.192/26`
    - Subnet `subnet-mgmt`: `10.100.3.192/26`
    - Subnet `subnet-protect`: `10.100.4.192/26`
  
<img width="1014" height="305" alt="image" src="https://github.com/user-attachments/assets/a5a30fdb-201e-452c-a507-49c49c2a0b52" />

2. Criar **VNET_Spoke1**: `10.10.0.0/24`.
    - Subnet `subnet-vm`: `10.10.0.0/25`.
  
<img width="1015" height="310" alt="image" src="https://github.com/user-attachments/assets/bafda7a0-4d9f-474d-9c57-189593ea241c" />


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


<img width="977" height="720" alt="image" src="https://github.com/user-attachments/assets/049cdebb-e62a-49db-8869-e0fd1f657ff7" />


<img width="986" height="732" alt="image" src="https://github.com/user-attachments/assets/cfe8802e-aa59-4038-be9d-bca93099975d" />


<img width="981" height="546" alt="image" src="https://github.com/user-attachments/assets/d2148d49-ef97-445b-8797-07293a298456" />


<img width="981" height="662" alt="image" src="https://github.com/user-attachments/assets/8ae26f56-dc62-40b8-a06a-8c80a15ecd06" />


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

#### 4.1.3 - Configuração do Firewall (Rota, regra)

<img width="981" height="224" alt="image" src="https://github.com/user-attachments/assets/b0c5c26e-ad7c-438e-9d3c-1ed9f3191688" />

Configurações do Firewall Fortinet
Interfaces

<img width="979" height="420" alt="image" src="https://github.com/user-attachments/assets/5302839d-6e6c-49fa-8b04-455f1c8064da" />

Roteamento estático

<img width="980" height="214" alt="image" src="https://github.com/user-attachments/assets/9fa56d5c-569a-42f9-958b-074a5bd161c3" />


Regra de firewal

<img width="988" height="238" alt="image" src="https://github.com/user-attachments/assets/6b58730c-6d15-44cf-bd7d-c38e0ea35602" />


---

### 5. Criação da VM Spoke 01

<img width="1012" height="742" alt="image" src="https://github.com/user-attachments/assets/60378219-22f9-4c31-9c0c-edcfb78d33e6" />

Validação de conectividade

<img width="1017" height="747" alt="image" src="https://github.com/user-attachments/assets/7c5f96c3-3cc4-4728-bd0c-900da0a5b318" />

---

### 6. Criação da VM Spoke 02

<img width="1010" height="743" alt="image" src="https://github.com/user-attachments/assets/6c56c6e2-de88-4a57-b774-06b62af913e5" />


Validação de conectividade

<img width="1015" height="754" alt="image" src="https://github.com/user-attachments/assets/6a9111fd-e911-4598-97a5-8e6aeed9f582" />

---

### 7. Configuração de UDR
Subnet Spoke01

<img width="1009" height="451" alt="image" src="https://github.com/user-attachments/assets/ef97fa3c-e1ef-443b-a807-45bd12363e5b" />


Subnet Spoke02

<img width="1011" height="398" alt="image" src="https://github.com/user-attachments/assets/20a2392a-f3da-4aeb-af0d-f9259eec5a82" />

---

### 8. NSG (VNET_HUB)
VNET_Spoke01

<img width="1014" height="522" alt="image" src="https://github.com/user-attachments/assets/9794e02d-8376-4233-87dd-0340a598d76b" />


VNET_Spoke02

<img width="1012" height="437" alt="image" src="https://github.com/user-attachments/assets/613f5f88-48dc-4660-811f-12bd1733b75c" />

---


