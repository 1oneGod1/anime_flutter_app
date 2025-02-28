import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Model untuk Anime
class Anime {
  final int id;
  final String title;
  final String imageUrl;
  final String synopsis;
  final List<String> genres;

  Anime({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.genres,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['image_url'],
      synopsis: json['synopsis'] ?? "No description available.",
      genres: (json['genres'] as List).map((g) => g['name'] as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'synopsis': synopsis,
      'genres': genres,
    };
  }
}

void main() {
  runApp(const AnimeApp());
}

class AnimeApp extends StatefulWidget {
  const AnimeApp({Key? key}) : super(key: key);

  @override
  State<AnimeApp> createState() => _AnimeAppState();
}

class _AnimeAppState extends State<AnimeApp> {
  List<Anime> popularAnime = [];
  List<Anime> upcomingAnime = [];
  List<Anime> seasonalAnime = [];
  List<Anime> favoriteAnime = [];
  String selectedGenre = "All";

  @override
  void initState() {
    super.initState();
    fetchAnime();
    loadFavorites();
  }

  Future<void> fetchAnime() async {
    final urls = {
      'popular': 'https://api.jikan.moe/v4/top/anime',
      'upcoming': 'https://api.jikan.moe/v4/seasons/upcoming',
      'seasonal': 'https://api.jikan.moe/v4/seasons/now',
    };

    try {
      final responses = await Future.wait(
        urls.values.map((url) => http.get(Uri.parse(url))),
      );
      if (responses.every((res) => res.statusCode == 200)) {
        setState(() {
          popularAnime =
              (jsonDecode(responses[0].body)['data'] as List)
                  .map((e) => Anime.fromJson(e))
                  .toList();
          upcomingAnime =
              (jsonDecode(responses[1].body)['data'] as List)
                  .map((e) => Anime.fromJson(e))
                  .toList();
          seasonalAnime =
              (jsonDecode(responses[2].body)['data'] as List)
                  .map((e) => Anime.fromJson(e))
                  .toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load anime: $e")));
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData = prefs.getStringList('favoriteAnime') ?? [];

    setState(() {
      favoriteAnime =
          favoriteData.map((data) => Anime.fromJson(jsonDecode(data))).toList();
    });
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData =
        favoriteAnime.map((anime) => jsonEncode(anime.toJson())).toList();
    await prefs.setStringList('favoriteAnime', favoriteData);
  }

  void toggleFavorite(Anime anime) {
    setState(() {
      if (favoriteAnime.any((fav) => fav.id == anime.id)) {
        favoriteAnime.removeWhere((fav) => fav.id == anime.id);
      } else {
        favoriteAnime.add(anime);
      }
    });
    saveFavorites();
  }

  List<Anime> getFilteredAnime(List<Anime> animeList) {
    if (selectedGenre == "All") return animeList;
    return animeList
        .where((anime) => anime.genres.contains(selectedGenre))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Anime List"),
          backgroundColor: Colors.redAccent,
        ),
        body: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.redAccent,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: "Popular"),
                  Tab(text: "Upcoming"),
                  Tab(text: "Seasonal"),
                  Tab(text: "Favorites"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: DropdownButton<String>(
                  value: selectedGenre,
                  onChanged: (value) => setState(() => selectedGenre = value!),
                  items:
                      [
                            "All",
                            "Action",
                            "Adventure",
                            "Comedy",
                            "Drama",
                            "Fantasy",
                            "Sci-Fi",
                          ]
                          .map(
                            (genre) => DropdownMenuItem(
                              value: genre,
                              child: Text(genre),
                            ),
                          )
                          .toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    AnimeList(
                      animes: getFilteredAnime(popularAnime),
                      onFavorite: toggleFavorite,
                      favorites: favoriteAnime,
                    ),
                    AnimeList(
                      animes: getFilteredAnime(upcomingAnime),
                      onFavorite: toggleFavorite,
                      favorites: favoriteAnime,
                    ),
                    AnimeList(
                      animes: getFilteredAnime(seasonalAnime),
                      onFavorite: toggleFavorite,
                      favorites: favoriteAnime,
                    ),
                    AnimeList(
                      animes: favoriteAnime,
                      onFavorite: toggleFavorite,
                      favorites: favoriteAnime,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimeList extends StatelessWidget {
  final List<Anime> animes;
  final Function(Anime) onFavorite;
  final List<Anime> favorites;

  const AnimeList({
    Key? key,
    required this.animes,
    required this.onFavorite,
    required this.favorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return animes.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: animes.length,
          itemBuilder: (context, index) {
            final anime = animes[index];
            final isFavorite = favorites.any((fav) => fav.id == anime.id);

            return ListTile(
              leading: Image.network(
                anime.imageUrl,
                width: 50,
                height: 70,
                fit: BoxFit.cover,
              ),
              title: Text(anime.title),
              subtitle: Text(anime.genres.join(", ")),
              trailing: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () => onFavorite(anime),
              ),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnimeDetail(anime: anime),
                    ),
                  ),
            );
          },
        );
  }
}

class AnimeDetail extends StatelessWidget {
  final Anime anime;

  const AnimeDetail({Key? key, required this.anime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(anime.title),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image.network(
              anime.imageUrl,
              width: 200,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(anime.synopsis, textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}
