#!/bin/bash

# Função para analisar o código de retorno de um comando
check_return_code() {
    local return_code=$?
    local message=$1

    if [ $return_code -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Erro: $message (Código de retorno: $return_code)"
        exit $return_code
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') Sucesso: $message"
    fi
}

echo "$(date '+%Y-%m-%d %H:%M:%S') - Atualize a lista de pacotes"
apt-get update
check_return_code "Atualize a lista de pacotes"

echo "$(date '+%Y-%m-%d %H:%M:%S') -  Instalação de pacotes"
apt-get install -y software-properties-common net-tools
check_return_code " Instalação de pacotes"

echo "$(date '+%Y-%m-%d %H:%M:%S') -  Capturar chave"
curl https://packages.grafana.com/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/grafana.gpg add -
check_return_code "Capturar chave"

echo "$(date '+%Y-%m-%d %H:%M:%S') -  Adicionar repositório"
add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
check_return_code "Adicionar repositório"

echo "$(date '+%Y-%m-%d %H:%M:%S') -  Adicione a chave GPG do repositório"
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
check_return_code "Adicione a chave GPG do repositório"

echo "$(date '+%Y-%m-%d %H:%M:%S') -  Atualize a lista de pacotes"
apt-get update
check_return_code "Atualize a lista de pacotes"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalação Grafana"
apt-get install -y grafana
check_return_code "Instalação Grafana"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Inicie o serviço do Grafana"
systemctl start grafana-server
check_return_code "Inicie o serviço do Grafana"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Verificar porta Grafana"
sleep 10
netstat -tuln | grep 3000
check_return_code "Verificar porta Grafana"
