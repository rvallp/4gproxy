# Config file
1. You should copy conf_client.yaml to the directory which store the allproxyC
2. Pls change the server address in conf_client.yaml if you want to use your server

# Debug
1. Check the current network interfaces
```
allproxyC -debug if
```

# IpV6
1. if your server have no ipv6 address, you must set a "localAddr" in conf_client.yaml in client side once you want to enable local ipv6 wokrs