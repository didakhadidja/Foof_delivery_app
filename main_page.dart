import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/screens/home_page.dart';
import 'package:flutter_ecommerce_app/screens/profil_screen.dart';
import 'package:flutter_ecommerce_app/screens/search_screen.dart';
import 'package:flutter_ecommerce_app/utils/couleurs.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedPage=0;
  List<Widget> Pages=[
    HomePageContent(),
    SearchContent(),
    ProfilScreen()
  ];

  onSelected(int index){
    setState(() {
      _selectedPage=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "Commandes",
          ),
        ],
        currentIndex: _selectedPage,
        onTap: onSelected,
        selectedItemColor: Couleurs.redColor,
      ),
      body: Pages[_selectedPage],
    );
  }
}
