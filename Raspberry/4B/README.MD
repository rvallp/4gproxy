# Install
1. Download the image from:  https://drive.google.com/file/d/1hEBgrKOJUHrlkuPGdjuuNceKZ6mw4cBF/view?usp=sharing
2. Flash the Image to a SD card
3. Use this SD card in your PI
4. Update to the latest "allproxyC" arm version.
5. Kill alproxyC process and it will start automaticlly.


# Upgrade
For the bug fixing reason, I had updated some script or clien of PI, too save our time, you can still use the old PI image and when use the following upgrade script.

## Update 1
```
curl -o upgrade_ifscpt -k https://raw.githubusercontent.com/rvallp/4gproxy/master/Raspberry/4B/upgrade_ifscpt
chmod +x upgrade_ifscpt
sudo ./upgrade_ifscpt
```

## Update 2
```
curl -o upgrade_client -k https://raw.githubusercontent.com/rvallp/4gproxy/master/Raspberry/4B/upgrade_client
chmod +x upgrade_client
sudo ./upgrade_client
```

## Update 3
supports huawei E8372
1. navigate to ~/allproxyClient
2. download client tool
```
curl -O -k https://raw.githubusercontent.com/rvallp/4gproxy/master/Tools/clientUtilities/linux/arm/clientUtilities

```
3. The command for e3372 is
```
/home/pi/allproxyClient/clientUtilities -deviceMode e3372 -params $IP
```
and for e8372 is
```
/home/pi/allproxyClient/clientUtilities -deviceMode e8372 -params $IP#user#password
```