import subprocess

try:
    status_out = subprocess.run(["git", "status"], capture_output=True, text=True)
    log_out = subprocess.run(["git", "log", "-n", "10", "--oneline"], capture_output=True, text=True)
    
    with open("git_info.txt", "w", encoding="utf-8") as f:
        f.write("=== GIT STATUS ===\n")
        f.write(status_out.stdout)
        f.write("\n=== GIT ERR ===\n")
        f.write(status_out.stderr)
        f.write("\n=== GIT LOG ===\n")
        f.write(log_out.stdout)
        f.write("\n=== GIT LOG ERR ===\n")
        f.write(log_out.stderr)
    print("Done")
except Exception as e:
    print(f"Error: {e}")
