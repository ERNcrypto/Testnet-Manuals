## <strong><p style="font-size:20px" align="left"> Author ERN VENTURES
<strong><p style="font-size:14px" align="left">
<a href="https://ernventures.com/" target="_blank">Visit our WEBSITE <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/6.png" width="30"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://t.me/ernventuresglobal" target="_blank">Join our TELEGRAM <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="20"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://discord.gg/8htnaeTx" target="_blank">Join our DISCORD <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="20"/></a></p></strong>
<hr>

<p align="center">
  <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/img/1_PjcXnE3_NM9V9RKRidh6Og.png">
</p>

# **Guide for Defund Testnet defund-private-2**

# ***Manual Installation***
### **Setting up vars**
 ```sh
NODENAME=<YOUR_MONIKER_NAME_GOES_HERE>
  ```
### **Save and import variables into system**
```sh
DEFUND_PORT=40
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export DEFUND_CHAIN_ID=defund-private-2" >> $HOME/.bash_profile
echo "export DEFUND_PORT=${DEFUND_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
### **Install dependencies**
```
sudo apt update && sudo apt upgrade -y

sudo apt install curl build-essential git wget jq make gcc tmux chrony -y
 ```

### **Install Go 1.19**
```sh
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
```

### **Download and build binaries**
```sh
cd $HOME && rm -rf defund
git clone https://github.com/defund-labs/defund.git
cd defund
git checkout v0.1.0
make install
```
### **Config app**
```sh
defundd config chain-id $DEFUND_CHAIN_ID
defundd config keyring-backend test
defundd config node tcp://localhost:${DEFUND_PORT}657
```
### **Init app**
```sh
defundd init $NODENAME --chain-id $DEFUND_CHAIN_ID
```
### **Download genesis and addrbook**
```sh
wget -qO $HOME/.defund/config/genesis.json "https://raw.githubusercontent.com/defund-labs/testnet/main/defund-private-2/genesis.json"
  ```

### **Set seeds and peers**
 ```sh
SEEDS="85279852bd306c385402185e0125dffeed36bf22@38.146.3.194:26656,09ce2d3fc0fdc9d1e879888e7d72ae0fefef6e3d@65.108.105.48:11256"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.defund/config/config.toml
 ```
 ### **Set custom ports**
 ```sh
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${DEFUND_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${DEFUND_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${DEFUND_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${DEFUND_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${DEFUND_PORT}660\"%" $HOME/.defund/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${DEFUND_PORT}317\"%; s%^address = \":8080\"%address = \":${DEFUND_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${DEFUND_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${DEFUND_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${DEFUND_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${DEFUND_PORT}546\"%" $HOME/.defund/config/app.toml
 ```
### **In case of pruning**
 ```sh
 pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.defund/config/app.toml
 ```
### **Set minimum gas price and timeout commit**
```sh
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ufetf\"/" $HOME/.defund/config/app.toml
```
### **Reset chain data**
```sh
defundd tendermint unsafe-reset-all --home $HOME/.defund
```
### **Create service**
 ```sh
sudo tee /etc/systemd/system/defundd.service > /dev/null <<EOF
[Unit]
Description=fetf
After=network-online.target

[Service]
User=$USER
ExecStart=$(which defundd) start --home $HOME/.defund
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### **Restart service**
```sh
sudo systemctl daemon-reload
sudo systemctl enable defundd
sudo systemctl restart defundd 
 ```
### **See the logs**
 ```sh
 sudo journalctl -u defundd -f -o cat
  ```
### **When installation is finished please load variables into system**
```sh
 source $HOME/.bash_profile
  ```
# `Create Validator`

## **Create wallet**
```sh
defundd keys add $WALLET
```
>You need to store your wallet data securely.

### **Wait util the node is synced, should return FALSE**
```sh
defundd status 2>&1 | jq .SyncInfo
```
### **Go to discord channel #[ faucet ](https://discord.com/channels/913091321114296330/1038133368841310280) and paste**
>!faucet <YOUR_WALLET_ADDRESS>
### **Verify the balance**
```sh
defundd q bank balances $WALLET
 ```
> 
### **Create validator**
```sh
defundd tx staking create-validator \
--chain-id defund-private-2 \
--commission-rate 0.05 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.1 \
--min-self-delegation "1000000" \
--amount 1000000ufetf \
--pubkey $(defundd tendermint show-validator) \
--moniker "<name_moniker>" \
--from <name_wallet>
```
