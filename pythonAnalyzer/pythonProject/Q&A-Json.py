import requests
import json

file_path = 'financial_aid_q_and_a.json'

# Open and load the JSON data
with open(file_path, 'r') as file:
    data = json.load(file)

    for userId in range(1,101):
        url = 'http://localhost:8080/uplift/recipients/tagGeneration/' + str(userId)
        index = userId - 1
        body = data[index]
        headers = {'Content-Type': 'application/json'}
        response = requests.post(url, headers=headers, data=json.dumps(body))
        print(f"Response ID {userId}: Status Code {response.status_code}, Response: {response.text}")
        userId += 1

