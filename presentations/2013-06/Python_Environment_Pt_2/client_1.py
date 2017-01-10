print()


import requests

sesh = requests.session(auth=('username', 'password'))

response = sesh.get('http://httpbin.org/get')

print('I did something great for my first client with requests!\n')
