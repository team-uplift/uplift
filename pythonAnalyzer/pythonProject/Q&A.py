import pandas as pd
import requests
import json

# Latino --------------------------
# Load CSV file
csv_file = 'latino_job_seekers_responses.csv'  # Replace with your CSV filename
df = pd.read_csv(csv_file)

# Group by response_id
grouped = df.groupby('response_id')

userId = 1

# Loop through each response group and send POST request
for response_id, group in grouped:
    url = 'http://localhost:8080/uplift/recipients/tagGeneration/' + str(userId)
    qa_list = []
    for _, row in group.iterrows():
        qa_list.append({
            "question": row['question'],
            "answer": row['answer']
        })

    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, headers=headers, data=json.dumps(qa_list))
    print(f"Response ID {response_id}: Status Code {response.status_code}, Response: {response.text}")
    userId += 1


# Black --------------------------
# Load CSV file
csv_file = 'black_job_seekers_responses.csv'  # Replace with your CSV filename
df2 = pd.read_csv(csv_file)

# Group by response_id
grouped = df2.groupby('response_id')

# Loop through each response group and send POST request
for response_id, group in grouped:
    url = 'http://localhost:8080/uplift/recipients/tagGeneration/' + str(userId)
    qa_list = []
    for _, row in group.iterrows():
        qa_list.append({
            "question": row['question'],
            "answer": row['answer']
        })

    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, headers=headers, data=json.dumps(qa_list))
    print(f"Response ID {response_id}: Status Code {response.status_code}, Response: {response.text}")
    userId += 1


# Asian --------------------------
# Load CSV file
csv_file = 'asian_pacific_islander_responses.csv'  # Replace with your CSV filename
df3 = pd.read_csv(csv_file)

# Group by response_id
grouped = df3.groupby('response_id')

# Loop through each response group and send POST request
for response_id, group in grouped:
    url = 'http://localhost:8080/uplift/recipients/tagGeneration/' + str(userId)
    qa_list = []
    for _, row in group.iterrows():
        qa_list.append({
            "question": row['question'],
            "answer": row['answer']
        })

    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, headers=headers, data=json.dumps(qa_list))
    print(f"Response ID {response_id}: Status Code {response.status_code}, Response: {response.text}")
    userId += 1

# White --------------------------
# Load CSV file
csv_file = 'white_job_seekers_responses.csv'  # Replace with your CSV filename
df4 = pd.read_csv(csv_file)

# Group by response_id
grouped = df4.groupby('response_id')

# Loop through each response group and send POST request
for response_id, group in grouped:
    url = 'http://localhost:8080/uplift/recipients/tagGeneration/' + str(userId)
    qa_list = []
    for _, row in group.iterrows():
        qa_list.append({
            "question": row['question'],
            "answer": row['answer']
        })

    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, headers=headers, data=json.dumps(qa_list))
    print(f"Response ID {response_id}: Status Code {response.status_code}, Response: {response.text}")
    userId += 1
