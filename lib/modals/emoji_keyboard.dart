import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class EmojiKeyboard extends StatefulWidget {
  const EmojiKeyboard({Key? key}) : super(key: key);

  @override
  State<EmojiKeyboard> createState() => _EmojiKeyboardState();
}

class _EmojiKeyboardState extends State<EmojiKeyboard> {
  final TextEditingController _textController = TextEditingController();
  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height * 0.3,
      child: EmojiPicker(
        textEditingController: _textController,
        config: Config(
          bgColor: const Color.fromARGB(255, 234, 248, 255),
          columns: 8,
          emojiSizeMax: 32 * (Theme.of(context).platform == TargetPlatform.iOS ? 1.30 : 1.0),
        ),
      ),
    );
  }
}
