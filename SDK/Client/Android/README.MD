## peerproxy90.aar
Supports UDP

# API Methods:
## Connect
```
peerproxyClientSdk.PeerproxyClientSdk.connectV2(String serverAddr, Bool enableHttp,Bool enableS5, String androidId, "", “”, String externalInfo);
```
NOTE: externalInfo should be valid json format, you can also ignore it.

## Disconnect
```
peerproxyClientSdk.PeerproxyClientSdk.disConnect();
```

## getPublicProxyUrl
Return the proxy url.

```
peerproxyClientSdk.PeerproxyClientSdk.getPublicUrl()
```

# Note
You must call “connectV2” in a individual thread or background service , because this method will block the running thread to do the proxy comminication