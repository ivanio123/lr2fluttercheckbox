import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tri-State Checkbox List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: TriStateCheckboxListPage(),
    );
  }
}

class TriStateCheckboxListPage extends StatefulWidget {
  @override
  _TriStateCheckboxListPageState createState() =>
      _TriStateCheckboxListPageState();
}

class _TriStateCheckboxListPageState extends State<TriStateCheckboxListPage> {
  // Список елементів, кожен має свій стан (null, true, false)
  List<Item> items = List.generate(
    10,
        (index) => Item(name: 'Item $index', isSelected: false), // Дефолтний стан false
  );

  // Отримуємо загальний стан для чекбоксу в заголовку
  bool? get _groupSelectionValue {
    if (items.every((item) => item.isSelected == true)) {
      return true; // всі вибрані
    } else if (items.every((item) => item.isSelected == false)) {
      return false; // жоден не вибраний
    } else {
      return null; // змішаний стан
    }
  }

  // Зміна стану для чекбоксу в заголовку
  void _updateGroupSelection(bool? value) {
    setState(() {
      if (value == true) {
        // Якщо чекбокс "вибраний", вибираємо всі елементи
        items.forEach((item) => item.isSelected = true);
      } else if (value == false) {
        // Якщо чекбокс "невибраний", скидаємо вибір з усіх
        items.forEach((item) => item.isSelected = false);
      } else {
        // Якщо чекбокс "невизначений", встановлюємо невизначений стан для всіх
        items.forEach((item) => item.isSelected = false); // Встановлюємо false, а не null
      }
    });
  }

  // Зміна стану для окремого елемента
  void _toggleItemSelection(int index) {
    setState(() {
      if (items[index].isSelected == false) {
        items[index].isSelected = true;
      } else {
        items[index].isSelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tri-State Checkbox List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Чекбокс для групового вибору
            Checkbox(
              value: _groupSelectionValue,
              tristate: true,
              onChanged: _updateGroupSelection,
            ),
            Text(
              _groupSelectionValue == null
                  ? 'Some selected'
                  : _groupSelectionValue!
                  ? 'All selected'
                  : 'None selected',
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: items[index].isSelected,
                      tristate: false, // Для елементів не використовуємо три стани
                      onChanged: (_) => _toggleItemSelection(index),
                    ),
                    title: Text(items[index].name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  final String name;
  bool isSelected;

  Item({required this.name, this.isSelected = false});
}
