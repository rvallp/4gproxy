const baseUrl = "http://localhost:9081";// "http://YOUR_SERVER:9081";
const req = require('request-promise-native');

var request = req.defaults()//({"proxy":"http://localhost:8888"})

async function  login(userName,pwd){
    var result = await request.post(baseUrl + "/api/login",{form:{password:pwd,username:userName}});
    var obj = JSON.parse(result);
     console.log(`LoginResult:${result}`)
     return obj.token;
}


async function addSubUser(subUser,token){
    var result = await request.post(baseUrl + "/token/api/v1/user/add",{
        json: true,
        headers: {
            "content-type": "application/json",
            "XSRF-TOKEN":token,
        },
        body: subUser
    });

    console.log(`AddUserResult: ${result}`)
}

async function delSubUser(subUsrName,token){
    var result = await request.post(baseUrl + "/token/api/v1/user/del/" + subUsrName,{
        headers: {
            "XSRF-TOKEN":token,
        }
    });

    console.log(`delSubUser: ${result}`)
}

async function main(){
  var token = await login("u2","1");
  
    var subUser = {
        name:"subUser3",
        password:"1",
        email:"a@a12.com",
        concurrencyCount:200,
        allowedPorts: ["1234"],
        transferLimit:1000000,
    }

    await addSubUser(subUser,token)
  //  await delSubUser("subUser3",token)
}

main()