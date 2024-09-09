## Contact me
1. To enhance your online security and improve browsing speed, consider setting up your own allproxy server. For personalized assistance and guidance, please feel free to reach out to me via Telegram at https://t.me/allproxyofficial. I'll be happy to help you get started and optimize your allproxy server configuration.
2. Stay informed about the latest updates, news, and announcements related to allproxy by joining our official news channel on Telegram: https://t.me/allproxypub. By subscribing to this channel, you'll have access to timely information and valuable insights to make the most of your allproxy experience.


## Install the server application files
For paid users, we offer the option to deploy your own allproxy server, providing you with enhanced control and additional features. To set up your self-hosted allproxy server, please follow these steps:

1. Contact me to obtain a paid license. I'll guide you through the process and provide you with the necessary license key.
2. Once you have your license key, open the conf_svr.yaml file and insert the license key in the designated location. Ensure that the license key is entered correctly to avoid any deployment issues.
3. To deploy your allproxy server, run the shell script named install.sh. This script will handle the installation and configuration process, making it easy for you to set up your server.

## How to build youself 4g proxies

Allproxy offers a user-friendly solution to create your own 4G proxy server, making it accessible to users across various platforms. With its straightforward approach, setting up and utilizing your 4G proxy has never been easier.

One of the standout features of the Allproxy PC client is its ability to create a proxy for each network adapter connected to your computer. This means that if you have multiple 4G dongles plugged into your PC, the client will generate a dedicated 4G proxy for each dongle. This functionality provides you with the flexibility to manage and utilize your 4G connections efficiently.

While the following video showcases an older version of Allproxy, it still provides valuable insights into usage process. We recommend taking a few minutes to watch the video, as it will give you a good overview of how Allproxy works and how you can leverage its capabilities to establish your own 4G proxy server.

Please note that the current version of Allproxy may have additional features and improvements compared to the one shown in the video. However, the core functionality and ease of use remain the same, ensuring a smooth experience for all users.

If you have any further questions or require assistance with setting up your Allproxy 4G proxy server, please don't hesitate to reach out. Our support team is ready to help you every step of the way.

[![NewVersion2023](https://img.youtube.com/vi/NGSKZLOzJwk/0.jpg)](https://www.youtube.com/watch?v=NGSKZLOzJwk)


[![PC GUI Client](https://img.youtube.com/vi/fTCktSV2Oyo/0.jpg)](https://www.youtube.com/watch?v=fTCktSV2Oyo)

## Android
1. Download and install the Allproxy app from the Google Play Store.
2. Open the app and click the "Connect" button. You will receive a proxy address, which publishes your phone's network.
---
You can use our sample project(SDK/Android/sample_project) to see how it is simple to build a android proxy.

## 4g Dongles
1. We had just tested with Huawei E3372, E8372, E3276,CLR900A
2. It should also works with others, but we need to write script to do IP refresh on the other devices.

## Openwrt or other Linux devices
1. Download the appropriate allproxyC version for your device's CPU.
2. Change the server address in conf_client.yaml or just use our free server
2. Run allproxyC in the background.
3. Configure allproxyC to autostart for optimal performance.
   
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
wget https://raw.githubusercontent.com/rvallp/4gproxy/master/Script/install.sh
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
{"d3a849f6c55ea765058bc72ded1cfd91":{"connectedAt":"2019-09-03 14:08:08 +0800","proxyUrl":"http://192.168.10.100:53636"},"6d5ada3b1b0f9fadde94c6dc081dba69":{"connectedAt":"2019-09-03 14:08:08 +0800","proxyUrl":"http://192.168.10.100:53625"}}}
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

| Name       | Sample Value       | Desc                                                                                                                                                        |
|------------|--------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| country    | us                 | Set to "us" to get an IP from the United States.                                                                                                           |
| state      | oh                 | Set to "oh" to get an IP from the state of Ohio.                                                                                                           |
| isp        | SprintComminucations | Part of ISP name,Set to "SprintCommunications" to get an IP from the Sprint Communications ISP.                                                           |
| session    | 12345 or 12345_10m | Set to "12345" to get a fixed IP for the session. You can also specify an expiration time, e.g., "12345_10m" for a 10-minute session.                      |
| fixsession | 12345 or 12345_10m | Similar to "session". If the IP of the session is dropped, "session" will switch to a new IP, but "fixsession" will get an access error.                   |
| mobile     | 0   1              | Set to 1 to get only mobile IPs.                                                                                                                           |
| dymp       | 0   1              | Set to 1 to get only dynamic proxies listed on the external proxies page.                                                                                   |
| deviceport | 50001              | Set to a specific port number to access a specified proxy device.                                                                                          |
| iptype     | 4    6             | Set to 4 to get only IPv4 addresses. Set to 6 to get only IPv6 addresses.                                                                                  |