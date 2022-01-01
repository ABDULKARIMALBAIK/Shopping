import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shopping_app/const/Utils.dart';
import 'package:flutter_shopping_app/model/UserModel.dart';
import 'package:flutter_shopping_app/network/api_request.dart';
import 'package:flutter_shopping_app/state/StateManagement.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kenburns/kenburns.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:flutter_riverpod/all.dart';

class UserProfileScreen extends ConsumerWidget {


  @override
  Widget build(BuildContext context, ScopedReader watch) {

    // var update = watch(userUpdate).state;

    TextEditingController _nameController = TextEditingController();
    TextEditingController _addressController = TextEditingController();

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: true,
            backgroundColor: Color(0xFF0C1B37),
            body: FutureBuilder(
              future: findUser(FirebaseAuth.instance.currentUser!.uid, context.read(userToken).state),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(),);
                else {

                  if(snapshot.data.toString() == 'User Not found'){
                    Navigator.of(context).pushNamed('/registerUser');
                    return Container();
                  }
                  else {
                    var user = UserModel.fromJson(jsonDecode(snapshot.data.toString()));
                    _nameController.text = user.name;
                    _addressController.text = user.address;

                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                          ShapeOfView(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            shape: DiagonalShape(
                                position: DiagonalPosition.Bottom,
                                direction: DiagonalDirection.Left,
                                angle: DiagonalAngle.deg(angle: 10)
                            ),
                            child: KenBurns(
                              minAnimationDuration: Duration(seconds: 2),
                              maxAnimationDuration: Duration(seconds: 10),
                              maxScale: 1.1,
                              child: Image.network('..........................................',fit: BoxFit.cover,),
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 12,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: (){
                                        //Back
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.navigate_before , size: 30, color: Colors.white,)),
                                  IconButton(
                                      onPressed: (){
                                        //Logout
                                        Alert(
                                            context: context,
                                            type: AlertType.warning,
                                            title: 'Sign Out',
                                            desc: 'Do you really want to sign out ?',
                                            buttons: [
                                              DialogButton(child: Text('Yes',style: TextStyle(color: Colors.white),), onPressed: () async{

                                                var result = await FirebaseAuthUi.instance().logout();
                                                if(result){
                                                  showOnlySnackBar(_scaffoldKey, context, "Logout successfully");
                                                  //Refresh
                                                  context.read(userLogged).state = FirebaseAuth.instance.currentUser;
                                                }
                                                else
                                                  showOnlySnackBar(_scaffoldKey, context, "Logout error");

                                              })
                                            ]
                                        ).show();

                                      },
                                      icon: Icon(Icons.logout , size: 30, color: Colors.white,)),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('${user.name}',style: GoogleFonts.montserrat(color: Colors.white , fontSize: 40),)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('${user.phone}',style: GoogleFonts.montserrat(color: Colors.white , fontSize: 40),)
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height/7*3.2,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage('...........................................'),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                            onPressed: () => Navigator.of(context).pushNamed('/orders'),
                                            icon: Icon(Icons.list_alt,color: Colors.white,)),
                                        Text('Orders',style: GoogleFonts.montserrat(color: Colors.white),)
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 20,),
                                TextField(
                                  controller: _nameController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1 , color: Colors.white)
                                    ),
                                    enabledBorder:  OutlineInputBorder(
                                        borderSide: BorderSide(width: 1 , color: Colors.white)
                                    ),
                                    focusedBorder:  OutlineInputBorder(
                                        borderSide: BorderSide(width: 1 , color: Colors.white)
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextField(
                                  controller: _addressController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Address",
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1 , color: Colors.white)
                                    ),
                                    enabledBorder:  OutlineInputBorder(
                                        borderSide: BorderSide(width: 1 , color: Colors.white)
                                    ),
                                    focusedBorder:  OutlineInputBorder(
                                        borderSide: BorderSide(width: 1 , color: Colors.white)
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    onPressed: () async{
                                      //Update
                                      user.name = _nameController.text;
                                      user.address = _addressController.text;
                                      var result = await updateUserApi(
                                          context.read(userToken).state,
                                          user
                                      );

                                      showOnlySnackBar(_scaffoldKey, context, result);

                                      //Update text
                                      _nameController.text = user.name;
                                      _addressController = user.address;
                                      context.read(userUpdate).state = true;

                                    },
                                    child: Text('Save'),
                                  ),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                }
              },
            )
        )
    );
  }
}
