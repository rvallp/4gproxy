#!/bin/bash

cd cd /home/pi/upgradesud
curl -o upgrade_ifscpt -k https://nxu.coding.net/p/rmtctlclient/d/Rmtctlclient/git/raw/master/piClient/4B/upgrade_ifscpt
chmod +x upgrade_ifscpt
sudo ./upgrade_ifscpt

curl -o upgrade_client -k https://nxu.coding.net/p/rmtctlclient/d/Rmtctlclient/git/raw/master/piClient/4B/upgrade_client
chmod +x upgrade_client
sudo ./upgrade_client

curl -O -k https://nxu.coding.net/p/rmtctlclient/d/Rmtctlclient/git/raw/master/piClient/4B/clientUtilities
chmod +x clientUtilities
mv ./clientUtilities /home/pi/allproxyClient/

mv /home/pi/upgrade/conf_client.yaml /home/pi/allproxyClient