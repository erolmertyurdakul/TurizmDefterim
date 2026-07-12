import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Read Git History of main_shell.dart', () async {
    final result = await Process.run('git', [
      'log',
      '-p',
      '-n',
      '10',
      'lib/features/shell/main_shell.dart'
    ]);
    
    final file = File('temp_git_log.txt');
    await file.writeAsString(
      '=== STDOUT ===\n${result.stdout}\n=== STDERR ===\n${result.stderr}'
    );
    print('Git history written to temp_git_log.txt');
  });
}
