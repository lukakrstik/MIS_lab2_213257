import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/joke.dart';

class JokesByTypeScreen extends StatefulWidget {
  final String type;

  JokesByTypeScreen({required this.type});

  @override
  _JokesByTypeScreenState createState() => _JokesByTypeScreenState();
}

class _JokesByTypeScreenState extends State<JokesByTypeScreen> {
  List<Joke> jokes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchJokes();
  }

  Future<void> _fetchJokes() async {
    try {
      final fetchedJokes = await ApiService.getJokesByType(widget.type);
      setState(() {
        jokes = fetchedJokes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.type} Jokes'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.type} Jokes'),
        ),
        body: Center(child: Text('Error: $errorMessage')),
      );
    }

    if (jokes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.type} Jokes'),
        ),
        body: Center(child: Text('No jokes found for this type.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type} Jokes'),
      ),
      body: ListView.builder(
        itemCount: jokes.length,
        itemBuilder: (context, index) {
          final joke = jokes[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text(joke.setup),
                subtitle: Text(joke.punchline),
                trailing: IconButton(
                  icon: Icon(
                    joke.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: joke.isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      joke.isFavorite = !joke.isFavorite;
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
