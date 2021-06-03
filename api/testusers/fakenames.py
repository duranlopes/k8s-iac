import requests
import json
import names
import asyncio
import os

API_HOST=os.environ['API_HOST']
API_PORT=os.environ['API_PORT']
API_ENDPOINT=os.environ['API_ENDPOINT']

url = "http://{}:{}/{}".format(API_HOST, API_PORT , API_ENDPOINT)

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