import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.name,
    required this.bio,
    required this.linkne,
  }) : super(key: key);

  final String name, bio,linkne;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: 
      CircleAvatar(
        backgroundImage: NetworkImage(linkne),
        backgroundColor: Colors.white24,
      ),

      title: Text(
        name,
        style: const TextStyle(color: Colors.white,fontSize: 12),
      ),
      subtitle: Text(
        bio,
        style: const TextStyle(color: Colors.white70,fontSize: 10),
      ),
    );
  }
}
