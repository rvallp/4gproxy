import requests,json

BASE = "http://localhost:9081"
USERNAME = "admin"
PASSWORD = "admin"

TOKEN = ""

r = requests.session()
res = r.post(BASE + "/api/login", data={
    "username": USERNAME,
    "password": PASSWORD
})
sb = json.loads(res.text)
TOKEN = sb['token']
print(TOKEN)

def queryProxies(subUser, token):
    result = r.get(BASE + "/token/api/v2/proxy/http",
                           headers={
                               "content-type": "application/json",
                               "XSRF-TOKEN": str(token),
                           },
                           data=json.dumps(subUser)
                           )

    print(result.text)


queryProxies({
    "page": 1,
    "size": 10,
},TOKEN)