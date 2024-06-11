#!/bin/bash
# Defina a variável a ser validada
IP_ADDRESS=$1

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

# Verifica se a variável não está vazia
if [ -z "$IP_ADDRESS" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') A variável está vazia. Por favor, forneça um endereço IP."
    exit 1
fi

# Expressão regular para validar um endereço IPv4
regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

if [[ $IP_ADDRESS =~ $regex ]]; then
    # Se a expressão regular corresponde, verificamos cada parte do IP
    IFS='.' read -r -a octets <<< "$IP_ADDRESS"
    for octet in "${octets[@]}"; do
        if ((octet < 0 || octet > 255)); then
            echo "$(date '+%Y-%m-%d %H:%M:%S') Endereço IP inválido: cada octeto deve estar entre 0 e 255."
            exit 1
        fi
    done
    echo "Endereço IP válido."

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
