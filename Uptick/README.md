## <strong><p style="font-size:20px" align="left"> Author ERN VENTURES
<strong><p style="font-size:14px" align="left">
<a href="https://ernventures.com/" target="_blank">Visit our WEBSITE <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/6.png" width="30"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://t.me/ernventuresglobal" target="_blank">Join our TELEGRAM <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="20"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://discord.gg/8htnaeTx" target="_blank">Join our DISCORD <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="20"/></a></p></strong>
<hr>

<p align="center">
  <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/img/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F.png">
</p>

# **Guide for Uptick Testnet uptick_7000-1**

### Hardware Requirements
>4CPU 8RAM 200GB</p>

# ***Manual Installation***
### **Install dependencies**
```
sudo apt update
sudo apt install -y curl git jq lz4 build-essential unzip
 ```

### **Install Go 1.19**
```sh
ver="1.19" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```
### **Setting up vars**
 ```sh
NODE_MONIKER=<YOUR_NODE_MONIKER>
  ```
### **Download and build binaries**
```sh
curl -L -k https://download.uptick.network/download/uptick/testnet/release/v0.2.3/v0.2.3.tar.gz > uptick.tar.gz
tar -xvzf uptick.tar.gz
sudo mv -f uptick-v0.2.3/linux/uptickd /usr/local/bin/uptickd
rm -rf uptick.tar.gz
rm -rf uptick-v0.2.3
uptickd version # v0.2.3
```
### **Config app**
```sh
uptickd config keyring-backend test
uptickd config chain-id uptick_7000-1
uptickd init $NODE_MONIKER --chain-id uptick_7000-1
```
### **Download genesis**
```sh
curl https://raw.githubusercontent.com/UptickNetwork/uptick-testnet/main/uptick_7000-1/genesis.json > $HOME/.uptickd/config/genesis.json
sha256sum $HOME/.uptickd/config/genesis.json
 #9c2a5a9eb74103e3a9ae0599f66b9e665bdd7d67c178ab8308f853602b73be75
  ```
### **Download addrbook** 
```sh
wget -O $HOME/.uptickd/config/addrbook.json "https://cdn.discordapp.com/attachments/960153288878198874/1032009527668781116/addrbook.json"
```
### **Set seeds and peers**
 ```sh
 sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001auptick"|g' $HOME/.uptickd/config/app.toml
seeds="f97a75fb69d3a5fe893dca7c8d238ccc0bd66a8f@uptick-seed.p2p.brocha.in:30554,61f9e5839cd2c56610af3edd8c3e769502a3a439@seed0.testnet.uptick.network:26656"
peers="ce7e61b565292d6606fc0fbf4b2bc364227a1ef0@uptick-testnet.nodejumper.io:30656,eecdfb17919e59f36e5ae6cec2c98eeeac05c0f2@peer0.testnet.uptick.network:26656,178727600b61c055d9b594995e845ee9af08aa72@peer1.testnet.uptick.network:26656,61f9e5839cd2c56610af3edd8c3e769502a3a439@seed0.testnet.uptick.network:26656"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.uptickd/config/config.toml
 ```
### **In case of pruning**
 ```sh
 sed -i 's|pruning = "default"|pruning = "nothing"|g' $HOME/.uptickd/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 0|g' $HOME/.uptickd/config/app.toml
 ```
#### **If necessary, increase the number of incoming and outgoing peers for connection**
```sh
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.uptickd/config/config.toml 
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.uptickd/config/config.toml
```
#### **Configure filtering of "bad" peers**
```sh
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.uptickd/config/config.toml
```
### **Create service**
 ```sh
sudo tee /etc/systemd/system/uptickd.service > /dev/null << EOF
[Unit]
Description=Uptick Network Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which uptickd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
```
```sh
uptickd tendermint unsafe-reset-all --home $HOME/.uptickd/ --keep-addr-book
```

```sh
cd "$HOME/.uptickd" || return
rm -rf data
rm -rf wasm
```

### **Restart service**
```sh
sudo systemctl daemon-reload
sudo systemctl enable uptickd
sudo systemctl restart uptickd
 ```
### **See the logs**
 ```sh
 sudo journalctl -u uptickd -f --no-hostname -o cat
  ```

# `Create Validator`

## **Create wallet**
```sh
uptickd keys add wallet
```
>You need to store your wallet data securely.

### **Wait util the node is synced, should return FALSE**
```sh
uptickd status 2>&1 | jq .SyncInfo.catching_up
```
### **Go to discord channel #[ faucet ](https://discord.com/channels/781005936260939818/953652276508119060) and paste**
>$request <YOUR_WALLET_ADDRESS>
### **Verify the balance**
```sh
 uptickd q bank balances $(uptickd keys show wallet -a)
 ```
### Console output
> balances: </p>
> amount: "5000000000000000000"</p>
> denom: auptick
> 
### **Create validator**
```sh
uptickd tx staking create-validator \
--amount=4900000000000000000auptick \
--pubkey=$(uptickd tendermint show-validator) \
--moniker=<YOUR_VALIDATOR_MONIKER> \
--chain-id=uptick_7000-1 \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.05 \
--min-self-delegation=1 \
--fees=20000auptick \
--gas=auto \
--from=wallet \
-y
```
### **Make sure you see the validator details**
```sh
uptickd q staking validator $(uptickd keys show wallet --bech val -a)
```
