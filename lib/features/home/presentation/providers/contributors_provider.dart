import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Contributor {
  const Contributor({
    required this.login,
    required this.avatarUrl,
    required this.profileUrl,
    required this.contributions,
  });

  final String login;
  final String avatarUrl;
  final String profileUrl;
  final int contributions;
}

// Known bot accounts to filter out
const Set<String> _botAccounts = {
  'dependabot',
  'dependabot[bot]',
  'renovate',
  'renovate[bot]',
  'github-actions',
  'github-actions[bot]',
  'bors',
  'bors[bot]',
  'imgbot',
  'imgbot[bot]',
  'stale',
  'stale[bot]',
  'allcontributors',
  'allcontributors[bot]',
  'semantic-release-bot',
  'semantic-release-bot[bot]',
  'netlify',
  'netlify[bot]',
  'vercel',
  'vercel[bot]',
};

final contributorsProvider = FutureProvider<List<Contributor>>((ref) async {
  const cacheKey = 'github_contributors_cache';
  const contributorsUrl = 'https://api.github.com/repos/r4khul/unfilter/contributors';
  const timeoutDuration = Duration(seconds: 5);

  final prefs = await SharedPreferences.getInstance();

  try {
    final response = await http
        .get(
          Uri.parse(contributorsUrl),
          headers: {
            'Accept': 'application/vnd.github.v3+json',
          },
        )
        .timeout(timeoutDuration);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final contributors = <Contributor>[];

      for (final item in data) {
        final login = (item['login'] as String?)?.trim() ?? '';
        
        // Skip bot accounts
        if (_botAccounts.contains(login.toLowerCase()) || 
            login.toLowerCase().contains('[bot]') ||
            login.toLowerCase().contains('bot')) {
          continue;
        }

        final avatarUrl = item['avatar_url'] as String? ?? '';
        final htmlUrl = item['html_url'] as String? ?? '';
        final contributions = item['contributions'] as int? ?? 0;

        if (login.isNotEmpty && avatarUrl.isNotEmpty) {
          contributors.add(Contributor(
            login: login,
            avatarUrl: avatarUrl,
            profileUrl: htmlUrl,
            contributions: contributions,
          ));
        }
      }

      // Sort by contributions (descending)
      contributors.sort((a, b) => b.contributions.compareTo(a.contributions));

      // Cache the data
      final cacheData = contributors
          .map((c) => {
                'login': c.login,
                'avatarUrl': c.avatarUrl,
                'profileUrl': c.profileUrl,
                'contributions': c.contributions,
              })
          .toList();
      await prefs.setString(cacheKey, json.encode(cacheData));

      return contributors;
    } else {
      // Try to load from cache
      final cachedString = prefs.getString(cacheKey);
      if (cachedString != null) {
        final List<dynamic> cached = json.decode(cachedString);
        return cached
            .map((item) => Contributor(
                  login: item['login'],
                  avatarUrl: item['avatarUrl'],
                  profileUrl: item['profileUrl'],
                  contributions: item['contributions'],
                ))
            .toList();
      }
      return const <Contributor>[];
    }
  } catch (e) {
    // Try to load from cache on error
    final cachedString = prefs.getString(cacheKey);
    if (cachedString != null) {
      final List<dynamic> cached = json.decode(cachedString);
      return cached
          .map((item) => Contributor(
                login: item['login'],
                avatarUrl: item['avatarUrl'],
                profileUrl: item['profileUrl'],
                contributions: item['contributions'],
              ))
          .toList();
    }
    return const <Contributor>[];
  }
});
