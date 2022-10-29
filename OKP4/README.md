## <strong><p style="font-size:20px" align="left"> Author ERN VENTURES
<strong><p style="font-size:14px" align="left">
<a href="https://ernventures.com/" target="_blank">Visit our WEBSITE <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/6.png" width="30"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://t.me/ernventuresglobal" target="_blank">Join our TELEGRAM <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="20"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://discord.gg/8htnaeTx" target="_blank">Join our DISCORD <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="20"/></a></p></strong>
<hr>


![uptick](https://raw.githubusercontent.com/stasiaantonova/ERN/main/img/OKP4-1.png) align="left

# **Guide for OKP4 Testnet okp4-nemeton**

### Hardware Requirements
>4CPU 8RAM 200GB</p>

## **Manual Installation**
### **Install dependencies**
```
sudo apt update
sudo apt install -y curl git jq lz4 build-essential unzip
 ```
### **Install Go**
```sh
if [ ! -f "/usr/local/go/bin/go" ]; then
  bash <(curl -s "https://raw.githubusercontent.com/ERNcrypto/Testnet-Manuals/main/OKP4/go_install.sh")
  source .bash_profile
fi
```
### **Setting up vars**
 ```sh
NODE_MONIKER=<YOUR_NODE_MONIKER>
  ```
### **Download and build binaries**
```sh
cd || return
rm -rf okp4d
git clone https://github.com/okp4/okp4d.git
cd okp4d || return
git checkout v2.2.0
make install
okp4d version # v2.2.0
```
### **Config app**
```sh
okp4d config keyring-backend test
okp4d config chain-id okp4-nemeton
okp4d init $NODE_MONIKER --chain-id okp4-nemeton
```
### **Download genesis**
```sh
curl https://raw.githubusercontent.com/okp4/networks/main/chains/nemeton/genesis.json > $HOME/.okp4d/config/genesis.json
sha256sum $HOME/.okp4d/config/genesis.json 

#c2e8fff161850e419e1cb1bef3648c0ed0db961b7713151f10f2509e3fc2ff40
```
### **Download addrbook** 
```sh
curl -s https://raw.githubusercontent.com/ERNcrypto/Testnet-Manuals/main/OKP4/addrbook.json > $HOME/.okp4d/config/addrbook.json
```
### **Set seeds and peers**
 ```sh
 sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001uknow"|g' $HOME/.okp4d/config/app.toml
seeds="8e1590558d8fede2f8c9405b7ef550ff455ce842@51.79.30.9:26656,bfffaf3b2c38292bd0aa2a3efe59f210f49b5793@51.91.208.71:26656,106c6974096ca8224f20a85396155979dbd2fb09@198.244.141.176:26656,a7f1dcf7441761b0e0e1f8c6fdc79d3904c22c01@38.242.150.63:36656"
peers="994c9398e55947b2f1f45f33fbdbffcbcad655db@okp4-testnet.nodejumper.io:29656"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.okp4d/config/config.toml
```
### **In case of pruning**
```sh
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.okp4d/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.okp4d/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "10"|g' $HOME/.okp4d/config/app.toml
```
### **Create service**
 ```sh
sudo tee /etc/systemd/system/okp4d.service > /dev/null << EOF
[Unit]
Description=OKP4 Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which okp4d) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
```
```sh
okp4d tendermint unsafe-reset-all --home $HOME/.okp4d --keep-addr-book
```
```sh
cd "$HOME/.okp4d" || return
rm -rf data
rm -rf wasm
```
### **Restart service**
```sh
sudo systemctl daemon-reload
sudo systemctl enable okp4d
sudo systemctl restart okp4d
```
### **See the logs**
 ```sh
sudo journalctl -u okp4d -f --no-hostname -o cat
```

# `Create Validator`

### **Create wallet**
```sh
okp4d keys add wallet
```
>You need to store your wallet data securely.
### **Wait util the node is synced, should return FALSE**
```sh
okp4d status 2>&1 | jq .SyncInfo.catching_up
```
>#### **Go to https://faucet.okp4.network/ and paste your wallet address**
### **Verify the balance**
```sh
okp4d q bank balances $(okp4d keys show wallet -a)
```
#### Console output
> balances: </p>
> amount: "1000000"</p>
> denom: uknow
### **Create validator**
```sh
okp4d tx staking create-validator \
--amount=900000uknow \
--pubkey=$(okp4d tendermint show-validator) \
--moniker=<YOUR_VALIDATOR_MONIKER> \
--chain-id=okp4-nemeton \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.05 \
--min-self-delegation=1 \
--fees=2000uknow \
--from=wallet \
-y
```
### **Make sure you see the validator details**
```sh
okp4d q staking validator $(okp4d keys show wallet --bech val -a)
```
