#!/bin/bash
VAR1=$1
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
echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando pacotes"
dnf -y install zlib-devel pam-devel openssl-devel libtool bison flex autoconf gcc make git net-tools lsof net-tools
check_return_code "Instalando pacotes"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Adicionar Usuario"
useradd -m -s /bin/false prometheus
check_return_code "Adicionar Usuario"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Adicionando repositorio"
cp -Rf prometheus-rpm_release.repo /etc/yum.repos.d/
check_return_code "Adicionando repositorio"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalando Prometheus"
dnf install prometheus -y
check_return_code "Instalando Prometheus"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Copiando serviço Prometheus"
cp -Rf prometheus.service /etc/systemd/system/
systemctl daemon-reload

echo "$(date '+%Y-%m-%d %H:%M:%S') - Start Prometheus"
systemctl start prometheus 
check_return_code "Start Prometheus"
