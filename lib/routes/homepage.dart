import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import '../routes/groceries.dart';
import '../routes/todos.dart';
import '../routes/plans.dart';




class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   int _selectedIndex = 0;
  
  static List<Widget> pageList = <Widget>[
     const Todos(),
     const Groceries(),
     const Plans(),
  ];


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("WBSG Notes")
        ),
  
      resizeToAvoidBottomInset : false,
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items:[
          FlashyTabBarItem(
            icon: const Icon(Icons.checklist_rounded),
            title: const Text('To Do'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.shopping_basket_rounded),
            title: const Text('Grocery List'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.rocket_launch_rounded),
            title: const Text('Plans'),
          ),
        ]),
        body:pageList.elementAt(_selectedIndex)
          );
  }
}