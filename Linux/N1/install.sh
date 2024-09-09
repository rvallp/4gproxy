#!/bin/bash

curTime=$(date "+%Y%m%d%H%M%S")

#arm x64
arch="arm"

baseUrl=https://raw.githubusercontent.com/xapanyun/4gproxy/master

allpDir="/root/allproxyClient"
echo "createing directory"
mkdir -p $allpDir/

echo "Downloading the allproxy client $curTime"
curl -O -k  $baseUrl/Linux/$arch/allproxyC

echo "Downloading the nextNum $curTime"
curl -O -k $baseUrl/Tools/nextNum/$arch/linux/nextNum

echo "Downloading the config gile $curTime"
curl -O -k  $baseUrl/Linux/arm/conf_client.yaml

echo "Downloading the  clientUtil $curTime"
curl -O -k $baseUrl/Tools/clientUtilities/linux/$arch/clientUtilities


echo "overwirte with the new client"
mv -f allproxyC $allpDir/allproxyC
mv -f conf_client.yaml $allpDir/
mv -f clientUtilities $allpDir/
mv -f nextNum $allpDir/

echo "set execute permission to script"
chmod +x $allpDir/allproxyC
chmod +x $allpDir/clientUtilities
chmod +x $allpDir/nextNum


echo "Beging installl network script"
curl -o 90upallprxy -k $baseUrl/Raspberry/4B/update/90upallprxy2
curl -o 90downallprxy -k $baseUrl/Raspberry/4B/update/90downallprxy2

mv -f 90upallprxy /etc/network/if-up.d/
echo "set execute permission to script"
chmod +x /etc/network/if-up.d/90upallprxy

echo "overwirte with the new script"
mv -f 90downallprxy /etc/network/if-post-down.d/

echo "set execute permission to script"
chmod +x /etc/network/if-post-down.d/90downallprxy

echo "Done, you can now edit ~/allproxyClient/conf_client.yaml with your server address, and run ~/allproxyClient/allproxyC"

