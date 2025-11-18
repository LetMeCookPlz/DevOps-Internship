# lambda_function.py
import os
import urllib3
import json

def lambda_handler(event, context):
    http = urllib3.PoolManager()
    
    websites = [
        os.environ.get('EC2_URL', 'EC2_URL_NOT_SET'),
        os.environ.get('S3_URL', 'S3_URL_NOT_SET'),
        os.environ.get('ECS_URL', 'ECS_URL_NOT_SET')
    ]
    
    results = []
    
    for website in websites:
        if 'NOT_SET' in website:
            results.append(f"[✘] {website} - URL NOT CONFIGURED")
            continue
            
        try:
            response = http.request('GET', website, timeout=10, retries=False)
            if response.status == 200:
                results.append(f"[✔] {website} - UP (Status: {response.status})")
            else:
                results.append(f"[✘] {website} - DOWN (Status: {response.status})")
        except Exception as e:
            results.append(f"[✘] {website} - ERROR: {str(e)}")
    
    message = "Website Health Check Results:\n\n" + "\n".join(results)
    print(message)
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': message,
            'results': results
        })
    }