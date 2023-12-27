import 'package:flutter/material.dart';
import 'package:inkflow/diary_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _index =0;

  var screen =[DiaryScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_bold),
            label: 'Bold',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_italic),
            label: 'Italic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_size),
            label: 'Font Size',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Checklist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Recordings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Handwriting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Attach Image',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions),
            label: 'Emoji',
          ),
        ],
      ),
    );
  }
}
