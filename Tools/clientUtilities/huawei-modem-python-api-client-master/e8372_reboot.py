from pprint import pprint
import sys
from huaweisms.api import user, sms,device
from huaweisms.api.common import ApiCtx


# BEFORE running, do MAKE SURE heaweisms.api.config has the CORRECT VALUES for your MODEM

def get_session(username, password,modem_host=None):
    return user.quick_login(username, password,modem_host=modem_host)

def valid_context(ctx):
    # type: (ApiCtx) -> bool
    sl = user.state_login(ctx)
    if sl['type'] == 'response' and sl['response']['State'] != -1:
        return True
    return False


pCnt = len(sys.argv)

if pCnt != 4:
    print("Invalid parameter")
else:
    userName, pwd, infIP = sys.argv[1:4]
    gwArr = infIP.split(".")
    gwArr[3] = "1"
    gateway = "."
    gateway = gateway.join(gwArr)
    print(gateway)
    ctx = get_session(userName, pwd, gateway)
    validCtx = valid_context(ctx)
    if not validCtx:
        print("Invalid context")
    else:
        print("Valid context")
