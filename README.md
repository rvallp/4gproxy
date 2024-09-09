## Contact me
1. If you want to use your self allproxy server to make better security and speed, pls feel free to contact me by telegram: https://t.me/allproxyofficial
2. Official news channel: https://t.me/allproxypub


## Install the server application file
The self deployed server is just for paid users, it provides more control and features to the users.
1. Contract me to get a paid lic
2. Use the correct lic in conf_svr.yaml
3. Deploy it by the shell script "install.sh"

## How to build youself 4g proxies

Allproxy provides a easy to make your 4g proxy, it suporrts most of platform, and easy to use.
And th PC client will create proxy for each your network adapter, it means if you plugged 4g dongles in PC, you will get 4g proxy of it.

The following video is for the old version, but you can also take a view.

[![NewVersion2023](https://img.youtube.com/vi/NGSKZLOzJwk/0.jpg)](https://www.youtube.com/watch?v=NGSKZLOzJwk)


[![PC GUI Client](https://img.youtube.com/vi/fTCktSV2Oyo/0.jpg)](https://www.youtube.com/watch?v=fTCktSV2Oyo)

## Android
1. Download and Install allproxy app from google play.
2. Click connect button, you will get a proxy address, your phone network is published with this address.
---
You can use our sample project(SDK/Android/sample_project) to see how it is simple to build a android proxy.

## 4g Dongles
1. We had just tested with Huawei E3372, E8372, E3276,CLR900A
2. It should also works with others, but we need to write script to do IP refresh on the other devices.
   
## Raspberry PI
1. I just tested with Huawei E3372, the configurations may need changes for other devices.
1. ~~Download and flash the Image we built, then just plug your 4g device to PI. ImageLink:  https://drive.google.com/file/d/1hEBgrKOJUHrlkuPGdjuuNceKZ6mw4cBF/view?usp=sharing , the login info: pi/1qaz@WSX, ssh port: 3789~~

2. The allproxy client is saved in ~/allproxyClient
3. The proxies info is save in ~/allproxyClient/proxy.info
4. You should update the arm version "allproxyC" in your PI, because the default in Image is too old.
5. If you want juse use local WIFI, you need to run "sudo dhcpcd -4"
6. If you want to do some operations in UI mode, pls run "startx"

You can also install it with the following command:
```
wget https://nxu_xa.coding.net/p/allp/d/allp/git/raw/master/Linux/N1/install.sh
chmod +x install.sh
sudo ./install.sh
```

## Windows/MacOs/Raspeberry/openWrt/Other Linux...
1. Change the server address in conf_client.yaml or just use my free servers
2. Open allproxyC

## Where can I get the proxies address
It will generate a file "proxy.info" in the working directory, which contains the proxies infomation, the content likes:
```
{"proxies":
{"d3a849f6c55ea765058bc72ded1cfd91":{"connectedAt":"2019-09-03 14:08:08 +0800","proxyUrl":"http://192.168.2.100:53636"},"6d5ada3b1b0f9fadde94c6dc081dba69":{"connectedAt":"2019-09-03 14:08:08 +0800","proxyUrl":"http://192.168.2.100:53625"}}}
```

## Install PC client as service
1. You need to assign [execute] permission for allproxyC in linux env
```bash
chmod +x allproxyC
```
2. Install it as daemon service 
```bash
allproxyC -i
```
3. Check its status
```bash
allproxyC -q
```
		
## Advance usage 
If you have multiple network interfaces in your machine(Maybe some 4g dongles/stickers), and you want to speed up the proxy,you can just set field 'localAddr' in conf_client.yaml.

+ localAddr , the address should be the IP addre which used to connect with allproxy service, and it will be your wifi adapter IP in most case
```
  localAddr: 192.168.2.46
```

## Free Server
+ conn4.trs.ai:9082   (US)

     
### How can I know which proxy is which device
You can know it by the ip address now.
```
curl ifconfig.me  --interface wwlan1
curl icanhazip.com  --interface wwlan1
curl ifconfig.co  --interface wwlan1
curl ip.cn  --interface wwlan1

-- get IP of a proxy
curl --proxy http://192.168.2.100:53625 ifconfig.me
```
 

## Help
You can get all valid parameters by:
```bash
allproxyC -h
```
Valid Options:

  -h    this help

  -i    install as deamon service

  -q    query the service status

  -s signal
        send signal to IgerslikeProxy: stop, restart, start

  -server string
        The server address

  -u    uninstall deamon service

  -userId string
        The user id

  -w string
        The working directory,default is the current directory


## SuperPort SerachCondition
You can specify ip filter if you are using superPort, e.g: the proxy address "http://uname--user1--country--it:pwd@xxxxx:1234" means you want just use the IP that contry code is "it".
We provides the following valid conditions:
1. country  e.g:  country--us
2. deviceport  e.g:  deviceport--3452 , if you want use specieid device with superPort
3. ip   e.g: ip--1.2.3.4
4. state  e.g: state--ca   state--sp   (means sao paulo)
5. city  e.g: city--ceres
6. isp e.g: isp--t-mobile  , pls remove the "space" in isp name
7. session  e.g: session--1,  you can use any unique id as session value, it will fix the proxy
8. fixsession, same as session, just one difference, it will no response if the ip of session is invalid
