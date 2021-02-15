import requests

url = "http://simplecrud.com/users"

payload = '{"email":"fabio5","password":"ifood"}'
headers = {'Content-Type': 'application/json'}

response = requests.request("POST", url, data=payload, headers=headers)

print(response.text)

#def insert_users()