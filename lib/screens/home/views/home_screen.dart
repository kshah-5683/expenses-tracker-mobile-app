import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 3,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home)
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_square_fill))
        ] 
      )
    );
  }
}