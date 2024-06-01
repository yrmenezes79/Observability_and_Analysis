#!/bin/bash
# Função para analisar o código de retorno de um comando
check_return_code() {
    local return_code=$?
    local message=$1

    if [ $return_code -ne 0 ]; then
        echo "Erro: $message (Código de retorno: $return_code)"
        exit $return_code
    else
        echo "Sucesso: $message"
    fi
}
echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando node_exporter"
dnf install node_exporter -y
check_return_code "Instalando node_exporter"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Start Node"
systemctl start node_exporter
check_return_code "Start Node"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Status Node"
systemctl status node_exporter
check_return_code "Status Node"
