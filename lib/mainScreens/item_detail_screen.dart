import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hungerup_users_app/assistantMethods/assitant_methods.dart';
import 'package:hungerup_users_app/mainScreens/cart_screeen.dart';
import 'package:hungerup_users_app/models/items.dart';
import 'package:hungerup_users_app/widgets/app_bar.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class ItemDetailsScreen extends StatefulWidget
{
  final Items? model;

  ItemDetailsScreen({this.model});

  @override
  _ItemDetailsScreen createState() => _ItemDetailsScreen();
}

class _ItemDetailsScreen extends State<ItemDetailsScreen>
{
  TextEditingController counterTextEditingController =TextEditingController();


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Image.network(widget.model!.thumbnailUrl.toString()),

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: NumberInputPrefabbed.roundedButtons(
              controller: counterTextEditingController,
              incDecBgColor: Colors.amber,
              min:1,
              max:9,
              initialValue: 1,
              buttonArrangement: ButtonArrangement.incRightDecLeft,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.title.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
             "₹. "+ widget.model!.price.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),

          const SizedBox(height: 10,),
          Center(
            child: InkWell(
              onTap: ()
              {
                int itemCounter= int.parse(counterTextEditingController.text);

                List<String> separateItemIdsList = separateItemIds();
                //1.Check if item exits already in cart
                separateItemIdsList.contains(widget.model!.itemID)
                  ? Fluttertoast.showToast(msg: "Item is already exists in Cart.") :
                //2.ADD To Cart
                addItemToCart(widget.model!.itemID, context, itemCounter);
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.amber,
                      ],
                      begin:  FractionalOffset(0.0, 0.0),
                      end:  FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                ),
                width: MediaQuery.of(context).size.width - 14,
                height: 50,
                child: const Center(
                  child: Text(
                    "ADD TO CART",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}