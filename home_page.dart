import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_ecommerce_app/blocs/princiapale_provider.dart';
import 'package:flutter_ecommerce_app/screens/cart_page.dart';
import 'package:flutter_ecommerce_app/utils/couleurs.dart';
import 'package:flutter_ecommerce_app/widgets/food_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/category_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => HomePageBloc(),
        child: HomePageContent()
    );
  }
}

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {

  late HomePageBloc homePageBloc;
  double latitude=0.1;
  double longuitude=0.1;

  void getLocation()async{
    var position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude=position.latitude;
      longuitude=position.longitude;
    });
  }

   int _selectedCategory=0;
  onSelect(int index){
    setState(() {
      _selectedCategory=index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      homePageBloc.getAllCategories();
      homePageBloc.getAllFood();
    });
  }

  @override
  Widget build(BuildContext context) {
    homePageBloc=Provider.of<HomePageBloc>(context);
    return Scaffold(
     // backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        title: Row(
          children: [
            Icon(Icons.food_bank_outlined,color: Couleurs.redColor,size: 40,),
            SizedBox(width: 10,),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("FOODY DZ",
                  style: GoogleFonts.poppins(fontSize: 19,color: Couleurs.textColor),
                  ),
                  Text("Khadidja",
                    style: GoogleFonts.poppins(fontSize: 13,color: Couleurs.greyColor),
                  ),
                ],
              ),
            )
          ],
        ),
        actions: [
          Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPageContent()));
                    },
                    icon: Icon(Icons.shopping_cart_outlined,color: Couleurs.blackColor,)
                ),
                Positioned(
                  top: 18,
                  right: 13,
                  child: Container(
                    height: 10,
                    width: 10,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Couleurs.redColor
                    ),
                    //child: Text("1",style: TextStyle(fontSize: 10,color: Colors.white),),
                  ),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
    },
              icon: Icon(Icons.logout,color: Couleurs.blackColor,)
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 15,),
            AllCategories(),
            SizedBox(height: 20,),
            ListFood(),
          ],
        ),
      ),
    );
  }




  AllCategories(){
    return Container(
      height: 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 20),
          itemCount: homePageBloc.ListCategory.length,
          itemBuilder: (context, int index){
            return CategoryCard(
                category: homePageBloc.ListCategory[index],
                selected: _selectedCategory==index?true:false,
                onSelect: (){
                  setState(() {
                    _selectedCategory=index;
                    if(_selectedCategory==0){
                      homePageBloc.getAllFood();
                    }else{
                      homePageBloc.getFoodCategory(homePageBloc.ListCategory[_selectedCategory].id);
                    }
                  });
                }
            );
          }
      ),
    );
  }


  ListFood(){
    return Flexible(
      child: homePageBloc.ListFood.isEmpty
      ?Center(child: Text("Pas de résultas"),)
      :ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: homePageBloc.ListFood.length,
          itemBuilder: (context,int index){
            return FoodCard(food: homePageBloc.ListFood[index],);
          }
      ),
    );
  }


  Slider(){

  }

}


