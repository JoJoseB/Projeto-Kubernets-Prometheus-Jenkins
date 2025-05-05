# PROJETO ESIG

Este repositório é destinado a avaliação técnica para vaga de Analista de Infraestrutura na empresa ESIG Software e Quark Tecnologia, fique a vontade para clonar o repositório e contribuir para ele.

```bash
git clone https://github.com/JoJoseB/projeto-esig.git
cd projeto-esig
```
---
## Objetivos
1. Criar um contêiner para uma aplicação simples e expor as métricas via 
Jolokia
2. Execute a atividade da Etapa 1 em um cluster kubernetes.
3. Configurar o Prometheus para coletar métricas via Jolokia e do Node 
Exporter.

---
## Pré-requisitos
Esse projeto fez uso das seguintes ferramentas para execução da infraestrutura solicitada no projeto, vale ressaltar também que o projeto foi desenvolvido na plataforma WSL fazendo uso da distribuição linux **UBUNTU**:

Container com Docker: [Instalação Docker LINK](https://docs.docker.com/engine/install/)

Cluster com Kubernets: [Instalação Kubernets LINK](https://kubernetes.io/releases/download/)

Nodes com Kind: [Instalação Kind LINK](https://kind.sigs.k8s.io/docs/user/quick-start/)

---
## ETAPA 1
Após instalar os pré-requisitos e clonar o repositório, construa a imagem Docker utilizando o Dockerfile fornecido no diretório clonado. Para isso, execute o seguinte comando:

```bash
docker build --pull --rm -f 'Dockerfile' -t 'jenkins_jolokia:1.0' '.'
```

Este comando criará o container Tomcat, que conterá os arquivos .WAR do Jenkins e do Jolokia. Paralelamente, será configurado o coletor de métricas JMX (JMX Exporter), responsável por processar os dados disponibilizados pelo Jolokia e convertê-los em um formato compatível com o Prometheus, permitindo a posterior coleta e monitoramento dessas métricas pelo sistema de observabilidade.

---

## ETAPA 2
Após a build do container agora ele deve ser diponibilizado ao cluster kubernets e implantado na infraestrutura dos solicitada no projeto, para isso crie o cluster com a ferramenta Kind com o comando:

```bash
kind create cluster --config config.yaml
```

Esse comando criará o cluster com base no arquivo config.yaml que criará 4 nodes, sendo 1 deles o control-plane e os outros 3 workers que comportarão os pods, após isso a build docker criada anteriormente deve ser carregado no cluster com o comando:

```bash
kind load docker-image jenkins_jolokia:1.0 
```
---

## ETAPA 3
Com a configuração do cluster e disponibilização do container Jenkins, tudo está configurado para o deploys do pods solicitados no projeto, para automação disponilizei um script todos os serviços no online.

```bash
chmod +x scripts.sh
./scripts.sh
```

Esse script executará o comando kubectl apply -f "arquivo.yaml" em todos os arquivos presentes no repositório, com exceção do config.yaml que não é necessário, com isso o projeto deve estar em execução e os serviços podem ser visualizados com os comandos:

```bash
kubectl port-forward service/jenkins-service 8080 9400
kubectl port-forward service/prometheus-service 9090
kubectl port-forward service/grafana-service 3000
```