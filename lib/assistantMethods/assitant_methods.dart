import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hungerup_users_app/assistantMethods/cart_item_counter.dart';
import 'package:hungerup_users_app/global/global.dart';
import 'package:provider/provider.dart';

separateOrderItemIds(orderIDs) {
  List<String> separateItemIdsList=[], defaultItemList=[];
  int i=0;

  defaultItemList= List<String>.from(orderIDs);

  for(i;i<defaultItemList.length;i++){
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId =(pos != -1) ? item.substring(0,pos) : item;

    print("\nThis is ItemId now = "+ getItemId);

    separateItemIdsList.add(getItemId);
  }

  print("\nThis is Items list now = ");
  print(separateItemIdsList);

  return separateItemIdsList;
}
separateItemIds() {
  List<String> separateItemIdsList=[], defaultItemList=[];
  int i=0;

  defaultItemList= sharedPreferences!.getStringList("userCart")!;

  for(i;i<defaultItemList.length;i++){
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId =(pos != -1) ? item.substring(0,pos) : item;

    print("\nThis is ItemId now = "+ getItemId);

    separateItemIdsList.add(getItemId);
  }

  print("\nThis is Items list now = ");
  print(separateItemIdsList);

  return separateItemIdsList;
}

addItemToCart(String? foodItemId, BuildContext context, int itemCounter) {
  List<String>? tempList =sharedPreferences!.getStringList("userCart");
  tempList!.add(foodItemId! + ":$itemCounter");

  FirebaseFirestore.instance.collection("users")
  .doc(firebaseAuth.currentUser!.uid).update({
    "userCart": tempList,
  }).then((value)
  {
    Fluttertoast.showToast(msg: "Item Added Successfully.");
    sharedPreferences!.setStringList("userCart", tempList);

    //update the badge
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
  });

}

separateOrderItemQuantities(orderIDs) {
  List<String> separateItemQuantityList=[];
  List<String> defaultItemList=[];
  int i=1;

  defaultItemList= List<String>.from(orderIDs);

  for(i;i<defaultItemList.length;i++){
    String item = defaultItemList[i].toString();
    List<String> listItemCharacters = item.split(":").toList();
    var quanNumber =int.parse(listItemCharacters[1].toString());
    print("\nThis is Quantity Number now = "+ quanNumber.toString());

    separateItemQuantityList.add(quanNumber.toString());
  }

  print("\nThis is Items Quantity list now = ");
  print(separateItemQuantityList);

  return separateItemQuantityList;

}
separateItemQuantities() {
    List<int> separateItemQuantityList=[];
    List<String> defaultItemList=[];
    int i=1;

    defaultItemList= sharedPreferences!.getStringList("userCart")!;

    for(i;i<defaultItemList.length;i++){
      String item = defaultItemList[i].toString();
      List<String> listItemCharacters = item.split(":").toList();
      var quanNumber =int.parse(listItemCharacters[1].toString());
      print("\nThis is Quantity Number now = "+ quanNumber.toString());

      separateItemQuantityList.add(quanNumber);
    }

    print("\nThis is Items Quantity list now = ");
    print(separateItemQuantityList);

    return separateItemQuantityList;

}

clearCartNow(context){
  sharedPreferences!.setStringList("userCart", ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userCart":emptyList}).then((value)
      {
        sharedPreferences!.setStringList("userCart", emptyList!);
        Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();

      });

}


