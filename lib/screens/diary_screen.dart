import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'navbar.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late String currentTime;
  late Timer timer;
  late String title;
  late String description;
  String? selectedOption; // Make it nullable if needed
  final TextStyle inputTextStyle = TextStyle(fontSize: 18);
  List<String> history = [];
  Map<String, String> entryUrls = {}; // Correct type for entryUrls
  final Uuid uuid = Uuid();
  bool isRecording= false;

  @override
  void initState() {
    super.initState();
    currentTime = _formatDateTime(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = _formatDateTime(DateTime.now());
      });
    });
    title = '';
    description = '';
    loadHistory();
    loadEntryUrls();
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MM, HH:mm').format(dateTime);
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('title', title);
    prefs.setString('description', description);
    _saveHistory();
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    history = prefs.getStringList('history') ?? [];
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    history.add(_formatDateTime(DateTime.now()));
    prefs.setStringList('history', history);
  }

  Future<void> undo() async {
    if (history.isNotEmpty) {
      // Implement logic to revert the data based on the last timestamp
      // For simplicity, let's just print the timestamp here.
      print('Undo: ${history.last}');
      history.removeLast();
      // Load the data corresponding to the new last timestamp
      await loadData();
    }
  }

  Future<void> redo() async {
    // Implement logic to redo the undone action
    // For simplicity, let's just print a message here.
    print('Redo');
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      title = prefs.getString('title') ?? '';
      description = prefs.getString('description') ?? '';
    });
  }

  Future<void> loadEntryUrls() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, String>? urls = prefs.getStringList('entryUrls')?.asMap().cast<String, String>();
    if (urls != null) {
      entryUrls = Map.from(urls);
    }
  }

  Future<void> _generateEntryUrl() async {
    final String entryId = uuid.v4();
    final String entryUrl = 'https://example.com/entries/$entryId'; // Replace with your domain
    entryUrls[entryId] = entryUrl;
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('entryUrls', entryUrls.entries.map((e) => '${e.key}:${e.value}').toList());

    // Share the URL
    Share.share(entryUrl, subject: 'Check out my diary entry!');
  }

  @override
  void dispose() {
    // Dispose of the timer when the widget is disposed
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        actions: [
        IconButton(
        icon: Icon(Icons.undo),
    onPressed: undo,
    ),
    IconButton(
    icon: Icon(Icons.redo),
    onPressed: redo,
    ),
    IconButton(
    icon: Icon(Icons.share),
    onPressed: () {
    if (entryUrls.isNotEmpty) {
    _generateEntryUrl();
    }
    },
    ),
    PopupMenuButton<String>(
    onSelected: (value) {
    // Handle options menu selection
    print('Selected: $value');
    },
    itemBuilder: (BuildContext context) {
    return [
    PopupMenuItem(
    value: 'option1',
    child: Text('Option 1'),
    ),
    PopupMenuItem(
    value: 'option2',
    child: Text('Option 2'),
    ),
    ];
    },
    ),
    ],
    ),
    body: Column(
    children: [
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    '${currentTime ?? ''}',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    DropdownButton<String>(
    value: selectedOption,
    onChanged: (String? newValue) {
    setState(() {
    selectedOption = newValue;
    });
    },
    items: ['Work', 'Personal']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    ),
    ],
    ),
    ),
      SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: isRecording
    ?Text('Recording...')
        : TextField(
          onChanged: (value) {
            setState(() {
              title = value;
            });
            saveData();
          },
          style: inputTextStyle,
          decoration: InputDecoration(
            hintText: 'Title',
            hintStyle: inputTextStyle,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ),
      SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: TextField(
          onChanged: (value) {
            setState(() {
              description = value;
            });
            saveData();
          },
          maxLines: null,
          style: inputTextStyle,
          decoration: InputDecoration(
            hintText: 'Description',
            hintStyle: inputTextStyle,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ),
    ],
    ),
      bottomNavigationBar: NavBar(onFormattingChange: (formattingOption) {
        // Handle formatting changes here
        // You can update the text styling based on the selected formatting option
        // For simplicity, let's just print the selected formatting option
        print('Selected Formatting: $formattingOption');
      },
        onRecordingStatusChange: (isRecording){
        setState(() {
          this.isRecording= isRecording;
        });
        },
      ),
    );
  }
  void _toggleRecording() {
    // Implement recording functionality here if needed
  }
}
