import subprocess
res = subprocess.run(["flutter", "doctor"], capture_output=True, text=True)
with open("doc_out.txt", "w", encoding="utf-8") as f:
    f.write(res.stdout + "\n" + res.stderr)
print("Done")
