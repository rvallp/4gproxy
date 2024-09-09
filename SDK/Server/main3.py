import requests,json

BASE = "https://YOURSERV:9081"
USERNAME = "a"
PASSWORD = "1"

TOKEN = ""

r = requests.session()
res = r.post(BASE + "/api/login", data={
    "username": USERNAME,
    "password": PASSWORD
})
sb = json.loads(res.text)
TOKEN = sb['token']
print(TOKEN)

def addSubUser(subUser, token):
    result = r.post(BASE + "/token/api/v1/user/add",
                           headers={
                               "content-type": "application/json",
                               "XSRF-TOKEN": str(token),
                           },
                           data=json.dumps(subUser)
                           )

    print(result.text)


addSubUser({
    "name": "subUser3",
    "password": "1tretrtrere",
    "concurrencyCount": 200000,
    "allowedPorts": ["25565"],
    "transferLimit": 1000000,
},TOKEN)