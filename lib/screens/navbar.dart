import 'package:flutter/material.dart';
import '../modals/emoji_keyboard.dart';

class NavBar extends StatefulWidget {
  final Function(String)? onFormattingChange;

  const NavBar({Key? key, this.onFormattingChange}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<IconData> icons = [
    Icons.format_bold,
    Icons.format_italic,
    Icons.format_size,
    Icons.check_box,
    Icons.mic,
    Icons.edit,
    Icons.image,
    Icons.emoji_emotions, // Emoji icon
  ];

  final List<String> labels = [
    'Bold',
    'Italic',
    'Font Size',
    'Checklist',
    'Recordings',
    'Handwriting',
    'Attach Image',
    'Emoji',
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: List.generate(
        icons.length,
            (index) => BottomNavigationBarItem(
          icon: index == 7 // Check if it's the Emoji icon
              ? GestureDetector(
            onTap: () {
              // Handle emoji icon tap here
              _showEmojiKeyboard();
            },
            child: Icon(
              icons[index],
              color: _selectedIndex == index ? Colors.black12 : Colors.black,
            ),
          )
              : Icon(
            icons[index],
            color: _selectedIndex == index ? Colors.black12 : Colors.black,
          ),
          label: labels[index],
        ),
      ),
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black12,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
          // Pass the selected formatting option to the callback
          if (widget.onFormattingChange != null) {
            widget.onFormattingChange!(labels[index]);
          }
        });
      },
    );
  }

  void _showEmojiKeyboard() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EmojiKeyboard();
      },
    );
  }
}
