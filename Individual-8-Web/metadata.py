import requests

IMDS = "http://169.254.169.254/latest"
TOKEN_URL = f"{IMDS}/api/token"
META_URL = f"{IMDS}/meta-data"

token = requests.put(
    TOKEN_URL,
    headers={"X-aws-ec2-metadata-token-ttl-seconds": "21600"},
    timeout=2,
).text

headers = {"X-aws-ec2-metadata-token": token}

def get(path):
    return requests.get(f"{META_URL}/{path}", headers=headers, timeout=2).text

instance_id = get("instance-id")
instance_type = get("instance-type")
az = get("placement/availability-zone")
private_ip = get("local-ipv4")

html = f"""
<html>
  <body>
    <h1>EC2 Metadata</h1>
    <ul>
      <li>Instance ID: {instance_id}</li>
      <li>Instance Type: {instance_type}</li>
      <li>Availability Zone: {az}</li>
      <li>Private IP: {private_ip}</li>
    </ul>
  </body>
</html>
"""

with open("/var/www/html/index.html", "w") as f:
    f.write(html)
