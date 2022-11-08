# **Upgrade genesis 8.11**

```sh
systemctl stop defundd 
defundd tendermint unsafe-reset-all --home $HOME/.defund

wget -O $HOME/.defund/config/defund-private-3-gensis.tar.gz "https://raw.githubusercontent.com/defund-labs/testnet/main/defund-private-3/defund-private-3-gensis.tar.gz"

rm -rf $HOME/.defund/config/genesis.json

cd $HOME/.defund/config

tar -xzvf defund-private-3-gensis.tar.gz

defundd config chain-id defund-private-3 
systemctl restart defundd && journalctl -u defundd -f -o cat

rm -rf defund-private-3-gensis.tar.gz
```
