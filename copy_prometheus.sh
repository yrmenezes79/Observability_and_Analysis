#!/bin/bash
DIR=/etc/prometheus
FILE_PROME=${DIR}/prometheus.yml
FILE=$1

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

# Verifica se o argumento foi passado
if [ $# -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Uso: $0 nome_do_arquivo"
    exit 1
fi

# Verifica se o arquivo existe
if [ -e "$FILE" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - O arquivo '$FILE' existe."
    cp -Rf $FILE $DIR
    check_return_code "Copiando arquivo $FILE"

else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - O arquivo '$FILE' não existe."
    exit 1
fi

COUNT=`cat $FILE_PROME |grep  cpu.yml |wc -l`
if [[ $COUNT -eq 0 ]]
    then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Limpeza do arquivo - $FILE_PROME"
        sed -i '/rules_files:/d' "$FILE_PROME"
        check_return_code "Limpeza do arquivo - $FILE_PROME"

        echo "$(date '+%Y-%m-%d %H:%M:%S') - Adicionar arquivo - $FILE"
        echo -e "rule_files:\n  - \"$FILE\"\n" >> "$FILE_PROME"
        check_return_code " - Adicionar arquivo - $FILE"
else
       echo -e "  - \"$FILE\"\n" >> "$FILE_PROME"

fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Validando $FILE_PROME"
promtool check config $FILE_PROME
check_return_code "Validando $FILE_PROME"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Efetuado restart prometheus"
systemctl restart prometheus
check_return_code "Efetuado restart prometheus"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Status Prometheus"
if systemctl is-active --quiet prometheus; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Prometheus está ativo."
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Prometheus não está ativo."
    exit 1
fi
