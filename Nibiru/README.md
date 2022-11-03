## <strong><p style="font-size:20px" align="left"> Author ERN VENTURES
<strong><p style="font-size:14px" align="left">
<a href="https://ernventures.com/" target="_blank">Visit our WEBSITE <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/6.png" width="30"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://t.me/ernventuresglobal" target="_blank">Join our TELEGRAM <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="20"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://discord.gg/8htnaeTx" target="_blank">Join our DISCORD <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="20"/></a></p></strong>
<hr>

<p align="center">
  <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/img/OyWtRrNP_400x400.png">
</p> 


# <span style="color:blue">**Guide for Nibiru Testnet nibiru-testnet-1**</span> 

#### Hardware Requirements
>2CPU 4RAM 100GB</p>

# ***Manual Installation***
### **Install dependencies**
```
apt update && apt upgrade -y

apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y
 ```
### **Install Go**
```sh
ver="1.19.1" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```
### **Setting up vars** (everything in <> we change to our value and remove ourselves <>)
 ```sh
nibid init <name_moniker> --chain-id nibiru-testnet-1
  ```
### **Download and build binaries**
```sh
git clone https://github.com/NibiruChain/nibiru && cd nibiru
git checkout v0.15.0
make install

nibid version --long | grep -e version -e commit

# v0.15.0
# commit: a079691baf6f96678d2a3dd9cfb0298f3bc21de2
```
### **Download genesis**
```sh
curl -s https://rpc.testnet-1.nibiru.fi/genesis | jq -r .result.genesis > genesis.json
mv genesis.json $HOME/.nibid/config/genesis.json

# Let's check the genesis
sha256sum ~/.nibid/config/genesis.json
#b58b61beb34f0d9e45ec2f1449f6600acef428b401976dc90edb9d586a412ed2
```
### **Download addrbook** 
```sh
wget -O $HOME/.nibid/config/addrbook.json "http://65.108.6.45:8000/nibiru/addrbook.json"
```
### **Setting up the configuration**
```sh
peers="37713248f21c37a2f022fbbb7228f02862224190@35.243.130.198:26656,ff59bff2d8b8fb6114191af7063e92a9dd637bd9@35.185.114.96:26656,cb431d789fe4c3f94873b0769cb4fce5143daf97@35.227.113.63:26656" 
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.nibid/config/config.toml 
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.nibid/config/config.toml 
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.nibid/config/config.toml 
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025unibi\"/;" ~/.nibid/config/app.toml

```

### **Set up pruning with one command in app.toml**
 ```sh
pruning="custom"
pruning_keep_recent="1000"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml
```

### **Create service**
 ```sh
sudo tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=nibid
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nibid) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### **Restart service and see the logs**
```sh
systemctl daemon-reload
systemctl enable nibid
systemctl restart nibid && journalctl -u nibid -f -o cat
```


# `Create Validator`

### **Create wallet**
```sh
nibid keys add <name_wallet> --keyring-backend os
```
>You need to store your wallet data securely.
### **Wait util the node is synced, should return FALSE**
```sh
nibid status 2>&1 | jq .SyncInfo.catching_up
```
>### **Go to discord channel #[ faucet ](https://discord.com/channels/947911971515293759/984840062871175219) and paste**
>$request <YOUR_WALLET_ADDRESS>
### **Verify the balance**
```bash
nibid q bank balances <address>
```

### **Create validator**
```sh
nibid tx staking create-validator \
--chain-id nibiru-testnet-1 \
--commission-rate 0.05 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.1 \
--min-self-delegation "1000000" \
--amount 1000000unibi \
--pubkey $(nibid tendermint show-validator) \
--moniker "<name_moniker>" \
--from <name_wallet> \
--fees 5000unibi
```

