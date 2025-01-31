## Ver182
The unique id generation method had been changed on last version, but it means the device ports will be changed, so reverted it from this version.

## Ver181
Fixed bug 

## Ver180
1. Resolved dual network feature compatibility issue on Android 10 and later versions.
2. Allows make wifi as proxy if works in wifi split mode

## Ver171
Added more network info which can display in dashboard.

## Ver154(3.0.7)
Supports dual(WIFI&DATA) network in android. Detail here: https://blog.allproxy.io/2024/09/07/new-feature-dual-network-support-for-allproxy-app/

## Ver97
Fix potential issues on SMS feature.

## Ver96
Fixed an SMS related crash issue.

## Ver90
Supports UDP

## Ver89
Added SMS feature, you can receive SMS in dashboard.

## Ver88
Fixed crash issue on android 12

## Ver87
Update the ip rotation feature for non-rooted phone, we use a new way to do it to make it works more stable.

## ver85
We removed uniqueId storage in local file according customer request. Because it will hard to do backup and move the new phone.

## **Ver84** -- Save the Reconnection time
We optimized reconection logic in this version, so the average reconnection time is decreased, from 10s to 5s

## Version 83
1. Pls don't use version 80 ~ 82, it used wrong package id, so it will makes proxy port difference
2. We fixed package id issue
3. Move big blue button to bottom

## Version 82
Added 2 seconds delay during airplane off/on

## Supports IPRotation for non-rooted phone (from version 80)
https://blog.allproxy.io/2022/05/10/ip-rotation-for-r-non-rooted-devices/


## The options file (from version 76)
If you want change the options file programmatically, you can just change the file which $Android_DATA/io.allproxy.peerproxy/app_flutter/options.json

e.g:
Some phone may have same uniqueId in some time, you can just edit "uid" is this file to use another uqiqueId

