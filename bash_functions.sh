largest_files() {
    local num_files=10
    while getopts ":n:" opt; do
        case $opt in
            n) num_files=$OPTARG ;;
            \?) echo "Invalid option: -$OPTARG" >&2; return 1 ;;
            :) echo "Option -$OPTARG requires an argument." >&2; return 1 ;;
        esac
    done
    sudo du -ah . | sort -rh | head -n "$num_files"
}

format_number() {
    local number=$1
    number=${number%%.*}
    reversed=$(echo $number | rev)
    with_commas=$(echo $reversed | sed 's/.\{3\}/&,/g')
    with_commas=${with_commas%,}
    echo $with_commas | rev
}

price() {
    if [ "$1" == "list" ]; then
        url="https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json"
        response=$(curl -s "$url")
        
        if ! echo "$response" | jq empty >/dev/null 2>&1; then
            echo "Failed to fetch currency list. Invalid JSON data."
            return 1
        fi
        currencies=$(echo "$response" | jq -r 'to_entries[] | "\(.key): \(.value)"' | sort)
        echo "Available currencies:"
        echo "$currencies"
    elif [ $# -ne 2 ]; then
        echo "Usage:"
        echo "  price {from_currency} {to_currency}"
        echo "  price list // get available currencies"
        return 1
    else
        from_currency=$1
        to_currency=$2
        url="https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/${from_currency}.json"
        response=$(curl -s "$url")
        if ! echo "$response" | jq empty >/dev/null 2>&1; then
            echo "Failed to fetch conversion rate. Invalid JSON data."
            return 1
        fi
        value=$(echo "$response" | jq -r ".${from_currency}.${to_currency}")
        if [ "$value" == "null" ] || [ -z "$value" ]; then
            echo "Conversion rate from $from_currency to $to_currency not found."
        else
            formatted_value=$(format_number "$value")
            echo "$from_currency price in $to_currency: $formatted_value"
        fi
    fi
}

real_price() {
    if [ "$1" == "btc" ]; then
        echo "1 BTC === 1 BTC"
    else
        echo "Usage: real_price btc"
    fi
}

createalias() {
    if [ $# -ne 2 ]; then
        echo "Usage: createalias <alias_name> <alias_value>"
        return 1
    fi
    local alias_name=$1
    local alias_value=$2
    local alias_file="$HOME/.bash_aliases.sh"

    [ ! -f "$alias_file" ] && touch "$alias_file"

    if grep -q "^alias ${alias_name}=" "$alias_file"; then
        echo "El alias '${alias_name}' ya existe en ${alias_file}."
        return 1
    fi

    echo "alias ${alias_name}='${alias_value}'" >> "$alias_file"
    echo "Alias '${alias_name}' agregado a ${alias_file}."

    source "$alias_file"
    echo "Archivo ${alias_file} recargado."
}


deletealias() {
    if [ $# -ne 1 ]; then
        echo "Usage: deletealias <alias_name>"
        return 1
    fi
    local alias_name=$1
    local alias_file="$HOME/.bash_aliases.sh"

    if [ ! -f "$alias_file" ]; then
        echo "El archivo ${alias_file} no existe."
        return 1
    fi

    if ! grep -q "^alias ${alias_name}=" "$alias_file"; then
        echo "El alias '${alias_name}' no existe en ${alias_file}."
        return 1
    fi

    sed -i.bak "/^alias ${alias_name}=/d" "$alias_file"
    echo "Alias '${alias_name}' eliminado de ${alias_file}."
}
