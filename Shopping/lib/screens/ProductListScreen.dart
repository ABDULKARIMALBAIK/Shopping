import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shopping_app/const/Utils.dart';
import 'package:flutter_shopping_app/floor/dao/CartDao.dart';
import 'package:flutter_shopping_app/model/Category.dart';
import 'package:flutter_shopping_app/model/Product.dart';
import 'package:flutter_shopping_app/model/SubCategories.dart';
import 'package:flutter_shopping_app/model/UserModel.dart';
import 'package:flutter_shopping_app/network/api_request.dart';
import 'package:flutter_shopping_app/state/StateManagement.dart';
import 'package:flutter_shopping_app/widgets/ProductCard.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter_riverpod/all.dart';

class ProductListScreen extends ConsumerWidget {
  final CartDao cartDao;

  ProductListScreen(this.cartDao);

  //Ignore: top_level_function_literal_block
  final _fetchCategories = FutureProvider((ref) async {
    var result = await fetchCategories();
    return result;
  });

  //Ignore: top_level_function_literal_block
  final _fetchProductBySubCategory =
      FutureProvider.family<List<Product>, int>((ref, subCategoryId) async {
    var result = await fetchProductsBySubCategory(subCategoryId);
    return result;
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var categoriesApiResult = watch(_fetchCategories);
    var productsApiResult = watch(_fetchProductBySubCategory(
        context.read(subCategorySelected).state.subCategoryId));

    var userWatch = watch(userLoggedInfo).state;

    print('started page');

    return Scaffold(
        key: _scaffoldKey,
        drawer: _makeDrawer(categoriesApiResult),
        body: SafeArea(
            child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                      icon: Icon(
                        Icons.menu,
                        size: 35,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'SHOPPING',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        FutureBuilder(
                          future: _checkLoginState(context),
                          builder: (context, snapshot) {
                            var user = snapshot.data as FirebaseAuth.User;

                            return IconButton(
                                onPressed: () => processLogin(context),
                                icon: Icon(
                                  Icons.account_circle_outlined,
                                  // user == null
                                  //     ? Icons.account_circle_outlined
                                  //     : Icons.exit_to_app,
                                  size: 35,
                                  color: Colors.black,
                                ));
                          },
                        ),
                        userWatch.role == 'Admin' ?
                        IconButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/adminPage'),
                            icon: Icon(
                              Icons.admin_panel_settings,
                              size: 35,
                              color: Colors.black,
                            )) :
                        IconButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/cartDetail'),
                            icon: Icon(
                              Icons.shopping_bag_outlined,
                              size: 35,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.amberAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                  '${context.read(subCategorySelected).state.subCategoryName}'),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            Expanded(
              child: productsApiResult.when(
                  loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                  error: (error, stack) => Center(
                        child: Text('$error'),
                      ),
                  data: (products) => GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        childAspectRatio: 0.46,
                        children:
                            products.map((e) => ProductCard(key, e)).toList(),
                      )),
            )
          ],
        )));
  }

  _makeDrawer(AsyncValue<List<CategoryShop>> categoriesApiResult) {
    return Drawer(
      child: categoriesApiResult.when(
          loading: () => Center(
                child: CircularProgressIndicator(),
              ),
          error: (error, stack) => Center(
                child: Text('$error'),
              ),
          data: (categories) => ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ExpansionTile(
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(categories[index].categoryImg),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          (categories[index].categoryName as String).length <=
                                  12
                              ? Text(categories[index].categoryName)
                              : Text(
                                  categories[index].categoryName,
                                  style: TextStyle(fontSize: 8),
                                )
                        ],
                      ),
                      children: _buildList(context , categories[index]),
                    ),
                  ),
                );
              })),
    );
  }

  List<Widget> _buildList(BuildContext context , CategoryShop category) {
    var list = <Widget>[];
    List<SubCategories> castSubCategories = category.subCategories;
    castSubCategories.forEach((element) {
      list.add(Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          element.subCategoryName,
          style: TextStyle(fontSize: 12),
        ),
      ));
    });

    return list;
  }

  Future<FirebaseAuth.User?> _checkLoginState(context) async {
    print('started function');
    if (FirebaseAuth.FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.FirebaseAuth.instance.currentUser!
          .getIdToken()
          .then((token) async {


        print('Token: $token');
        var result = await findUser(
            FirebaseAuth.FirebaseAuth.instance.currentUser!.uid,
            token.toString());


        // context.read(userToken).state = token; //Assign Token to fetch api


        if (result == 'User Not found') {
          //Register user
          // print('go auto to register page');
          // Navigator.pushNamed(context, '/registerUser');
        }
        else {
          print(result);

          var userModel = UserModel.fromJson(jsonDecode(result));
          if(!context.read(forceLoopReload).state){
            context.read(userLoggedInfo).state = userModel;
            context.read(forceLoopReload).state = true;
          }


          cartDao.updateUidCart(userModel.uid).then((value) {
            FirebaseMessaging _messaging = FirebaseMessaging.instance;
            _messaging.getToken().then((fcmToken) async {
              userModel.token = fcmToken;
              var updateResult =
                  await updateTokenApi(token, userModel.uid, userModel);
            });
          });
        }
      });
    }

    return FirebaseAuth.FirebaseAuth.instance.currentUser;
  }

  processLogin(BuildContext context) async {
    var user = FirebaseAuth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      //He doesn't have account before => create account
      FirebaseAuthUi.instance()
          .launchAuth([AuthProvider.google()]).then((firebaseUser) {

        //Refresh State
        print('Get user into from firebase');
        context.read(userLogged).state =
            FirebaseAuth.FirebaseAuth.instance.currentUser;

        print('register user now !!!');
        Navigator.of(context).pushNamed('/registerUser');

      }).catchError((e) {
        if (e is PlatformException) {
          if (e.code == FirebaseAuthUi.kUserCancelledError){
            print('User cancelled login');
            showOnlySnackBar(_scaffoldKey, context, 'User cancelled login');
          }
          else{
            print('error happened : ${e.message.toString()}');
            showOnlySnackBar(_scaffoldKey, context,
                '${e.message.toString() ?? 'Unknown error'}');
          }

        }
      });
    } else {
      //he has account => log out

      Navigator.of(context).pushNamed('/userProfile');
      //Not Logout , we will navigate newuser profile

    }
  }
}
