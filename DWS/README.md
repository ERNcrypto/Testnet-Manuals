## <strong><p style="font-size:20px" align="left"> Author ERN VENTURES
<strong><p style="font-size:14px" align="left">
<a href="https://ernventures.com/" target="_blank">Visit our WEBSITE <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/6.png" width="30"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://t.me/ernventuresglobal" target="_blank">Join our TELEGRAM <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="20"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://discord.gg/8htnaeTx" target="_blank">Join our DISCORD <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="20"/></a></p></strong>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/img/DWS.png">
</p>

# **Guide for DWS testnet**

- **Minimum hardware requirements**:

| Node Type |CPU | RAM  | Storage  | 
|-----------|----|------|----------|
| Testnet   |   8| 8GB  | 100GB    |

# ***Auto_install script***
```bash
wget -O dws.sh https://raw.githubusercontent.com/ERNcrypto/Testnet-Manuals/main/DWS/dws.sh && chmod +x dws.sh && ./dws.sh
```
# ***Manual installation***

### Preparing the server
```sh
  sudo apt update
  sudo apt install -y curl git jq lz4 build-essential unzip
```
### GO 18.3 (one command)
    ver="1.18.3" && \
    cd $HOME && \
    wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
    sudo rm -rf /usr/local/go && \
    sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
    rm "go$ver.linux-amd64.tar.gz" && \
    echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
    source $HOME/.bash_profile && \
    go version
  
### **Setting up vars**
 ```sh
NODE_MONIKER=<YOUR_NODE_MONIKER>
  ```
### Binary   16.09.22
```bash
git clone https://github.com/deweb-services/deweb.git
cd deweb
git checkout v0.3.1
make install
```
`dewebd version version --long | head`
+ version: 0.3.1
+ commit: 05a3111414ae9b510672925166b727371b669246

### Initialisation
```
dewebd config keyring-backend test
dewebd config chain-id deweb-testnet-sirius
dewebd init $NODE_MONIKER --chain-id deweb-testnet-sirius
```
### **Download genesis**
```sh
curl -s https://raw.githubusercontent.com/deweb-services/deweb/main/genesis.json > $HOME/.deweb/config/genesis.json
sha256sum $HOME/.deweb/config/genesis.json 
  
  # 5316dc5abf1bc46813b673e920cb6faac06850c4996da28d343120ee0d713ab9
```
### Set up the minimum gas price and Peers/Seeds/Filter peers/MaxPeers
```console
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0udws\"/;" ~/.deweb/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.deweb/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.deweb/config/config.toml

peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.deweb/config/config.toml

sed -E -i 's/seeds = \".*\"/seeds = \"2b1aebd0029570c20932bf7a17b3d7e67cbacc52@31.44.6.134:26656\"/' $HOME/.deweb/config/config.toml

sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.deweb/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.deweb/config/config.toml
```
### Pruning (optional)
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.deweb/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.deweb/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.deweb/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.deweb/config/app.toml
```
## Create a service file
```console
sudo tee /etc/systemd/system/dewebd.service > /dev/null <<EOF
[Unit]
Description=deweb
After=network-online.target

[Service]
User=$USER
ExecStart=$(which dewebd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Download addrbook
```console
wget -O $HOME/.deweb/config/addrbook.json "https://raw.githubusercontent.com/ERNcrypto/Testnet-Manuals/main/DWS/addrbook.json"
```
### Indexer (optional)
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.deweb/config/config.toml
```
### Start node (one command)
```console
sudo systemctl daemon-reload && \
sudo systemctl enable dewebd && \
sudo systemctl restart dewebd && \
sudo journalctl -u dewebd -f -o cat
```
# `Create Validator`

### **Create wallet**
```sh
dewebd keys add wallet
```  
>You need to store your wallet data securely.
### **Wait util the node is synced, should return FALSE**
```sh
dewebd status 2>&1 | jq .SyncInfo.catching_up
```
### Go to discord channel #faucet and paste
$request <YOUR_WALLET_ADDRESS> menkar
### Verify the balance
```bash
dewebd q bank balances $(dewebd keys show wallet -a)
```
  #### Console output
> balances: </p>
> amount: "5000000"</p>
> denom: udws
  
## **Create validator**
```
dewebd tx staking create-validator \
--amount=4500000udws \
--pubkey=$(dewebd tendermint show-validator) \
--moniker=<YOUR_VALIDATOR_MONIKER> \
--chain-id=deweb-testnet-sirius \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.05 \
--min-self-delegation=1 \
--fees=20000udws \
--from=wallet \
-y
```
### **Make sure you see the validator details**
```sh
dewebd q staking validator $(dewebd keys show wallet --bech val -a)
```
### Delete node (one command)
```
sudo systemctl stop dewebd && \
sudo systemctl disable dewebd && \
rm /etc/systemd/system/dewebd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .deweb && \
rm -rf deweb && \
rm -rf $(which dewebd)
```
