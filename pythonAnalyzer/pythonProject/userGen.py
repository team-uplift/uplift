import requests
import json
import uuid

url = 'http://localhost:8080/uplift/users'

userType = "recipient"
for response_id in range(1,101):
    userJson={
        "cognitoId": str(uuid.uuid4()),
        "email": "als5289@g.harvard.edu",
        "recipient": True,
        "recipientData": {
            "firstName": userType,
            "lastName": str(response_id),
            "lastAboutMe": "Examination.",
            "lastReasonForHelp": "Examination.",
            "nickname": "Examination",
            "formQuestions": []
        }
    }

    headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
    response = requests.post(url, headers=headers, data=json.dumps(userJson))
    print(f"Response ID {response_id}: Status Code {response.status_code}, Response: {response.text}")

# userType = "black"
# for response_id in range(1,26):
#     userJson={
#         "cognitoId": str(uuid.uuid4()),
#         "email": "als5289@g.harvard.edu",
#         "recipient": True,
#         "recipientData": {
#             "firstName": userType,
#             "lastName": str(response_id),
#             "lastAboutMe": "Examination.",
#             "lastReasonForHelp": "Examination.",
#             "nickname": "Examination",
#             "incomeLastVerified": "2025-04-26 22:03:26.404",
#             "formQuestions": []
#         }
#     }
#
#     headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
#     response = requests.post(url, headers=headers, data=json.dumps(userJson))
#     print(f"Response ID {response_id}: Status Code {response.status_code}, Response: {response.text}")
#
# userType = "asian/pacific islander"
# for response_id in range(1,26):
#     userJson={
#         "cognitoId": str(uuid.uuid4()),
#         "email": "als5289@g.harvard.edu",
#         "recipient": True,
#         "recipientData": {
#             "firstName": userType,
#             "lastName": str(response_id),
#             "lastAboutMe": "Examination.",
#             "lastReasonForHelp": "Examination.",
#             "nickname": "Examination",
#             "formQuestions": []
#         }
#     }
#
#     headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
#     response = requests.post(url, headers=headers, data=json.dumps(userJson))
#     print(f"Response ID {response_id}: Status Code {response.status_code}, Response: {response.text}")
#
# userType = "white"
# for response_id in range(1,26):
#     userJson={
#         "cognitoId": str(uuid.uuid4()),
#         "email": "als5289@g.harvard.edu",
#         "recipient": True,
#         "recipientData": {
#             "firstName": userType,
#             "lastName": str(response_id),
#             "lastAboutMe": "Examination.",
#             "lastReasonForHelp": "Examination.",
#             "nickname": "Examination",
#             "formQuestions": []
#         }
#     }
#
#     headers = {'Content-Type': 'application/json', 'Accept': 'application/json'}
#     response = requests.post(url, headers=headers, data=json.dumps(userJson))
#     print(f"Response ID {response_id}: Status Code {response.status_code}, Response: {response.text}")