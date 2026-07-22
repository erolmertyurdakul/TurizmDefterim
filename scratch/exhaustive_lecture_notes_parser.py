import os
import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

courses_dir = r'lib/core/data/courses'
lecture_notes_file = r'lib/core/data/lecture_notes.dart'
pdf_dir = "scratch/pdf_texts"

# Load full text corpus of all 16 MEB textbooks
pdf_corpus = ""
for fname in os.listdir(pdf_dir):
    if fname.endswith('.txt'):
        with open(os.path.join(pdf_dir, fname), 'r', encoding='utf-8') as pf:
            pdf_corpus += "\n" + pf.read().lower()

all_course_files = []
if os.path.exists(courses_dir):
    for f in os.listdir(courses_dir):
        if f.endswith('.dart'):
            all_course_files.append(os.path.join(courses_dir, f))
if os.path.exists(lecture_notes_file):
    all_course_files.append(lecture_notes_file)

print(f"Total lecture notes Dart files found: {len(all_course_files)}")

total_card_blocks = 0
total_definitions = 0
total_examples = 0

matched_items = 0
unmatched_items = []

for fpath in all_course_files:
    with open(fpath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract all name/word/term definitions
    names = re.findall(r'"name":\s*"([^"]+)"', content)
    names += re.findall(r"'name':\s*'([^']+)'", content)
    names += re.findall(r'"title":\s*"([^"]+)"', content)
    
    descs = re.findall(r'"desc":\s*"([^"]+)"', content)
    examples = re.findall(r'"examples":\s*\[(.*?)\]', content, re.DOTALL)
    
    total_card_blocks += len(names)
    total_definitions += len(descs)
    total_examples += len(examples)
    
    for n in names:
        stems = [w[:4].lower() for w in re.split(r'\W+', n) if len(w) >= 3]
        found = any(st in pdf_corpus for st in stems) if stems else True
        if found:
            matched_items += 1
        else:
            unmatched_items.append((n, fpath))

print("\n==================================================")
print("EXHAUSTIVE LECTURE NOTES AUDIT RESULTS")
print("==================================================")
print(f"Total Course Files Audited: {len(all_course_files)}")
print(f"Total Card / Section Titles Parsed: {total_card_blocks}")
print(f"Total Pedagogical Definitions Parsed: {total_definitions}")
print(f"Total Example Blocks Parsed: {total_examples}")
print(f"Total MEB Textbook Matched Items: {matched_items}")
print(f"Total Unmatched / Modified Items: {len(unmatched_items)}")

if unmatched_items:
    print("\nUnmatched items list:")
    for um_name, um_file in unmatched_items:
        print(f" - [{os.path.basename(um_file)}]: {um_name}")
