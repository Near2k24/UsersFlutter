import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user.dart';

class UserDetailsScreen extends StatelessWidget {
  final int userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<User>(
          future: ApiService.fetchUser(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            } else {
              return const Text('User Details');
            }
          },
        ),
      ),
      body: FutureBuilder<User>(
        future: ApiService.fetchUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            User user = snapshot.data!;
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${user.name}'),
                          Text('Username: ${user.username}'),
                          Text('Email: ${user.email}'),
                          Text('Phone: ${user.phone}'),
                          Text('Website: ${user.website}'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Address:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('Street: ${user.address.street}'),
                                Text('Suite: ${user.address.suite}'),
                                Text('City: ${user.address.city}'),
                                Text('Zipcode: ${user.address.zipcode}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Company:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('Name: ${user.company.name}'),
                                Text('Catch Phrase: ${user.company.catchPhrase}'),
                                Text('BS: ${user.company.bs}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No user found'));
          }
        },
      ),
    );
  }
}
