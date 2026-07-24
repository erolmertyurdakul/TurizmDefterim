import json

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\mismatches_report.json", "r", encoding="utf-8") as f:
    data = json.load(f)

with open(r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\scratch\mismatches_report_clean.txt", "w", encoding="utf-8") as out:
    out.write(f"Total suspects: {len(data)}\n\n")
    for idx, item in enumerate(data):
        out.write(f"[{idx+1}] File: {item['file']}\n")
        out.write(f"    Name:  {item['name']}\n")
        out.write(f"    Desc:  {item['desc'][:120]}...\n")
        out.write(f"    Ex:    {item['example']}\n")
        out.write(f"    Other: {item['mismatched_with']}\n")
        out.write("-" * 60 + "\n")

print("Report saved to scratch/mismatches_report_clean.txt")
