The tool is not requeid for using allproxy.

## clientUtilities
You can use clientUtilities to do IP reset for Huawei E3372/E8372/E3276/CLR900A, the valid command formt is

```
clientUtilities -deviceMode e3372 -params 192.168.8.1
or
clientUtilities -deviceMode e8372 -params 192.168.8.1#user#password
```

+ if you want to do reboot:

```
clientUtilities -deviceMode e8372 -params 192.168.8.1#user#password -command reboot
or
clientUtilities -deviceMode e3372 -params 192.168.8.1 -command reboot
```

+ setDHCP(gateway)
  
  The following command means we will change the gateway from 192.168.8.1 to 192.168.9.1

```
clientUtilities -deviceMode e3372 -params 192.168.8.1#9 -command gw
clientUtilities -deviceMode e8372 -params 192.168.8.1#user#password#9 -command gw
```

## setDHCP.exe (For windows only)
A tool which can change the DHCP of huaweiE3372
+ you can use clientUtilities instead of this tool.
  
## proxyTester (For windows only)
A tool which supports http and socks5 proxy verification

## performanTest (Both Linux and Windows)
A tool for proxy performance testing, you can specify proxy address, url, concurrent, minutes.

## wpa_cli
Android wifi debug tool

## nextNum
It is used in our bash script