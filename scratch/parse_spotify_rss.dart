import 'dart:io';
import 'dart:convert';
import 'package:xml/xml.dart'; // We can parse via simple string matching/xml if we don't have xml package.
// Let's write a parser using RegExp to avoid external package dependency, ensuring it runs out of the box with standard dart.

void main() async {
  final url = 'https://anchor.fm/s/114a64400/podcast/rss';
  print('Fetching RSS feed from $url...');
  try {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    request.headers.add('User-Agent', 'Mozilla/5.0');
    final response = await request.close();
    if (response.statusCode != 200) {
      print('Failed to load RSS feed: ${response.statusCode}');
      return;
    }
    
    final xmlContent = await response.transform(utf8.decoder).join();
    print('RSS feed fetched. Parsing episodes...');
    
    // Simple item splitting
    final itemRegex = RegExp(r'<item>(.*?)</item>', dotAll: true);
    final titleRegex = RegExp(r'<title><!\[CDATA\[(.*?)\]\]></title>', dotAll: true);
    final titleFallbackRegex = RegExp(r'<title>(.*?)</title>', dotAll: true);
    final enclosureRegex = RegExp(r'<enclosure\s+url="([^"]+)"', dotAll: true);
    
    final matches = itemRegex.allMatches(xmlContent).toList();
    print('Found ${matches.length} episodes.\n');
    
    for (var i = 0; i < matches.length; i++) {
      final itemContent = matches[i].group(1) ?? '';
      
      var title = '';
      final titleMatch = titleRegex.firstMatch(itemContent);
      if (titleMatch != null) {
        title = titleMatch.group(1) ?? '';
      } else {
        final titleFallback = titleFallbackRegex.firstMatch(itemContent);
        if (titleFallback != null) {
          title = titleFallback.group(1) ?? '';
        }
      }
      
      var encUrl = '';
      final encMatch = enclosureRegex.firstMatch(itemContent);
      if (encMatch != null) {
        encUrl = encMatch.group(1) ?? '';
      }
      
      print('[${i + 1}] Title: ${title.trim()}');
      print('    URL: $encUrl');
      print('-' * 60);
    }
  } catch (e) {
    print('Error: $e');
  }
}
