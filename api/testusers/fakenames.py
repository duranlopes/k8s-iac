import requests
import json
import names
import asyncio
import os
import time

API_HOST=os.environ['API_HOST']
API_PORT=os.environ['API_PORT']
API_ENDPOINT=os.environ['API_ENDPOINT']

url = "http://{}:{}/{}".format(API_HOST, API_PORT , API_ENDPOINT)

async def main():
    while True:
        name = names.get_full_name()
        payload = {"email":name,"password":"pass123"}
        headers = {'Content-Type': 'application/json'}
        datajson = json.dumps(payload)
        try:
            response = requests.request("POST", url, data=datajson, headers=headers)
            print(response.text)
        except:
            time.sleep(5)


loop = asyncio.get_event_loop()  
loop.run_until_complete(main()) 