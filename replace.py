import re

with open('lib/core/data/lecture_notes.dart', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("Zor Kavram Örneği:", "Örnekle Pekiştirelim:")
content = content.replace("Örnek:", "Örnekle Pekiştirelim:")
content = content.replace("Örnek (Blacklist):", "Örnekle Pekiştirelim (Blacklist):")
content = content.replace("Örnek (Repeat Guest):", "Örnekle Pekiştirelim (Repeat Guest):")
content = content.replace("Örnek (Oda No Saklama):", "Örnekle Pekiştirelim (Oda No Saklama):")

with open('lib/core/data/lecture_notes.dart', 'w', encoding='utf-8') as f:
    f.write(content)
