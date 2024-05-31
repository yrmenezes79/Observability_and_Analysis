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

check_variable() {
    local var_value=$1

    # Verifica se a variável está vazia
    if [ -z "$var_value" ]; then
        echo "A variável está vazia."
    # Verifica se a variável está entre 1 e 6
    elif [ "$var_value" -ge 1 ] 2>/dev/null && [ "$var_value" -le 6 ] 2>/dev/null; then
        echo "A variável está dentro do intervalo de 1 a 6."
    else
        echo "A variável não está vazia e não está dentro do intervalo de 1 a 6."
    fi
}

check_variable "$VAR1"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Parando o Monit"
systemctl stop monit
check_return_code "Parando o Monit"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Trocando o arquivo"
mv /etc/monit/monitrc /etc/monit/monitrc_$(date '+%Y-%m-%d-%H:%M:%S')
cp monitrc${VAR1} /etc/monit/monitrc
check_return_code " Trocando o arquivo"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Verificando integriade do arquivo"
monit -t
check_return_code "Verificando integriade do arquivo"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Iniciando o Monit"
systemctl start monit
check_return_code "Iniciando o Monit"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Verificando o Monit"
systemctl status monit
check_return_code "Verificando o Monit"
