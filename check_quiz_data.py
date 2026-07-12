import re
from collections import defaultdict

file_path = r'lib\core\data\quiz_data.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# QuizQuestion(id: '...', courseId: '...', unitIndex: ...,
pattern = r"QuizQuestion\(\s*id:\s*'([^']*)',\s*courseId:\s*'([^']*)',\s*unitIndex:\s*(\d+),"
matches = re.findall(pattern, content)

counts = defaultdict(lambda: defaultdict(int))
for q_id, course_id, unit_idx in matches:
    counts[course_id][int(unit_idx)] += 1

print("--- Quiz Data Summary ---")
for course_id, units in sorted(counts.items()):
    total = sum(units.values())
    print(f"Course: {course_id} (Total: {total})")
    for unit_idx, count in sorted(units.items()):
        print(f"  Unit {unit_idx}: {count} questions")
