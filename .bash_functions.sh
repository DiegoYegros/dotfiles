largest_files() {
    local num_files=10
    while getopts ":n:" opt; do
        case $opt in
            n) num_files=$OPTARG ;;  # Set num_files to the argument passed after -n
            \?) echo "Invalid option: -$OPTARG" >&2; return 1 ;;
            :) echo "Option -$OPTARG requires an argument." >&2; return 1 ;;
        esac
    done
    sudo du -ah . | sort -rh | head -n "$num_files"
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
            LC_NUMERIC="en_US.UTF-8"
            formatted_value=$(printf "%'.2f" "$value")
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
