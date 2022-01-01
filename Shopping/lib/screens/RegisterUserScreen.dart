
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shopping_app/network/api_request.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_riverpod/all.dart';

class RegisterUserScreen extends ConsumerWidget{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'CREATE AN ACCOUNT',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold , fontSize: 24),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Phone',
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Address',
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: RaisedButton(
                        color: Colors.black,
                        onPressed: () => registerUser(context),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                          child: Text('REGISTER',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
        )
    );


  }

  registerUser(BuildContext context) {
    FirebaseAuth.FirebaseAuth.instance.currentUser!
        .getIdToken()
        .then((token) async {
          var result = await createUserApi(
            token,
            FirebaseAuth.FirebaseAuth.instance.currentUser!.uid,
            _nameController.text,
            _phoneController.text,
            _addressController.text
          );

          print('result is : ${result.toString()}');

          if(result == 'Created'){
            Alert(
              context: context,
              type: AlertType.success,
              title: 'REGISTER SUCCESS',
              desc: 'Thank you for register account',
              buttons: [
                DialogButton(child: Text('My Profile'), onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // Navigator.of(context).pushNamed('/userProfile');
                  // Navigator.pushNamed(context, '/productList');
                })
              ]
            ).show();
          }
          else{
            Alert(
                context: context,
                type: AlertType.error,
                title: 'REGISTER FAILED',
                desc: 'Can not register for unknown reason',
                buttons: [
                  DialogButton(child: Text('OK'), onPressed: (){
                    Navigator.pop(context);
                  })
                ]
            ).show();
          }
    });
  }

}