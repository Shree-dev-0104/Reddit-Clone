import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {

    void navigateToEditCommunity(BuildContext context) {
      Routemaster.of(context).push('/edit-community/$name');
    }
    
    return Scaffold(
      appBar: AppBar(),
      body:  Column(
        children: [
          const ListTile(
            leading: Icon(Icons.add_moderator),
            title: Text('Add Moderators'),
            // onTap: ()=> ,
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Community'),
            onTap: () => navigateToEditCommunity(context),
          ),
        ],
      ),
    );
  }
}
