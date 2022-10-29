## <strong><p style="font-size:20px" align="left"> Author ERN VENTURES
<strong><p style="font-size:14px" align="left">
<a href="https://ernventures.com/" target="_blank">Visit our WEBSITE <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/6.png" width="30"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://t.me/ernventuresglobal" target="_blank">Join our TELEGRAM <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="20"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://discord.gg/8htnaeTx" target="_blank">Join our DISCORD <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="20"/></a></p></strong>
<hr>

<p align="center">
  <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/img/beced7f6-8f69-4767-b520-1dda5b7460e6.png">
</p> 

# **Guide for Mande Testnet**

### Hardware Requirements
>2 CPU, 4 GB RAM, 100 GB SSD</p>

# **Manual Installation**
### **Install dependencies**
```
apt update && apt upgrade -y

apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y
```
### **Setting up vars**
 ```sh
 MANDE_NODE_NAME=<your_node_name>

 MANDE_WALLET_NAME=<your_wallet_name>
 ```
### **Save variables in bash**
 ```sh
echo 'export MANDE_NODE_NAME='$MANDE_NODE_NAME >> $HOME/.bash_profile
echo 'export MANDE_WALLET_NAME='$MANDE_WALLET_NAME >> $HOME/.bash_profile
source $HOME/.bash_profile
```
### **Install Go**
 ```sh
cd $HOME
wget "https://golang.org/dl/go1.19.linux-amd64.tar.gz"

sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go1.19.linux-amd64.tar.gz"
rm "go1.19.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```
### **Download and build binaries**
 ```sh
curl -OL https://github.com/mande-labs/testnet-1/raw/main/mande-chaind
mv mande-chaind /usr/local/go/bin/
chmod 744 /usr/local/go/bin/mande-chaind
mande-chaind version --long | head
```
## **Create wallet**
 ```sh
 mande-chaind keys add $MANDE_WALLET_NAME

 #You need to store your wallet data securely.
 ```
### **Restore the wallet (if we restore the node)**
 ```sh
 mande-chaind keys add $MANDE_WALLET_NAME --recover
 ```
### **Save wallet address in bash**
 ```sh
#Change <address> to your wallet address

MANDE_ADDRESS=<address>
echo 'export MANDE_ADDRESS='$MANDE_ADDRESS >> $HOME/.bash_profile
source $HOME/.bash_profile
```
### **Make a request for tokens (may not work, in this case, skip the point)**
 ```sh
curl -d '{"address":"'$MANDE_ADDRESS'"}' -H 'Content-Type: application/json' http://35.224.207.121:8080/request
```
### **Start the node**
 ```sh
mande-chaind init $MANDE_NODE_NAME --chain-id mande-testnet-1
```
### **Download genesis****
 ```sh
 wget -O $HOME/.mande-chain/config/genesis.json "https://raw.githubusercontent.com/mande-labs/testnet-1/main/genesis.json"

 sha256sum ~/.mande-chain/config/genesis.json

 #acf013812a983e41bb97c9b29582a619719182c17704b86494735b16e6407041
 ```
### **Edit the config**
 ```sh
mande-chaind config chain-id mande-testnet-1

peers="cd3e4f5b7f5680bbd86a96b38bc122aa46668399@34.171.132.212:26656,6780b2648bd2eb6adca2ca92a03a25b216d4f36b@34.170.16.69:26656,a3e3e20528604b26b792055be84e3fd4de70533b@38.242.199.93:24656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.mande-chain/config/config.toml

seeds="cd3e4f5b7f5680bbd86a96b38bc122aa46668399@34.171.132.212:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.mande-chain/config/config.toml

sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.005mand\"/;" ~/.mande-chain/config/app.toml

pruning="custom" && \
pruning_keep_recent="1000" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.mande-chain/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.mande-chain/config/app.toml

indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.mande-chain/config/config.toml
```
### **Create service**
 ```sh
 sudo tee /etc/systemd/system/mande-chaind.service > /dev/null <<EOF
[Unit]
Description=mande-chaind
After=network-online.target

[Service]
User=$USER
ExecStart=$(which mande-chaind) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### **Restart service and see the logs**
 ```sh
 systemctl daemon-reload && \
systemctl enable mande-chaind && \
systemctl restart mande-chaind && journalctl -u mande-chaind -f -o cat
```
### **Check the status**
 ```sh
curl http://localhost:26657/status
```

# `Create Validator`

>Instead of <wallet_name>, enter the name of the wallet that was specified when creating it</p>
>Instead of <moniker>, enter the name of the validator
```sh
mande-chaind tx staking create-validator \
--chain-id mande-testnet-1 \
--amount 0cred \
--pubkey "$(mande-chaind tendermint show-validator)" \
--from <wallet_name> \
--moniker="<moniker>" \
--fees 1000mand
```
## **Get tokens**
+ Tokens can be obtained through the website http://35.224.207.121/portfolio
> After that, we stamp the tokens and vote for our wallet from the node.
+ Go to Discord in the thread #faucet-request and enter the command
 ```sh
$request <address> theta

#replace <address> with your wallet address
```
## Voting
> Instead of <sum>, enter the number of voting tokens</p>
> Leave around 1000000 for commissions, the rest can be sent
```sh
mande-chaind --from $MANDE_WALLET_NAME --chain-id mande-testnet-1 tx voting create-vote $MANDE_ADDRESS <sum> 1 --fees 1000mand
```
### **Check the balance**
```sh
mande-chaind q bank balances $MANDE_ADDRESS
```
## ***Get a role***
+ Send your link to the validator from the explorer in the chat [Discord](https://discord.com/channels/953348696098103366/1031576792697405501)
+  Find out your pir, ir and port
```sh
PORTR=$(grep -A 3 "\[p2p\]" ~/.mande-chain/config/config.toml | egrep -o ":[0-9]+") && \
echo $(mande-chaind tendermint show-node-id)@$(curl ifconfig.me)$PORTR
```
+ Copy the selected line and go to #testnet-1-validators in a special [branch](https://discord.com/channels/953348696098103366/1030760553683099648) and send your pir there
+ Next, to vote for our validator. This can be done in two ways. By command in the terminal or through the [site](http://35.224.207.121/portfolio)
