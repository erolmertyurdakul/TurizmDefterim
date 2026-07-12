import 'dart:io';

void main() {
  final srcDir = r'C:\Users\erolm\.gemini\antigravity-ide\brain\ec6a3250-8d6f-449a-9f79-2b68d47f48ec';
  final destDir = r'c:\Users\erolm\Desktop\TurizmAkademi\assets\images';

  final mapping = {
    'bellboy_illustration_1781916206873.png': 'bellboy.png',
    'receptionist_illustration_1781916218827.png': 'receptionist.png',
    'reservation_illustration_1781916228726.png': 'reservation.png',
    'meydanci_illustration_1781916241178.png': 'meydanci.png',
    'maid_illustration_1781916253595.png': 'maid.png',
    'laundry_illustration_1781916265460.png': 'laundry.png',
  };

  for (final entry in mapping.entries) {
    final srcFile = File('$srcDir\\${entry.key}');
    final destFile = File('$destDir\\${entry.value}');
    print('Copying ${srcFile.path} -> ${destFile.path}');
    try {
      if (srcFile.existsSync()) {
        srcFile.copySync(destFile.path);
        print('Success');
      } else {
        print('Source file does not exist!');
      }
    } catch (e) {
      print('Failed: $e');
    }
  }
}
