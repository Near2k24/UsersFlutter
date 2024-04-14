import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'user.dart';
import 'user_details_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List App',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.purple,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> futureUsers;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Cargar la preferencia del modo oscuro o claro al iniciar la pantalla
    loadDarkModePreference();
    futureUsers = ApiService.fetchUsers();
  }

  Future<void> loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> toggleDarkModePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List App',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light().copyWith(primaryColor: Colors.purple),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('User List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.lightbulb),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                  toggleDarkModePreference(isDarkMode); // Guardar la preferencia del usuario
                });
              },
            ),
          ],
        ),
        body: FutureBuilder<List<User>>(
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  User user = snapshot.data![index];
                  final random = Random();
                  final colors = [Colors.yellow[700], Colors.blue[700], Colors.purple[700], Colors.green[700]];
                  final cardColor = colors[random.nextInt(colors.length)];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsScreen(userId: user.id),
                        ),
                      );
                    },
                    child: Card(
                      color: cardColor?.withOpacity(0.7),
                      margin: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              user.email,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              user.website,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No users found'));
            }
          },
        ),
      ),
    );
  }
}
