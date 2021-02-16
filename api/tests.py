import requests
import json
import names

#url = "http://localhost:30000/users"
url = "http://192.168.125.134:30000/users"


while True:
    name = names.get_full_name()
    payload = {"email":name,"password":"ifood"}
    headers = {'Content-Type': 'application/json'}
    datajson = json.dumps(payload)
    try:
        response = requests.request("POST", url, data=datajson, headers=headers)
        print(response.text)
    except:
        response = requests.request("GET", url, data=datajson, headers=headers)
        print(response.text)
    #print(response.text)

