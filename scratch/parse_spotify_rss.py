import urllib.request
import xml.etree.ElementTree as ET
import os

url = "https://anchor.fm/s/114a64400/podcast/rss"
headers = {'User-Agent': 'Mozilla/5.0'}

print("Fetching RSS feed...")
req = urllib.request.Request(url, headers=headers)
try:
    with urllib.request.urlopen(req) as response:
        xml_data = response.read()
    print("RSS Feed fetched successfully. Parsing...")
    
    root = ET.fromstring(xml_data)
    items = root.findall('.//item')
    print(f"Found {len(items)} episodes in feed.\n")
    
    for idx, item in enumerate(items):
        title_elem = item.find('title')
        title = title_elem.text if title_elem is not None else "No Title"
        
        enclosure = item.find('enclosure')
        enc_url = enclosure.get('url') if enclosure is not None else "No URL"
        
        print(f"[{idx+1}] Title: {title}")
        print(f"    URL: {enc_url}")
        print("-" * 50)
        
except Exception as e:
    print(f"Error: {e}")
