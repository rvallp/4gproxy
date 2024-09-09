# For Ubuntu 22.10
If your Ubuntu version is higher then 22.04, the default script will faild during mongo installation.
You can change:
```
 echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse"
```
To:
```
 echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/5.0 multiverse"
 ```