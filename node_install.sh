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
cp -Rf prometheus-rpm_release.repo /etc/yum.repos.d/
check_return_code "Adicionando repositorio"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando node_exporter"
dnf install node_exporter -y
check_return_code "Instalando node_exporter"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Start Node"
systemctl start node_exporter
check_return_code "Start Node"

# Verifica o status do serviço Node Exporter e simplifica a saída
if systemctl is-active --quiet node_exporter; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Node Exporter está ativo."
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Node Exporter não está ativo."
    exit 1
fi
