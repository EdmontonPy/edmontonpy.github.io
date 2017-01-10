print()

import dateutil
import requests

sesh = requests.session()
sesh.auth = ('username', 'password')
response = sesh.get('http://httpbin.org/get')

print('I did something great for my second client with requests and dateutil!\n')
