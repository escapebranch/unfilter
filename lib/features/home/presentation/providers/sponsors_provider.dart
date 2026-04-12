import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class SponsorProfile {
  const SponsorProfile({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.profileUrl,
  });

  final String login;
  final String name;
  final String avatarUrl;
  final String profileUrl;
}

// Public sponsor handles shown in the app.
// Add GitHub usernames here when sponsors opt in to be highlighted.
const List<String> kPublicSponsorUsernames = <String>[];

final sponsorsProvider = FutureProvider<List<SponsorProfile>>((ref) async {
  if (kPublicSponsorUsernames.isEmpty) {
    return const <SponsorProfile>[];
  }

  final client = http.Client();

  try {
    final futures = kPublicSponsorUsernames.map((username) async {
      final uri = Uri.parse('https://api.github.com/users/$username');
      final response = await client
          .get(uri)
          .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final login = (data['login'] as String?)?.trim();
      final avatarUrl = (data['avatar_url'] as String?)?.trim();
      final htmlUrl = (data['html_url'] as String?)?.trim();

      if (login == null || avatarUrl == null || htmlUrl == null) {
        return null;
      }

      final fallbackName = login;
      final displayName = (data['name'] as String?)?.trim();

      return SponsorProfile(
        login: login,
        name: (displayName == null || displayName.isEmpty)
            ? fallbackName
            : displayName,
        avatarUrl: avatarUrl,
        profileUrl: htmlUrl,
      );
    });

    final sponsors = await Future.wait(futures);
    final result = sponsors.whereType<SponsorProfile>().toList();
    result.sort(
      (a, b) => a.login.toLowerCase().compareTo(b.login.toLowerCase()),
    );

    return result;
  } finally {
    client.close();
  }
});
