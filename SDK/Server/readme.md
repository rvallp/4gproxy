# sample code
We supports token based authentication and it is recommended, and we also supports cookie based authentication.

NOTW: The url is difference in the two way, for token based authentication, we need to add /token before the url, e,g: 

Add user, its api url is /api/v1/user/add by default, but for token based auth, it should be /token/api/v1/user/add

1. main.js   add user,   cookie
2. main1.js   add user, token 
3. main3.py   add user,token 
4. main4.py  query proxies, token 
5. smsReceiver.js    sample SMS receiver api implementaion, more detail pls see our document.