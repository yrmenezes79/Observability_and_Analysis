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

echo "$(date '+%Y-%m-%d %H:%M:%S') - Adicionando repositorio"
cp -Rf grafana.repo /etc/yum.repos.d/
check_return_code "Adicionando repositorio"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Update Policie"
update-crypto-policies --set DEFAULT:SHA1 
check_return_code "Update Policie"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalação Grafana"
dnf install grafana -y
check_return_code "Instalação Grafana"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Start Grafana"
systemctl daemon-reload
systemctl enable --now grafana-server
check_return_code "Start Grafana"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Status Grafana"
if systemctl is-active --quiet grafana; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Grafana está ativo."
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Grafana não está ativo."
    exit 1
fi
