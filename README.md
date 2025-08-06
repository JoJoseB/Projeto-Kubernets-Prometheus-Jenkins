# PROJETO ESIG
[//]:LINK PARA O VIDEO DA ATIVIDADE: [LINK DO VIDEO NO LOOM](https://www.loom.com/share/8b4dbe08f8ba47a4a77101f079e03689?sid=8dc03012-2907-4735-9e69-631998520773)

Este repositório foi criado para a avaliação técnica do processo seletivo da vaga de Analista de Infraestrutura na **ESIG Software** e **Quark Tecnologia**. Sinta-se à vontade para cloná-lo e, se desejar, contribuir com melhorias.
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
Este projeto utilizou as seguintes ferramentas para implementar a infraestrutura solicitada. Além disso, todo o desenvolvimento foi realizado na plataforma **WSL (Windows Subsystem for Linux)**, utilizando a distribuição **Ubuntu** como ambiente base:

Container com Docker: [Instalação Docker LINK](https://docs.docker.com/engine/install/)

Cluster com Kubernets: [Instalação Kubernets LINK](https://kubernetes.io/releases/download/)

Nodes com Kind: [Instalação Kind LINK](https://kind.sigs.k8s.io/docs/user/quick-start/)

---
## ETAPA 1
Após instalar os pré-requisitos, clonar o repositório e acessar o diretório do repositório clonado, você deverá construir a imagem Docker usando o Dockerfile fornecido no projeto. Para isso, execute o comando abaixo:
```bash
docker build --pull --rm -f 'Dockerfile' -t 'jenkins_jolokia:1.0' '.'
```
Este comando criará um container Tomcat que hospedará os arquivos .WAR do Jenkins e do Jolokia. Simultaneamente, será configurado o JMX Exporter para coletar métricas das aplicações JVM (Jenkins e Jolokia), convertendo os dados em formato compatível com o Prometheus. Essa integração permite o monitoramento contínuo das métricas através do sistema de observabilidade.

---

## ETAPA 2
Após construir a imagem do container, é necessário disponibilizá-la no cluster Kubernetes e implantá-la na infraestrutura conforme especificado no projeto. Para isso, primeiro crie um cluster local utilizando o Kind com o seguinte comando:
```bash
kind create cluster --config config.yaml
```
Este comando criará o cluster com base no arquivo config.yaml, configurando 4 nós: 1 control-plane e 3 workers que executarão os pods. Após a criação do cluster, a imagem Docker construída anteriormente deverá ser carregada no cluster utilizando o comando:
```bash
kind load docker-image jenkins_jolokia:1.0 
```
---

## ETAPA 3
Com o cluster configurado e o container do Jenkins disponibilizado, todo o ambiente está pronto para o deploy dos pods solicitados no projeto. Para automatizar o processo, disponibilizei um script que inicializa todos os serviços na infraestrutura, basta executar:
```bash
chmod +x scripts.sh
./scripts.sh
```
Este script executará o comando ```kubectl apply -f``` para todos os arquivos YAML do repositório, exceto o config.yaml (que não é necessário para esta etapa, utilizado apenas na criação do cluster). Após a execução, o projeto estará em operação e os serviços poderão ser visualizados utilizando os seguintes comandos:
```bash
kubectl port-forward service/jenkins-service 8080 9400
kubectl port-forward service/prometheus-service 9090
kubectl port-forward service/grafana-service 3000
```
Esses comandos tornarão os serviços acessíveis para a máquina host sendo possível acessa-los no navegador através dos endereços:

https://localhost:8080/jenkins -> Página de configuração inicial do Jenkins

- Observação: para adquirir o código de configuração inicial do Jenkins, deve ser realizado os seguintes comandos na infraestrutura para adquirir a chave:
```bash
kubectl exec -it deployment/jenkins-deployment -- /bin/sh
cat /root/.jenkins/secrets/initialAdminPassword
exit
```
Copie a chave exibida e cole na página de configuração do Jenkins.

https://localhost:8080/jolokia -> Api JSON diponibilizada pelo Jolokia

https://localhost:9400/metrics -> Endpoint do JMX Exporter que será consumida pelo Prometheus

https://localhost:9090 -> Interface de monitoramento do **Prometheus**

https://localhost:3000 -> Dashboard de visualização de métricas do **Grafana** - Os usuário criado é o padrão User: admin Password: admin123
