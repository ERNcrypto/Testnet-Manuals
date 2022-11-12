## <strong><p style="font-size:20px" align="left"> Author ERN VENTURES
<strong><p style="font-size:14px" align="left">
<a href="https://ernventures.com/" target="_blank">Visit our WEBSITE <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/6.png" width="30"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://t.me/ernventuresglobal" target="_blank">Join our TELEGRAM <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="20"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://discord.gg/8htnaeTx" target="_blank">Join our DISCORD <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="20"/></a></p></strong>
<hr>

<p align="center">
  <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/img/og-gitopia.png">
</p> 


# <span style="color:blue">**Guide for Gitopia Testnet Janus**</span> 

#### Hardware Requirements
>4CPU 8RAM 200GB</p>

## ***Manual Installation***
### **Install dependencies**
```
sudo apt update && sudo apt upgrade -y

sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
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
### **Set variables**(everything in <> we change to our value and remove ourselves <>)
```sh
NODENAME="<your node name>"
```
### **Save variables in bash**
```sh
PORT=15
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export GCHAIN_ID=gitopia-janus-testnet-2" >> $HOME/.bash_profile
echo "export GPORT=${GPORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
### **Download and build binaries**
```sh
cd $HOME
curl https://get.gitopia.com | bash
git clone -b v1.2.0 gitopia://gitopia/gitopia
cd gitopia && make install

gitopiad version --long | grep -e version -e commit

# version: 1.2.0 # commit: 64e4712aeae3c723346a365d67cf1dd3e91cc50c
```
### **Initialize the node** 
 ```sh
gitopiad init $NODENAME --chain-id $GCHAIN_ID
  ```
### **Write the chain and keyring-backend to the config, change the port**
```sh
gitopiad config chain-id $GCHAIN_ID
gitopiad config keyring-backend test
gitopiad config node tcp://localhost:${GPORT}657
 ```
### **Download genesis**
```sh
wget https://server.gitopia.com/raw/gitopia/testnets/master/gitopia-janus-testnet-2/genesis.json.gz
gunzip genesis.json.gz
mv genesis.json $HOME/.gitopia/config/genesis.json

sha256sum ~/.gitopia/config/genesis.json 
# Let's check the genesis
#038a81d821f3d8f99e782cbfed609e4853d24843c48a1469287528e632a26162
```
### **Download addrbook** 
```sh
wget -qO $HOME/.gitopia/config/addrbook.json "https://raw.githubusercontent.com/ERNcrypto/Testnet-Manuals/main/Gitopia/addrbook.json"
```
### **Changing ports**
```sh
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${GPORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${GPORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${GPORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${GPORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${GPORT}660\"%" $HOME/.gitopia/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${GPORT}317\"%; s%^address = \":8080\"%address = \":${GPORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${GPORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${GPORT}091\"%" $HOME/.gitopia/config/app.toml
```
### **Set up pruning with one command in app.toml**
 ```sh
pruning="custom"
pruning_keep_recent="1000"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.gitopia/config/app.toml 
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.gitopia/config/app.toml
```
### **Disable indexing**
```sh
indexer="null"

sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.gitopia/config/config.toml
```
### **Set the minimum gas price**
```sh
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001utlore\"/" $HOME/.gitopia/config/app.toml
```
### **Setting up the configuration**
```sh
seeds=""
peers="93b218e53303ca91b7bb4f22edbb858496b1b434@65.108.6.45:60756,fbe3b1e34e1dfe9ae2cd0db471b0a807bbb3c5f2@65.109.90.178:11356"

sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gitopia/config/config.toml
```
### **Create service**
 ```sh
sudo tee /etc/systemd/system/gitopiad.service > /dev/null <<EOF
[Unit]
Description=gitopiaNode
After=network-online.target

[Service]
User=$USER
ExecStart=$(which gitopiad) start
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
systemctl enable gitopiad
systemctl restart gitopiad && journalctl -u gitopiad -f -o cat
```

# `Create Validator`

### **Create wallet**
```sh
gitopiad keys add $WALLET
```
>You need to store your wallet data securely.
### **Wait util the node is synced, should return FALSE**
```sh
gitopiad status 2>&1 | jq .SyncInfo.catching_up
```
>### **Go to the [site](https://gitopia.com/) in your personal account, connect the wallet through the seed phrase, request tokens**

### **Verify the balance**
```bash
gitopiad q bank balances <address>
```
### **Create validator**
```sh
gitopiad tx staking create-validator \
--chain-id gitopia-janus-testnet-2 \
--commission-rate 0.05 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.1 \
--min-self-delegation "1000000" \
--amount 1000000utlore \
--pubkey $(gitopiad tendermint show-validator) \
--moniker "<name_moniker>" \
--from=$WALLET \
--fees 200utlore
```
### **Add tokens to the stake**
```sh
gitopiad tx staking delegate <valoper address> 1000000utlore --from=$WALLET --chain-id=$GCHAIN_ID --fees 200utlore -y
```
