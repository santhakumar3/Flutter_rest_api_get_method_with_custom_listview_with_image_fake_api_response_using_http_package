import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Person> people = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      print(response.body);
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        people = data.map((json) => Person.fromJson(json)).toList();
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Demo'),
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          final person = people[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(person.thumbnailUrl),
            ),
            title: Text(
              person.title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email: ${person.url}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Person {
  final int albumId;
  final int id;
  final String thumbnailUrl;
  final String url;
  final String title;

  Person({
    required this.albumId,
    required this.id,
    required this.thumbnailUrl,
    required this.url,
    required this.title,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      albumId: json['albumId'],
      id: json['id'],
      thumbnailUrl: json['thumbnailUrl'],
      url: json['url'],
      title: json['title'],
    );
  }
}
