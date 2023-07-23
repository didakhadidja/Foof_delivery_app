import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/helper/sql_helper.dart';
import 'package:flutter_ecommerce_app/models/cart.dart';
import 'package:flutter_ecommerce_app/models/food.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/couleurs.dart';

class DetailsPage extends StatefulWidget {
  final Food food;

  const DetailsPage({super.key, required this.food});
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int qte=0;
  SqlHelper sqlHelper=new SqlHelper();
  TextEditingController noteController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sqlHelper.Init_Database();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /*** Quantity ***/
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap:(){
                      setState(() {
                        qte++;
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red,
                      ),
                      child: Center(child: Icon(Icons.add,color: Colors.white,)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(qte.toString(),
                      style: GoogleFonts.roboto(
                        fontSize: 20,

                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      setState(() {
                        if(qte>0){
                          qte--;
                        }
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red,
                      ),
                      child: Center(child: Icon(Icons.remove,color: Colors.white,)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            /*** Add to cart button ***/
            GestureDetector(
              onTap: (){
                Cart cart=new Cart(
                    id: widget.food.id,
                    name: widget.food.name,
                    image: widget.food.image,
                    price: widget.food.price,
                    qte: qte,
                  note: noteController.text.isEmpty?"":noteController.text
                );

                int exist=-1;
                sqlHelper.Exist(cart.id).then((value) {
                  print("count = "+value.toString());
                  if(value!=0){
                    final snackBar = SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                      //elevation: 0,
                      margin: EdgeInsets.symmetric(horizontal: 70,vertical: 140),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      content: Container(
                        height: 220,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*** Icon ***/
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45),
                                border: Border.all(width: 5,color: Couleurs.redColor),
                              ),
                              child: Center(
                                child: Icon(Icons.done,size: 50,color: Couleurs.redColor,),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text("Plat dèja ajouté",
                              style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  color: Couleurs.textColor,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }else{
                    sqlHelper.Insert_data(cart);
                    final snackBar = SnackBar(
                      behavior: SnackBarBehavior.floating,
                      //elevation: 0,
                      margin: EdgeInsets.symmetric(horizontal: 70,vertical: 140),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      content: Container(
                        height: 220,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*** Icon ***/
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45),
                                border: Border.all(width: 5,color: Couleurs.redColor),
                              ),
                              child: Center(
                                child: Icon(Icons.done,size: 50,color: Couleurs.redColor,),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text("Plat ajouté",
                              style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  color: Couleurs.textColor,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });




              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 48,
                decoration: BoxDecoration(
                  color: Couleurs.redColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text("Ajouter au panier",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*** Image ***/
              Container(
                height: MediaQuery.of(context).size.height/2,
                //color: Colors.red,
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height/2-20,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.food.image),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    Positioned(
                      top: 70,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,size: 20,),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height/2-40,
                      right: 20,
                      child: Container(
                        height: 40,
                        width: 130,
                        decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: Offset(-1,1),
                                  blurRadius: 4,
                                  spreadRadius: 0
                              ),
                            ]
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Icon(Icons.access_time,size: 17,),
                              SizedBox(width: 5,),
                              Text("15-20 mins",
                                style: GoogleFonts.roboto(
                                  color: Couleurs.blackColor,
                                  fontSize: 17
                                ),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),

                      ),
                    ),
                  ],
                ),
              ),
              /***  Corps ***/
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.food.name,
                      maxLines: 1,
                      style: GoogleFonts.roboto(
                        fontSize: 26,
                        color: Couleurs.blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    /*** rating + price ***/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star,size: 20,color: Couleurs.redColor,),
                            SizedBox(width: 3,),
                            Text(widget.food.rating+" Trés bien",
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(widget.food.price.toString()+" DA",
                          style: GoogleFonts.roboto(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Couleurs.redColor,
                          ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),

                    /*** Ingredients ***/
                    Text("Ingredients",
                      maxLines: 1,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Couleurs.blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(widget.food.DisplayIngredients(),
                      maxLines: 6,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: noteController,
                      minLines: 1, // <-- SEE HERE
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Ajouter une note",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1,color: Couleurs.greyColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1,color: Couleurs.greyColor),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
