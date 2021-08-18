#!/usr/local/bin/python3
"""
You can also use this online OTP timed generator.
https://codepen.io/Sudeepto/full/JbLbxe

import pyotp

>>> pyotp.random_base32()
'6FLOGFWEHC66YRPM'
>>> pyotp.TOTP('6FLOGFWEHC66YRPM').now()
'423907'
"""

import pyotp
secret = pyotp.random_base32()
otp = pyotp.TOTP('6FLOGFWEHC66YRPM').now()
print(secret)
print(otp)
