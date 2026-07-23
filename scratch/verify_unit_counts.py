import os, re, json

# Let's inspect all notes files and parse allCoursesNotes mapping logic
courses_dir = r"c:\Erol_Mobil_Gelistirme\TurizmAkademi\lib\core\data"

# Let's load lecture_notes.dart and all imported files
main_notes_file = os.path.join(courses_dir, "lecture_notes.dart")
with open(main_notes_file, 'r', encoding='utf-8') as f:
    main_content = f.read()

# Let's list all dart files in courses/
courses_subdir = os.path.join(courses_dir, "courses")
course_files = [os.path.join(courses_subdir, f) for f in os.listdir(courses_subdir) if f.endswith(".dart")]
course_files.append(main_notes_file)

total_units_checked = 0
total_notes_counted = 0
total_cards_counted = 0

print("=== VERIFYING UNIT CARD & NOTE COUNTS ACROSS ALL COURSES ===")

for filepath in course_files:
    fname = os.path.basename(filepath)
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract unit blocks by "learningUnit":
    blocks = re.split(r'("learningUnit":\s*"[^"]+")', content)
    if len(blocks) < 2:
        continue
    
    print(f"\n[FILE] {fname}")
    # Process blocks in pairs
    for i in range(1, len(blocks), 2):
        unit_header = blocks[i]
        unit_body = blocks[i+1] if i+1 < len(blocks) else ""
        
        unit_title_m = re.search(r'"title":\s*"([^"]+)"', unit_body)
        unit_title = unit_title_m.group(1) if unit_title_m else "Unit"
        
        unit_num_m = re.search(r'"learningUnit":\s*"([^"]+)"', unit_header)
        unit_num = unit_num_m.group(1) if unit_num_m else f"Unit {(i//2)+1}"
        
        # Calculate noteCount (number of "tag": )
        tags = re.findall(r'"tag":\s*"([^"]+)"', unit_body)
        note_count = len(tags)
        
        # Calculate cardCount (number of "name": inside definitions)
        # Note: each "name": in definitions represents a card/term
        names = re.findall(r'"name":\s*"([^"]+)"', unit_body)
        card_count = len(names)
        
        total_units_checked += 1
        total_notes_counted += note_count
        total_cards_counted += card_count
        
        print(f"  - Unit: ({unit_title[:30]}...): {note_count} Ders Notu | {card_count} Kart")

print("\n==========================================")
print(f"SUMMARY: Verified {total_units_checked} Learning Units in total.")
print(f"Total Ders Notu: {total_notes_counted}")
print(f"Total Kart: {total_cards_counted}")
print("==========================================")
