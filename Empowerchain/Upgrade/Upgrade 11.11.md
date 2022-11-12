# **Upgrade to v0.0.2**

height: 580000

## ***Manual Upgrade***
```sh
sudo systemctl stop empowerd

cd || return
rm -rf empowerchain
git clone https://github.com/empowerchain/empowerchain.git
cd empowerchain || return
git checkout v0.0.2
cd chain || return
make install

sudo systemctl restart empowerd
sudo journalctl -u empowerd -f --no-hostname -o cat
```
