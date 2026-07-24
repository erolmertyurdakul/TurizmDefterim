import sys

for pkg in ["pypdf", "fitz", "pdfplumber", "pypdf2"]:
    try:
        mod = __import__(pkg)
        print(f"[{pkg}] Available!")
    except ImportError:
        print(f"[{pkg}] NOT available.")
