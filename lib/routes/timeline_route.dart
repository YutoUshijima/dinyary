//import 'package:dinyary/routes/home_route.dart';
import 'dart:typed_data';

import 'package:dinyary/routes/header.dart';
import 'package:flutter/material.dart';
//import 'header.dart';
import 'NoteViewModel.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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
  String _appDocPath = "";
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
  Future<void> _imagePicker(int id) async {
    // ギャラリーの1枚目を選択するとバグるので注意!!!
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    try {
      // ファイルをギャラリからインポート
      print(_memo[id]['imgPath']);
      print("please update.");

      // デコードしたbytesをそのまま保存できなかった
      //Uint8List bytes = await File((pickedFile!).path).readAsBytes();
      //_imgController = bytes.sublist(0,100);
      //print(_imgController!.length);

      // 画像のまま保存する試み
      // (1)ローカルに保存
      // ユーザビリティは低いがBASE64をそのまま打ち込むよりは推奨
      var bytes = File((pickedFile!).path).readAsBytesSync();
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String _appDocPath = appDocDir.path;
      String saveFilePath = "$_appDocPath/00${_memo[id]['id']}_img.png";

      // (2)image/に保存
      // 失敗
      //String saveFilePath = "images/ID${_memo[id]['id']}_img.png";

      var saveFile = File(saveFilePath);
      saveFile.writeAsBytesSync(bytes);
    } catch (e) {
      print(e);
      //debugPrint("Error");
    }
  }

  // ポップアップメニュー選択時の挙動
  void popupMenuSelected(Menu selectedMenu, index) {
    switch (selectedMenu) {
      case Menu.image:
        // ここに非同期処理を書くと動かない。なぜ？
        _imagePicker(index);
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

  Future<void> _rootChecker() async {
    Directory appDocDir = await await getApplicationDocumentsDirectory();
    _appDocPath = appDocDir.path;
    //print(_appDocPath);
  }

  @override
  Widget build(BuildContext context) {
    _rootChecker();
    print(_appDocPath);
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
                  margin: const EdgeInsets.all(8),
                  child: Column(children: [
                    ListTile(
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
                    Stack(
                      children: [
                        Ink.image(
                          //image: const NetworkImage(
                          //  'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1327&q=80',
                          //),
                          image: (Image.file(File("$_appDocPath/004_img.png")))
                              .image,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                        const Positioned(
                          bottom: 16,
                          right: 16,
                          left: 16,
                          child: Text(
                            'I got it!!!!!!!!!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    )
                  ])),
            ),
      // 日記投稿ボタン(削除予定？)
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
