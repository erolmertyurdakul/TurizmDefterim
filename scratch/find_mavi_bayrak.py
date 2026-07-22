import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('lib/core/data/courses/9_mesleki_gelisim_notes.dart', 'r', encoding='utf-8') as f:
    text = f.read()

pos = text.find("Mavi Bayrak")
if pos != -1:
    print(text[pos-200:pos+400])
