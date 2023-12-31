import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import '../modals/emoji_keyboard.dart';

class NavBar extends StatefulWidget {
  final Function(String)? onFormattingChange;
  final Function(bool)? onRecordingStatusChange;  // Add onRecordingStatusChange

  const NavBar({Key? key, this.onFormattingChange, this.onRecordingStatusChange}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  File? image;
  bool isRecording = false;
  late FlutterSoundRecorder _audioRecorder;

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
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
  }

  @override
  @override
  void dispose() async {
    if (isRecording) {
      await _audioRecorder.stopRecorder();
    }
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: List.generate(
        icons.length,
            (index) => BottomNavigationBarItem(
          icon: index == 7
              ? GestureDetector(
            onTap: () {
              _showEmojiKeyboard();
            },
            child: Icon(
              icons[index],
              color: _selectedIndex == index ? Colors.black12 : Colors.black,
            ),
          )
              : index == 6
              ? GestureDetector(
            onTap: () {
              pickImage();
            },
            child: Icon(
              icons[index],
              color: _selectedIndex == index ? Colors.black12 : Colors.black,
            ),
          )
              : index == 4
              ? GestureDetector(
            onTap: () {
              _toggleRecording();
            },
            child: Icon(
              icons[index],
              color: isRecording ? Colors.red : (_selectedIndex == index ? Colors.black12 : Colors.black),
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
          if (widget.onFormattingChange != null) {
            widget.onFormattingChange!(labels[index]);
          }
          if (index != 4) {
            _stopRecording();
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

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _toggleRecording() {
    if (isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  void _startRecording() async {
    try {
      await _audioRecorder.startRecorder();
      await _audioRecorder.startRecorder(
        toFile: 'your_audio_directory/${DateTime.now().millisecondsSinceEpoch}.aac',
        codec: Codec.aacADTS,
      );
      setState(() {
        isRecording = true;
      });
      widget.onRecordingStatusChange?.call(true);
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  void _stopRecording() async {
    try {
      await _audioRecorder.stopRecorder();
      await _audioRecorder.stopRecorder();
      setState(() {
        isRecording = false;
      });
      widget.onRecordingStatusChange?.call(false);
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }
}
