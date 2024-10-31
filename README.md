# Infraestrutura Multi-Ambiente com Terraform

## Descrição
Este repositório contém a configuração de infraestrutura para três ambientes: **prod**, **staging**, e **dev**. Cada ambiente é configurado usando módulos reutilizáveis para garantir consistência, facilidade de manutenção e separação clara dos recursos.

A infraestrutura é composta por recursos como VPC, subnets, instâncias EC2, balanceador de carga (Load Balancer), grupos de segurança e outros elementos necessários para disponibilizar um ambiente funcional em nuvem usando AWS.

## Estrutura dos Arquivos

A estrutura dos arquivos foi organizada para permitir a reutilização de código e facilitar a manutenção:

```
/iac
  |-- environments
      |-- prod
          |-- main.tf
          |-- providers.tf
      |-- staging
          |-- main.tf
          |-- providers.tf
      |-- dev
          |-- main.tf
          |-- providers.tf
  |-- modules
      |-- vpc
          |-- main.tf
          ...
      |-- ec2
          |-- main.tf
          ...
      |-- load_balancer
          |-- main.tf
          ...
      |-- security_groups
          |-- main.tf
          ...
```

- **environments/**: Contém a configuração específica para cada ambiente (`prod`, `staging`, `dev`), chamando os módulos necessários.
- **modules/**: Contém os módulos reutilizáveis como VPC, EC2, Load Balancer e Grupos de Segurança, garantindo a consistência e a modularidade do código.
- **main.tf**: Arquivo principal que define a configuração global e referencia os ambientes.
- **providers.tf**: Define os provedores usados (como AWS) e o backend para armazenar o estado do Terraform.

## Recursos da Infraestrutura

### 1. VPC
Cada ambiente cria uma **Virtual Private Cloud (VPC)** com um bloco CIDR específico (`10.0.0.0/16`). Dentro dessa VPC, são criadas duas **subnets públicas** distribuídas em diferentes zonas de disponibilidade. Cada subnet é associada a uma tabela de rotas que aponta para um **Internet Gateway**, tornando-as subnets públicas.

- **Arquivo**: `modules/vpc/main.tf`
- **Componentes**:
  - **VPC**: Criação de uma VPC isolada para cada ambiente.
  - **Subnets Públicas**: Duas subnets em diferentes zonas de disponibilidade.
  - **Internet Gateway**: Prover conectividade com a Internet.
  - **Tabela de Rotas**: Configuração para que as subnets tenham acesso à Internet.

### 2. Grupos de Segurança
Os **grupos de segurança** são usados para controlar o tráfego de entrada e saída das instâncias e do balanceador de carga. O grupo de segurança configurado permite tráfego HTTP (porta 80) de qualquer origem.

- **Arquivo**: `modules/security_groups/main.tf`
- **Componentes**:
  - **Ingress**: Permite tráfego HTTP (porta 80).
  - **Egress**: Permite todo o tráfego de saída.

### 3. EC2
Cada ambiente cria instâncias **EC2** usando um AMI específico para o tipo de workload do ambiente. A instância é vinculada a uma das subnets criadas e aos grupos de segurança configurados.

- **Arquivo**: `modules/ec2/main.tf`
- **Componentes**:
  - **Instância EC2**: Configurada com o tipo de instância especificado (ex: `t4g.nano`).
  - **Tags**: Inclui tags para identificação do ambiente e gestão de recursos.

### 4. Load Balancer
O **Application Load Balancer (ALB)** é configurado para distribuir o tráfego entre as instâncias EC2 de cada ambiente. Ele é configurado com os grupos de segurança e associado às subnets públicas criadas.

- **Arquivo**: `modules/load_balancer/main.tf`
- **Componentes**:
  - **Load Balancer**: Distribui tráfego HTTP entre as instâncias.
  - **Subnets**: Associado às subnets públicas para acesso externo.
  - **Grupos de Segurança**: Controla o tráfego permitido.

## Como Implantar a Infraestrutura

1. **Clone o Repositório**:
   ```sh
   git clone https://github.com/wladimirgrf/03-devops-iac-challenge.git
   cd iac
   ```

2. **Navegue até o Diretório do Ambiente**:
   Cada ambiente possui sua própria configuração e provedores. Navegue até o diretório do ambiente desejado (`prod`, `staging`, `dev`).
   ```sh
   cd environments/<ambiente>
   ```

3. **Inicialize o Terraform**:
   Inicialize o Terraform para baixar os provedores e configurar o backend.
   ```sh
   terraform init
   ```

4. **Aplique as Configurações**:
   Execute o comando `apply` para criar a infraestrutura no ambiente específico.
   ```sh
   terraform apply
   ```

5. **Verifique os Recursos Criados**:
   Após a criação, verifique no console da AWS se os recursos foram provisionados corretamente.

## Boas Práticas e Segurança

- **Segredos e Credenciais**: O backend do Terraform está configurado para armazenar o estado em um bucket S3, e a criptografia está habilitada para proteger os dados do estado.
- **Isolamento de Ambientes**: Cada ambiente tem sua própria VPC e configurações de rede, garantindo isolamento e redução de riscos.
- **Modularidade**: A infraestrutura é modular, o que facilita a reutilização de código e a manutenção.

## Dependências
- **AWS Provider**: O provedor AWS é utilizado para criar todos os recursos. A versão especificada é `5.73.0`.
- **Backend S3**: O estado do Terraform é armazenado em um bucket S3 na região `us-east-1`.

## Estrutura de Variáveis
Cada módulo utiliza variáveis para flexibilizar e configurar os recursos de acordo com o ambiente. Por exemplo:
- **VPC**: `cidr_block`, `availability_zones`, `environment`
- **EC2**: `instance_type`, `subnet_ids`, `environment`
- **Load Balancer**: `security_group_id`, `subnet_ids`, `environment`

## Conclusão
Este projeto utiliza o Terraform para provisionar uma infraestrutura segura e consistente em três ambientes distintos. A separação dos ambientes e a reutilização de módulos garante que cada ambiente possa ser gerenciado de forma independente, enquanto mantém uma abordagem padronizada e segura para implantação de recursos em nuvem.

