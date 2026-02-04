import 'dart:io';
import 'dart:convert';

void main() {
  final Directory libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('Error: lib directory not found.');
    return;
  }

  print('Starting integrity check on lib/ directory...');
  int checkedCount = 0;
  List<String> corruptedFiles = [];
  List<String> mojibakeFiles = [];

  libDir.listSync(recursive: true, followLinks: false).forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      checkedCount++;
      try {
        final content = entity.readAsStringSync(encoding: utf8);
        
        // 1. Check for Replacement Character (indicating previous bad decode)
        if (content.contains('\uFFFD')) {
          mojibakeFiles.add(entity.path);
          print('Warning: Found Replacement Character in ${entity.path}');
        }
        
        // 2. Check for common Double Encoding patterns (e.g., Ã« which is 'ë' in Latin-1)
        // '가' (AC00) -> EAB080 -> ÃªÂ°â‚¬ or similar.
        // Simple heuristic: specific sequences that are rare in code but common in mojibake.
        if (content.contains('Ã«') || content.contains('Ã©') || content.contains('Ã±')) {
           // This is weak, but might catch some. Not flagging as definitive error, just warning.
           // print('Info: Possible double-encoding sequence in ${entity.path}');
        }

      } catch (e) {
        corruptedFiles.add(entity.path);
        print('Error: Failed to read ${entity.path} as UTF-8. Error: $e');
      }
    }
  });

  print('\n--- Integirty Check Complete ---');
  print('Checked $checkedCount files.');
  
  if (corruptedFiles.isEmpty && mojibakeFiles.isEmpty) {
    print('✅ No integrity issues found. All files are valid UTF-8.');
  } else {
    if (corruptedFiles.isNotEmpty) {
      print('❌ Corrupted Files (Not UTF-8):');
      corruptedFiles.forEach((path) => print('  - $path'));
    }
    if (mojibakeFiles.isNotEmpty) {
      print('⚠️ Files with Replacement Characters (previous corruption):');
      mojibakeFiles.forEach((path) => print('  - $path'));
    }
  }
}
