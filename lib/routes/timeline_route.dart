//import 'package:dinyary/routes/home_route.dart';
import 'package:dinyary/routes/header.dart';
import 'package:flutter/material.dart';
//import 'header.dart';
import 'NoteViewModel.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum Menu { image, edit, delete }

class _HomePageState extends State<TimeLine> {
  List<Map<String, dynamic>> _memo = [];

  // 初期値
  bool _isLoading = true;
  String? _tagController = "Others";
  String? newValue = "1";
  String _selectedMenu = '';
  final TextEditingController _diaryController = TextEditingController();
  //final TextEditingController _tagController = TextEditingController();

  final picker = ImagePicker();

  //var _isSelectedItem = "Others";

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

  // 日記投稿パネル表示
  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _memo.firstWhere((element) => element['id'] == id);
      _diaryController.text = existingJournal['diary'];
      _tagController = existingJournal['tag'];
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
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(hintText: '日記を書いてみよう！'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // DropdownButtonだとバグるので注意
                  DropdownButtonFormField<String>(
                    items: const [
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
                    value: _tagController,
                    onChanged: (String? changedValue) {
                      setState(() {
                        //_isSelectedItem = changedValue ?? "";
                        _tagController = changedValue;
                      });
                    },
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
                      _tagController = 'Others';
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
        _diaryController.text, _tagController); //_tagController.text);
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await NoteViewModel.updateItem(
        id, _diaryController.text, _tagController); //_tagController.text);
    _refreshJournals();
  }

  // アイテムの削除
  void _deleteItem(int id) async {
    await NoteViewModel.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: const Duration(milliseconds: 1500),
      content: Text('Successfully deleted a diary!'),
    ));
    _refreshJournals();
  }

  // 画像インポートのための関数
  // そのまま記述したら動かなかった......
  // 何度も動かすと時々エラーを吐きます(公式仕様)
  Future<String> _image_picker() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    try {
      //File file = File((pickedFile!).path);
      final bytes = File((pickedFile!).path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      print(img64.substring(0, 100));
      return img64;
    } catch (e) {
      debugPrint("Error");
      return "";
    }
  }

  // ポップアップメニュー選択時の挙動
  void popupMenuSelected(Menu selectedMenu, index) {
    switch (selectedMenu) {
      case Menu.image:
        _image_picker();
        break;
      case Menu.edit:
        _showForm(_memo[index]['id']);
        break;
      case Menu.delete:
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return AlertDialog(
                title: Text("本当に削除しますか？"),
                content: Text("この操作は取り消せません。"),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      _deleteItem(_memo[index]['id']);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
        break;
      default:
        debugPrint("Error");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ヘッダー
      appBar: Header(),
      // 日記の描画
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
                  // タグに応じてアイコンを変更
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
                  // 日記本文
                  title: Text(_memo[index]['diary']),
                  // 投稿日時
                  subtitle: Text(_memo[index]['createdAt']),
                  // ポップアップメニュー
                  trailing: PopupMenuButton<Menu>(
                      onSelected: (Menu item) {
                        popupMenuSelected(item, index);
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<Menu>>[
                            const PopupMenuItem<Menu>(
                              value: Menu.image,
                              child: ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("image")),
                            ),
                            const PopupMenuItem<Menu>(
                              value: Menu.edit,
                              child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text("edit")),
                            ),
                            const PopupMenuItem<Menu>(
                              value: Menu.delete,
                              child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text("delete")),
                            ),
                          ]),
                ),
              ),
            ),
      // 日記投稿ボタン(削除予定？)
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
