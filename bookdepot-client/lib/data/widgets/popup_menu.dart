import 'package:flutter/material.dart';

enum MenuAction { edit, share, delete }

class BookEditMenu extends StatelessWidget {
  const BookEditMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Edit Menu'),
        actions: [
          PopupMenuButton<MenuAction>(
            icon: const Icon(Icons.more_vert),
            onSelected: (MenuAction item) {
              // Handle the selected item
              switch (item) {
                case MenuAction.edit:
                  debugPrint('Edit tapped');
                  break;
                case MenuAction.share:
                  debugPrint('Share tapped');
                  break;
                case MenuAction.delete:
                  debugPrint('Delete tapped');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuAction>>[
              const PopupMenuItem<MenuAction>(
                value: MenuAction.edit,
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<MenuAction>(
                value: MenuAction.share,
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(), // Optional horizontal divider
              const PopupMenuItem<MenuAction>(
                value: MenuAction.delete,
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: const Center(child: Text('Tap the top-right menu icon')),
    );
  }
}