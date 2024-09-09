const baseUrl = "https://localhost:9081";// "http://YOUR_SERVER:9081";
const req = require('request-promise-native');

var request = req.defaults({jar: true}) //"proxy":"http://localhost:8888"})

async function  login(userName,pwd){
    var result = await request.post(baseUrl + "/api/login",{form:{password:pwd,username:userName}});
     console.log(`LoginResult:${result}`)
}


async function addSubUser(subUser){
    var result = await request.post(baseUrl + "/token/api/v1/user/add",{
        json: true,
        headers: {
            "content-type": "application/json",
        },
        body: subUser
    });

    console.log(`AddUserResult: ${result}`)
}

async function delSubUser(subUsrName){
    var result = await request.post(baseUrl + "/token/api/v1/user/del/" + subUsrName);

    console.log(`delSubUser: ${result}`)
}

async function main(){
   await login("tony","a111111");
  
    var subUser = {
        name:"subUser3",
        password:"1",
        email:"a@a.com",
        concurrencyCount:200,
        allowedPorts: ["1234"],
        transferLimit:1000000,
    }

    await addSubUser(subUser)
    await delSubUser("subUser3")
}

main()