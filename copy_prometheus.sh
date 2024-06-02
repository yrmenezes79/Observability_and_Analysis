#!/bin/bash

FILE_PROME=/etc/prometheus/prometheus.yml

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

# Verifica se o argumento foi passado
if [ $# -eq 0 ]; then
    echo "Uso: $0 nome_do_arquivo"
    exit 1
fi

# Nome do arquivo passado como argumento
FILE=$1

# Verifica se o arquivo existe
if [ -e "$FILE" ]; then
    echo "O arquivo '$FILE' existe."
    cp -Rf $FILE /etc/prometheus/
    check_return_code "Copiando arquivo $FILE"
        
else
    echo "O arquivo '$FILE' não existe."
    exit 0
fi
