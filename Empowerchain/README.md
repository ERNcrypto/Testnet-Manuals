<strong><p style="font-size:20px" align="left">Author ERN VENTURES
<strong><p style="font-size:14px" align="left">
<a href="https://ernventures.com/" target="_blank">Visit our WEBSITE <img src="" width="30"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://t.me/ernventuresglobal" target="_blank">Join our TELEGRAM <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="20"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://discord.gg/8htnaeTx" target="_blank">Join our DISCORD <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="20"/></a></p></strong>
<hr>


![empower](https://user-images.githubusercontent.com/104348282/192093493-67779857-653e-4018-8c78-49530690f7a0.png)

# Guide for Empower Testnet altruistic-1

### Hardware Requirements
4CPU 8RAM 200GB</p>
[Website](https://www.empowerchain.io/)\
[EXPLORER](https://testnet.ping.pub/empower)\
[Discord](https://discord.com/channels/948213834164883488/948259254203195473) 

# **Automatic Installation**
pruning: custom/100/0/10; indexer: kv
```sh
source <(curl -s https://raw.githubusercontent.com/nodejumper-org/cosmos-scripts/master/empower/altruistic-1/install.sh)
```
# **Manual Installation**
### **Install dependencies, if needed**
```sh
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
cd || return
rm -rf empowerchain
git clone https://github.com/empowerchain/empowerchain
cd empowerchain/chain || return
git checkout v0.0.1
make install
empowerd version 
 
 # 0.0.1
 ```
### **Config app**
```sh
empowerd config keyring-backend test
empowerd config chain-id altruistic-1
empowerd init $NODE_MONIKER --chain-id altruistic-1
 ```
### **Download genesis**
```sh
curl -s https://raw.githubusercontent.com/empowerchain/empowerchain/main/testnets/altruistic-1/genesis.json > $HOME/.empowerchain/config/genesis.json
sha256sum $HOME/.empowerchain/config/genesis.json 

#fcae4a283488be14181fdc55f46705d9e11a32f8e3e8e25da5374914915d5ca8
 ```
### **Set seeds and peers**
 ```sh
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.025umpwr"|g' $HOME/.empowerchain/config/app.toml
seeds=""
peers="ca8b9d5fecd3258cb8bb4164017114898cd63ad5@empower-testnet.nodejumper.io:31656,6dae9286b4ef23151148922befc0f32a00cc1ec4@65.21.134.202:26656,ab4b4331d161cf0e98d3244e30225e4f38ac8d2f@65.109.28.177:44656,d9307a7ba665a54e65f4fa5dbb5401448e1c3456@65.109.30.117:30656,46b552c62df0523a2bfff285eb384e4b197484aa@65.21.133.125:33656,408980a63332b230a90ad549e93162dab303836f@65.108.225.158:17456,605b175a3cf6f71d454840baef08d0e81d94935f@65.108.52.192:46656,86669cd5e5914f862578d43de483f49e93d396b1@51.83.35.129:26656,b405572f7bf70f681d1e82f196e1399bf90a9d8a@138.201.197.163:26656,c5d44acd2f0ee122352d2f8154d9b29aeb9bf0ec@159.69.65.97:36656,2b3da30140b57d64a57a25485c237f9c7c3c3324@194.163.136.90:26656,8abceaabc650d81a751e40382f80af6c98ba466f@185.239.209.180:35656,333de3fc2eba7eead24e0c5f53d665662b2ba001@35.187.86.119:26656,b5df76282e8704d253012688613d4eb725d3cb12@77.37.176.99:56656,8498049b61177a53b3f0e6b8f7c4a574251a2bbb@149.102.157.96:36656,56d05d4ae0e1440ad7c68e52cc841c424d59badd@96.234.160.22:26656"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.empowerchain/config/config.toml
 ```
### **In case of pruning**
 ```sh
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.empowerchain/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.empowerchain/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "10"|g' $HOME/.empowerchain/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 0|g' $HOME/.empowerchain/config/app.toml
 ```
### **Create service**
 ```sh
sudo tee /etc/systemd/system/empowerd.service > /dev/null << EOF
[Unit]
Description=Empower Chain Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which empowerd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
  ```

   ```sh
empowerd tendermint unsafe-reset-all --home $HOME/.empowerchain --keep-addr-book
  ```

```sh
cd "$HOME/.empowerchain" || return
rm -rf data
  ```

   ```sh
SNAP_NAME=$(curl -s https://snapshots2-testnet.nodejumper.io/empower-testnet/ | egrep -o ">altruistic-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots2-testnet.nodejumper.io/empower-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.empowerchain
  ```
### **Restart service**
   ```sh
sudo systemctl daemon-reload
sudo systemctl enable empowerd
sudo systemctl restart empowerd
  ```
### **See the logs**
 ```sh
sudo journalctl -u empowerd -f --no-hostname -o cat
 ```

# `Create Validator`

## **Create wallet**
```sh
empowerd keys add wallet
```
## Console output
>name: wallet </p>
type: local</p>
address: empower1gved6qjsy8rxf2qxqqtk6uxnalhtm2use3hmnl
#pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"Auq9WzVEs5pCoZgr2WctjI7fU+lJCH0I3r6GC1oa0tc0"}'</p>
mnemonic: ""

**SAVE SEED PHRASE**
>kite upset hip dirt pet winter thunder slice parent flag sand express suffer chest custom pencil mother bargain remember patient other curve cancel sweet

### **Wait util the node is synced, should return FALSE**
```sh
empowerd status 2>&1 | jq .SyncInfo.catching_up
```
### **Go to discord channel #[ faucet ](https://discord.com/channels/948213834164883488/1026598604523180043) and paste**
>$request <YOUR_WALLET_ADDRESS> altruistic-1

### **Verify the balance**
```sh
empowerd q bank balances $(empowerd keys show wallet -a)
```
### Console output
>balances:</p>
>amount: "10000000"</p>
>denom: umpwr

### **Create validator**
```sh
empowerd tx staking create-validator \
--amount=9000000umpwr \
--pubkey=$(empowerd tendermint show-validator) \
--moniker=<YOUR_VALIDATOR_MONIKER> \
--chain-id=altruistic-1 \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.05 \
--min-self-delegation=1 \
--gas-prices=0.1umpwr \
--gas-adjustment=1.5 \
--gas=auto \
--from=wallet \
-y
```
### **Make sure you see the validator details**
```sh
empowerd q staking validator $(empowerd keys show wallet --bech val -a)
```





