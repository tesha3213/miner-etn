#! /bin/bash
CURUSER=$(whoami)
USERP="etnk5Lnshv9aj123aUzJpwK8cXedfTBLvQ5tqyg8pBXQVGZE2tth5XXQ3hpvKesoieXM1nvkz9AVPKj2PW9iR1cq7Nug3qaC9r"
URL="stratum+tcp://etn-asia1.nanopool.org:13333"

ID=$(hostname)
PASS="dandelion1252@gmail.com"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y git automake build-essential autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev
git clone https://github.com/wolf9466/cpuminer-multi cpuminer
cd cpuminer
sudo ./autogen.sh
sudo CFLAGS="-march=native" ./configure
sudo make
sudo sysctl -w vm.nr_hugepages=$((`grep -c ^processor /proc/cpuinfo` * 3))
cd ~
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
source ~/.nvm/nvm.sh
nvm install v6.9.2
cd cpuminer
npm install -g pm2
sudo env PATH=$PATH:`pwd`/.nvm/versions/node/v6.9.2/bin `pwd`/.nvm/versions/node/v6.9.2/lib/node_modules/pm2/bin/pm2 startup systemd -u $CURUSER --hp `pwd`
sudo chown -R $CURUSER. ~/.pm2

pm2 start minerd -- -a cryptonight -o $URL -u $USERP -p $ID:$PASS -t `grep -c ^processor /proc/cpuinfo`
pm2 web