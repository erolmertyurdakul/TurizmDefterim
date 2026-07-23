import urllib.request

urls = [
    "https://anchor.fm/s/114a64400/podcast/play/122579641/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-6-8%2Fd3e85500-c174-72b7-fbbe-91239cb13327.mp3",
    "https://d3ctxlq1ktw2nl.cloudfront.net/staging/2026-6-8/d3e85500-c174-72b7-fbbe-91239cb13327.mp3"
]

for url in urls:
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=5) as response:
            print(f"URL: {url[:60]}... -> Status Code: {response.getcode()}")
    except Exception as e:
        print(f"URL: {url[:60]}... -> ERROR: {e}")
