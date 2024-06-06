#!/bin/bash

FILE=/etc/monit/monitrc

# Função para analisar o código de retorno de um comando
check_return_code() {
    local return_code=$?
    local message=$1

    if [ $return_code -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Erro: $message (Código de retorno: $return_code)"
        exit $return_code
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Sucesso: $message"
    fi
}

echo "$(date '+%Y-%m-%d %H:%M:%S') - Atualizar Repositórios"
apt update
check_return_code "Atualizar Repositórios"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalar pacotes básicos"
apt install libtool bison flex autoconf gcc make git net-tools lsof git -y
check_return_code "Instalar pacotes básicos"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Instalação do Monit"
apt-get install monit -y
check_return_code "Instalação do Monit"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Alterar arquivo de configuração"
echo "set httpd port 2812 and/" >> /etc/monit/monitrc
check_return_code "Alterar arquivo de configuração"
echo "allow localhost/allow 0.0.0.0/" >> /etc/monit/monitrc
check_return_code "Alterar arquivo de configuração"
echo "allow localhost /allow 0.0.0.0\/0/" >> /etc/monit/monitrc
check_return_code "Alterar arquivo de configuração"
echo "allow admin:monit" >> /etc/monit/monitrc
check_return_code "Alterar arquivo de configuração"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Stop - Start Monit"
systemctl restart monit
check_return_code "Stop - Start Monit"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Verificando status"
monit status
check_return_code "Verificando status"




