import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hungerup_users_app/global/global.dart';
import 'package:hungerup_users_app/models/address.dart';
import 'package:hungerup_users_app/widgets/simple_app_bar.dart';
import 'package:hungerup_users_app/widgets/text_field.dart';

class SaveAddressScreen extends StatelessWidget{
  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();
  final formKey =GlobalKey<FormState>();
  List<Placemark>? placemarks;
  Position? position;

  getUserLocationAddress() async{
    Position newPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    position=newPosition;
    placemarks = await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMark =placemarks![0];

    String fullAddress='${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality},${pMark.locality},${pMark.subAdministrativeArea},${pMark.administrativeArea},${pMark.postalCode},${pMark.country}';

    _locationController.text =fullAddress;
    _flatNumber.text ='${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality},${pMark.locality}';
    _city.text='${pMark.subAdministrativeArea},${pMark.administrativeArea}';
    _state.text='${pMark.country}';
    _completeAddress.text=fullAddress;
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: SimpleAppBar(title: "HungerUp",),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text("Save Now"),
        icon: const Icon(Icons.save),
        onPressed: ()
        {
          //Save Address info
          if(formKey.currentState!.validate()){
            final model=Address(
              name: _name.text.trim(),
              state: _state.text.trim(),
              city: _city.text.trim(),
              phoneNumber: _phoneNumber.text.trim(),
              fullAddress: _completeAddress.text.trim(),
              flatNumber: _flatNumber.text.trim(),
              lat: position!.latitude,
              lng: position!.longitude,
            ).toJson();
            FirebaseFirestore.instance.collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("userAddress").doc(DateTime.now()
                .millisecondsSinceEpoch.toString()).set(model).then((value)
            {
              Fluttertoast.showToast(msg: "New Address Saved Successfully!!");
              formKey.currentState!.reset();
            });
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 6,),
           const Align(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "SAVE NEW ADDRESS:",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.person_pin_circle,
                color: Colors.black,
                size: 35,
              ),
              title: Container(
                width: 250,
                child: TextField(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: "What's Your Address ?",
                    hintStyle: TextStyle(
                      color: Colors.black,
                    )
                  ),
                ),
              ),
            ),
            const SizedBox(height: 7,),

            ElevatedButton.icon(
              label: const Text(
                "Get My Location",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.location_on, color: Colors.white,),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              onPressed: ()
              {
                //Get Current Location With Address
                getUserLocationAddress();
              },
            ),
            const SizedBox(height: 28,),

            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Name",
                    controller: _name,
                  ),
                  const SizedBox(height: 13,),
                  MyTextField(
                    hint: "Phone Number",
                    controller: _phoneNumber,
                  ),
                  const SizedBox(height: 13,),
                  MyTextField(
                    hint: "City",
                    controller: _city,
                  ),
                  const SizedBox(height: 13,),
                  MyTextField(
                    hint: "State/Country",
                    controller: _state,
                  ),
                  const SizedBox(height: 13,),
                  MyTextField(
                    hint: "Address Line",
                    controller: _flatNumber,
                  ),
                  const SizedBox(height: 13,),
                  MyTextField(
                    hint: "Complete Address",
                    controller: _completeAddress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}