## <strong><p style="font-size:20px" align="left"> Author ERN VENTURES
<strong><p style="font-size:14px" align="left">
<a href="https://ernventures.com/" target="_blank">Visit our WEBSITE <img src="https://raw.githubusercontent.com/stasiaantonova/ERN/main/6.png" width="30"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://t.me/ernventuresglobal" target="_blank">Join our TELEGRAM <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="20"/></a></p></strong>
<strong><p style="font-size:14px" align="left">
<a href="https://discord.gg/8htnaeTx" target="_blank">Join our DISCORD <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="20"/></a></p></strong>
<hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/192942503-d3df529e-1ca8-465e-a110-5d4a0c4f438e.png">
</p>

# <span style="color:blue">**Guide for Terp Testnet athena-1**</span>

### Minimum Hardware Requirements
> 4x CPUs, 8GB RAM, 100GB SSD 
  
# ***Auto_install script***
```
wget -O terp.sh https://raw.githubusercontent.com/ERNcrypto/Testnet-Manuals/main/Terp/terp.sh && chmod +x terp.sh && ./terp.sh
```
# ***Manual Installation***
You can follow [manual guide](https://github.com/ERNcrypto/Testnet-Manuals/blob/main/Terp/manual_install.md) if you better prefer setting up node manually

## Post installation

When installation is finished please load variables into system
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
terpd status 2>&1 | jq .SyncInfo
```

### (OPTIONAL) State Sync
You can state sync your node in minutes by running commands below
```
N/A
```

### Create wallet
To create new wallet you can use command below. Don’t forget to save the mnemonic
```
terpd keys add $WALLET
```

(OPTIONAL) To recover your wallet using seed phrase
```
terpd keys add $WALLET --recover
```

To get current list of wallets
```
terpd keys list
```

### Save wallet info
Add wallet and valoper address into variables 
```
TERP_WALLET_ADDRESS=$(terpd keys show $WALLET -a)
TERP_VALOPER_ADDRESS=$(terpd keys show $WALLET --bech val -a)
echo 'export TERP_WALLET_ADDRESS='${TERP_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export TERP_VALOPER_ADDRESS='${TERP_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Fund your wallet
In order to create validator first you need to fund your wallet with testnet tokens.
```
N/A
```

### Create validator
Before creating validator please make sure that you have at least 1 terp (1 terp is equal to 1000000 uterpx) and your node is synchronized

To check your wallet balance:
```
terpd query bank balances $TERP_WALLET_ADDRESS
```
> If your wallet does not show any balance than probably your node is still syncing. Please wait until it finish to synchronize and then continue 

To create your validator run command below
```
terpd tx staking create-validator \
  --amount 10000000uterpx \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(terpd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $TERP_CHAIN_ID
```

## Security
To protect you keys please make sure you follow basic security rules

### Set up ssh keys for authentication
Good tutorial on how to set up ssh keys for authentication to your server can be found [here](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04)

### Basic Firewall security
Start by checking the status of ufw.
```
sudo ufw status
```

Sets the default to allow outgoing connections, deny all incoming except ssh and 26656. Limit SSH login attempts
```
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow ${TERP_PORT}656,${TERP_PORT}660/tcp
sudo ufw enable
```

## Monitoring
To monitor and get alerted about your validator health status you can use my guide on [Set up monitoring and alerting for terp validator](https://github.com/ERNcrypto/Testnet-Manuals/blob/main/Terp/monitoring/README.md)

### Check your validator key
```
[[ $(terpd q staking validator $TERP_VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(terpd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Get list of validators
```
terpd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

## Get currently connected peer list with ids
```
curl -sS http://localhost:${TERP_PORT}657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

## Usefull commands
### Service management
Check logs
```
journalctl -fu terpd -o cat
```

Start service
```
sudo systemctl start terpd
```

Stop service
```
sudo systemctl stop terpd
```

Restart service
```
sudo systemctl restart terpd
```

### Node info
Synchronization info
```
terpd status 2>&1 | jq .SyncInfo
```

Validator info
```
terpd status 2>&1 | jq .ValidatorInfo
```

Node info
```
terpd status 2>&1 | jq .NodeInfo
```

Show node id
```
terpd tendermint show-node-id
```

### Wallet operations
List of wallets
```
terpd keys list
```

Recover wallet
```
terpd keys add $WALLET --recover
```

Delete wallet
```
terpd keys delete $WALLET
```

Get wallet balance
```
terpd query bank balances $TERP_WALLET_ADDRESS
```

Transfer funds
```
terpd tx bank send $TERP_WALLET_ADDRESS <TO_TERP_WALLET_ADDRESS> 10000000uterpx
```

### Voting
```
terpd tx gov vote 1 yes --from $WALLET --chain-id=$TERP_CHAIN_ID
```

### Staking, Delegation and Rewards
Delegate stake
```
terpd tx staking delegate $TERP_VALOPER_ADDRESS 10000000uterpx --from=$WALLET --chain-id=$TERP_CHAIN_ID --gas=auto
```

Redelegate stake from validator to another validator
```
terpd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uterpx --from=$WALLET --chain-id=$TERP_CHAIN_ID --gas=auto
```

Withdraw all rewards
```
terpd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$TERP_CHAIN_ID --gas=auto
```

Withdraw rewards with commision
```
terpd tx distribution withdraw-rewards $TERP_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$TERP_CHAIN_ID
```

### Validator management
Edit validator
```
terpd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$TERP_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
terpd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$TERP_CHAIN_ID \
  --gas=auto
```

### Delete node
This commands will completely remove node from server. Use at your own risk!
```
sudo systemctl stop terpd
sudo systemctl disable terpd
sudo rm /etc/systemd/system/terp* -rf
sudo rm $(which terpd) -rf
sudo rm $HOME/.terp* -rf
sudo rm $HOME/terp -rf
sed -i '/TERP_/d' ~/.bash_profile
```
