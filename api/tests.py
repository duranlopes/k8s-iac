import requests
import json
import names
import asyncio

url = "http://10.99.232.63/users"

async def main():
    while True:
        name = names.get_full_name()
        payload = {"email":name,"password":"ifood"}
        headers = {'Content-Type': 'application/json'}
        datajson = json.dumps(payload)
        try:
            response = requests.request("POST", url, data=datajson, headers=headers)
            print(response.text)
        except:
            response = requests.request("GET", url+"?skip=0&limit=100000", data=datajson, headers=headers)
            print(response.text)

loop = asyncio.get_event_loop()  
loop.run_until_complete(main()) 