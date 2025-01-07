import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/joke_card.dart';
import 'favorite_jokes_screen.dart';
import 'jokes_by_type_screen.dart';
import 'random_joke_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> jokeTypes;

  @override
  void initState() {
    super.initState();
    jokeTypes = ApiService.getJokeTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Joke Types"),
        actions: [
          IconButton(
            icon: Icon(Icons.casino),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomJokeScreen()),
              );
            },
          ),


        ],
      ),
      body: FutureBuilder<List<String>>(
        future: jokeTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return JokeCard(
                  type: snapshot.data![index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JokesByTypeScreen(
                          type: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
