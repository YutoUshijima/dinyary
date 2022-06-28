//import 'package:dinyary/routes/home_route.dart';
import 'package:dinyary/routes/header.dart';
import 'package:flutter/material.dart';
//import 'header.dart';
import 'NoteViewModel.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TimeLine> {
  List<Map<String, dynamic>> _memo = [];

  bool _isLoading = true;
  String? _isSelectedItem = "Others";
  String? _isSelectedItem_now = "Others";

  void _refreshJournals() async {
    final data = await NoteViewModel.getNotes();
    setState(() {
      _memo = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  final TextEditingController _diaryController = TextEditingController();
  //final TextEditingController _tagController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _memo.firstWhere((element) => element['id'] == id);
      _diaryController.text = existingJournal['diary'];
      _isSelectedItem = existingJournal['tag'];
      //_tagController.text = existingJournal['tag'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _diaryController,
                    decoration: const InputDecoration(hintText: '日記を書いてみよう！'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButton<String>(
                    //4
                    items: const [
                      //5
                      DropdownMenuItem(
                        child: Text('Get up'),
                        value: 'Get up',
                      ),
                      DropdownMenuItem(
                        child: Text('Going to bed'),
                        value: 'Going to bed',
                      ),
                      DropdownMenuItem(
                        child: Text('Exercise'),
                        value: 'Exercise',
                      ),
                      DropdownMenuItem(
                        child: Text('Others'),
                        value: 'Others',
                      ),
                    ],
                    //6
                    onChanged: (String? value) {
                      setState(() {
                        _isSelectedItem = value;
                        _isSelectedItem_now = value;
                      });
                    },
                    //7
                    value: _isSelectedItem_now,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }
                      _diaryController.text = '';
                      _isSelectedItem = 'Others';
                      //_tagController.text = '';

                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ));
  }

  Future<void> _addItem() async {
    await NoteViewModel.createItem(
        _diaryController.text, _isSelectedItem); //_tagController.text);
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await NoteViewModel.updateItem(
        id, _diaryController.text, _isSelectedItem); //_tagController.text);
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await NoteViewModel.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a diary!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _memo.length,
              itemBuilder: (context, index) => Card(
                color: Color.fromARGB(255, 255, 255, 255),
                margin: const EdgeInsets.all(3),
                child: ListTile(
                    leading: Icon(
                      _memo[index]['tag'] == "Get up"
                          ? Icons.sunny
                          : _memo[index]['tag'] == "Going to bed"
                              ? Icons.airline_seat_individual_suite
                              : _memo[index]['tag'] == "Exercise"
                                  ? Icons.fitness_center
                                  : Icons.insert_emoticon,
                      size: 20,
                    ),
                    title: Text(_memo[index]['diary']),
                    subtitle: Text(_memo[index]['createdAt']),
                    trailing: SizedBox(
                      width: 96,
                      //height: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            //iconSize: 10,
                            onPressed: () => _showForm(_memo[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 30),
                            onPressed: () => _deleteItem(_memo[index]['id']),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
