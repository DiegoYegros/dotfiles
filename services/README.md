1. Download Bitcoin Knots (We don't like clogging the UTXO set here).
2. Configure your node in bitcoin.conf to your liking.
3. Let it sync. It takes time.
4. Change this line from the .services files: User=${your_user_here}
5. Move services into place
- sudo cp bitcoind-mainnet.service /etc/systemd/system/
- sudo cp bitcoind-testnet.service /etc/systemd/system/
- sudo cp lnd.service /etc/systemd/system/
6. Make them run on boot
- sudo systemctl daemon-reload
- sudo systemctl enable bitcoind-mainnet
- sudo systemctl enable bitcoind-testnet
- sudo systemctl enable lnd

Congrats. You are one step closer to becoming a self-sovereign individual.
