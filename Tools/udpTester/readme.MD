# udpServer
A simulated UDP server that can accept any UDP data and return it.
Usage example:
```
udpServer 8888
```

# udpClient
Used to send UDP requests, supports sending requests through a SOCKS5 proxy:
```
Usage of udpClient.exe:
  -domain string
        Domain to query (only used in DNS query mode)
  -host string
        Server hostname or IP address
  -mode string
        Client mode: 'dns' for DNS query, 'test' for sending test data (default "test")
  -port string
        Server port number
  -proxy string
        SOCKS5 proxy URL (format: socks5://username:password@host:port)
```

Usage examples:

```
//DNS query
 ./udpClient -domain google.com -mode dns -host 8.8.8.8 -port 53 
 ./udpClient -domain google.com -mode dns -host 8.8.8.8 -port 53 -proxy socks5://nl:Xs@1.1.1.1:6690

//Send test data through UDP
  ./udpClient  -host 123.123.123.123 -port 8888 
  ./udpClient  -host 123.123.123.123 -port 8888 -proxy socks5://nl:Xs@1.1.1.1:6690
```

DNS response example:
```
Received DNS response:
00000000  52 fd 81 80 00 01 00 01  00 00 00 00 06 67 6f 6f  |R............goo|
00000010  67 6c 65 03 63 6f 6d 00  00 01 00 01 c0 0c 00 01  |gle.com.........|
00000020  00 01 00 00 00 4d 00 04  8e fa b9 ee              |.....M......|
```


