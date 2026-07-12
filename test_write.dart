import 'dart:io';

void main() {
  print("Current CWD: ${Directory.current.path}");
  final file = File('assets/sounds/test_write.txt');
  file.writeAsStringSync("Hello!");
  print("File exists on disk: ${file.existsSync()}");
}
