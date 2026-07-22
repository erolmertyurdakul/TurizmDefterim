import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('scratch/unit1_9th_extracted.txt', 'r', encoding='utf-8') as f:
    text = f.read()

# Print lines that look like main concepts or bold headers
lines = text.split('\n')
for line in lines:
    line_s = line.strip()
    if len(line_s) > 3 and line_s.isupper() and not 'PAGE' in line_s:
        print(line_s)
