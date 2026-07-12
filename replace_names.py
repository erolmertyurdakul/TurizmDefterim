import os

file_path = r"lib/features/scenarios/data/scenario_database.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Replacements for Caner -> Erol
content = content.replace("meydancı Caner", "meydancı Erol")
content = content.replace("Meydancı Caner", "Meydancı Erol")

# Suffix corrections for Ahmet Usta -> Yelda Hanım
content = content.replace("Ahmet Usta'ya", "Yelda Hanım'a")
content = content.replace("Ahmet Usta", "Yelda Hanım")

# Replacements for Fatma Hanım -> Aylin Hanım
content = content.replace("Fatma Hanım", "Aylin Hanım")

# Replacements for Ayşe Hanım -> Aylin Hanım
content = content.replace("Ayşe Hanım", "Aylin Hanım")

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Replacement complete successfully!")
