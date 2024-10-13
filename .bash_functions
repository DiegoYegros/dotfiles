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
    response=$(curl -s "https://api.coindesk.com/v1/bpi/currentprice.json")
    
    if [ "$1" == "btc" ]; then
        btc_usd=$(echo $response | jq -r '.bpi.USD.rate')
        
        echo "Bitcoin (BTC) price in USD: $btc_usd"
    else
        echo "Usage: price btc"
    fi
}
real_price() {
    if [ "$1" == "btc" ]; then
        echo "1 BTC === 1 BTC"
    else
        echo "Usage: real_price btc"
    fi
}
