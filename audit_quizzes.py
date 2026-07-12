# -*- coding: utf-8 -*-
import re
import os

QUIZ_FILE = "lib/core/data/quiz_data.dart"

def main():
    if not os.path.exists(QUIZ_FILE):
        print(f"Error: {QUIZ_FILE} does not exist.")
        return
        
    with open(QUIZ_FILE, 'r', encoding='utf-8') as f:
        content = f.read()

    # Match QuizQuestion(id: '...', courseId: '...', unitIndex: ...)
    pattern = r"QuizQuestion\(\s*id:\s*'([^']+)',\s*courseId:\s*'([^']+)',\s*unitIndex:\s*(\d+)"
    matches = re.findall(pattern, content)

    counts = {}
    for qid, course_id, unit_idx in matches:
        unit_idx = int(unit_idx)
        counts.setdefault(course_id, {}).setdefault(unit_idx, 0)
        counts[course_id][unit_idx] += 1

    print("--- QUESTION COUNTS BY COURSE AND UNIT ---")
    total_q = 0
    for course_id, units in sorted(counts.items()):
        print(f"{course_id}:")
        course_total = 0
        for unit_idx, count in sorted(units.items()):
            print(f"  Unit {unit_idx}: {count} questions")
            course_total += count
            total_q += count
        print(f"  Total for {course_id}: {course_total} questions\n")
    print(f"Grand Total: {total_q} questions")

if __name__ == "__main__":
    main()
