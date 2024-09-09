import base64

import hashlib

import binascii

import json


def b64_sha256(data):
    # type: (str) -> str
    s256 = hashlib.sha256()
    s256.update(data.encode('utf-8'))
    dg = s256.digest()
    hs256 = binascii.hexlify(dg)
    t1 = base64.urlsafe_b64encode(hs256)
    return t1.decode('utf-8')

c = b64_sha256("admin")
print(c)