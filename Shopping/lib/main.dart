import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart' if (dart.library.html) 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shopping_app/firebase/FirebaseNotificationHandler.dart';
import 'package:flutter_shopping_app/floor/database/database.dart';
import 'package:flutter_shopping_app/model/Category.dart';
import 'package:flutter_shopping_app/model/FeatureImg.dart';
import 'package:flutter_shopping_app/model/SubCategories.dart';
import 'package:flutter_shopping_app/screens/AdminPanelScreen.dart';
import 'package:flutter_shopping_app/screens/CartDetailsScreen.dart';
import 'package:flutter_shopping_app/screens/CheckOutScreen.dart';
import 'package:flutter_shopping_app/screens/OrderDetailScreen.dart';
import 'package:flutter_shopping_app/screens/OrderHistoryScreen.dart';
import 'package:flutter_shopping_app/screens/ProductDetailsScreen.dart';
import 'package:flutter_shopping_app/screens/ProductListScreen.dart';
import 'package:flutter_shopping_app/screens/RegisterUserScreen.dart';
import 'package:flutter_shopping_app/screens/UserProfileScreen.dart';
import 'package:flutter_shopping_app/state/StateManagement.dart';
import 'package:page_transition/page_transition.dart';

import 'firebase/NotificationHandler.dart';
import 'floor/dao/CartDao.dart';
import 'network/api_request.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder("shopping_database.db")
  .build();

  Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final dao = database.cartDao;
  runApp(ProviderScope(child: MyApp(dao)));
}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  //Check Notification for Android/IOS OS
  if(Platform.isAndroid){
    showNotification(message.notification!.title , message.notification!.body);
  }
  else if(Platform.isIOS){
    showNotification(message.notification!.title , message.notification!.body);
  }

}


void showNotification(title, content) async {  //com.abdulkarimalbaik.flutter_shopping_app

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com.abdulkarimalbaik.flutter_shopping_app',
      'Shopping',
      'Description',
      autoCancel: false,
      ongoing: true,
      importance: Importance.max,
      priority: Priority.high);

  var iosPlatformSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics , iOS: iosPlatformSpecifics);

  await NotificationHandler.flutterLocalNotificationPlugin.show(
      Random().nextInt(1000),
      title,
      content,
      platformChannelSpecifics,
      payload: 'Payload');
}



class MyApp extends StatelessWidget {

  final CartDao dao;


  MyApp(this.dao);

  @override
  Widget build(BuildContext context) {
    print('start app');

    return MaterialApp(
      title: 'Shopping',
      onGenerateRoute: (settings){
        switch(settings.name){
          case '/productList':{
            return PageTransition(
                child: ProductListScreen(dao),
                type: PageTransitionType.fade,
                settings: settings);
          }
          case '/productDetails':{
            return PageTransition(
                child: ProductDetailsScreen(dao),
                type: PageTransitionType.fade,
                settings: settings);
          }
          case '/cartDetail':{
            return PageTransition(
                child: CartDetailsScreen(dao),
                type: PageTransitionType.fade,
                settings: settings);
          }
          case '/registerUser':{
            return PageTransition(
                child: RegisterUserScreen(),
                type: PageTransitionType.fade,
                settings: settings);
          }
          case '/userProfile':{
            return PageTransition(
                child: UserProfileScreen(),
                type: PageTransitionType.fade,
                settings: settings);
          }
          case '/checkOut':{
            return PageTransition(
                child: CheckOutScreen(dao),
                type: PageTransitionType.fade,
                settings: settings);
          }
          case '/orders':{
            return PageTransition(
                child: OrderHistoryScreen(),
                type: PageTransitionType.fade,
                settings: settings);
          }
          case '/orderDetail':{
            return PageTransition(
                child: OrderDetailScreen(),
                type: PageTransitionType.fade,
                settings: settings);
          }
          case '/adminPage':{
            return PageTransition(
                child: AdminPanelScreen(),
                type: PageTransitionType.fade,
                settings: settings);
          }
          default:{
            return null;
          }
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {

  //Init Firebase FCM Object
  FirebaseNotification firebaseNotification = new FirebaseNotification();

  //Ignore: top_level_function_literal_block
  final _fetchBanner = FutureProvider((ref) async {
    var result = await fetchBanner();
    return result;
  });


  //Ignore: top_level_function_literal_block
  final _fetchFeatureImg = FutureProvider((ref) async {
    var result = await fetchFeatureImages();
    return result;
  });

  //Ignore: top_level_function_literal_block
  final _fetchCategories = FutureProvider((ref) async {
    var result = await fetchCategories();
    return result;
  });

  //Ignore: top_level_function_literal_block
  final _initFirebase = FutureProvider((ref) async {
    var result = await Firebase.initializeApp();
    return result;
  });

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    var bannerApiResult = watch(_fetchBanner);
    var featureImgApiResult = watch(_fetchFeatureImg);
    var categoriesApiResult = watch(_fetchCategories);
    var initApp = watch(_initFirebase);

    if(!context.read(isInitFCM).state){

      Future.delayed(Duration.zero,(){
        firebaseNotification.setupFirebase(context);
        context.read(isInitFCM).state = true;
      });

    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: _makeDrawer(context , categoriesApiResult),
      body: SafeArea(
        child: Column(
          children: [
            //Feature Images
            featureImgApiResult.when(
                data: (featureImages) =>
                    Stack(
                      children: [
                        CarouselSlider(
                            items: featureImages.map((e) =>
                                Builder(
                                    builder: (context) =>
                                        Container(child: Image(
                                          image: NetworkImage(e.featureImgUrl),
                                          fit: BoxFit.cover,
                                        ),))
                            ).toList(),
                            options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                initialPage: 0,
                                viewportFraction: 1
                            )
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Drawer Button
                            IconButton(
                                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                                icon: Icon(Icons.menu , size: 26 , color: Colors.black,)),
                            SizedBox(height: 50,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.navigate_before,size: 50,color: Colors.white,),
                                Icon(Icons.navigate_next,size: 50,color: Colors.white,)

                              ],
                            )
                          ],
                        )
                      ],
                    ),
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error,stack) => Center(child: Text('$error'),)
            ),
            Expanded(
                child: bannerApiResult.when(
                    loading: () => Center(child: CircularProgressIndicator(),),
                    error: (error,stack) => Center(child: Text('$error'),),
                    data: (bannerImages) => ListView.builder(
                      itemCount: bannerImages.length,
                      itemBuilder: (context,index){
                        return Container(child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image(image: NetworkImage(bannerImages[index].bannerImgUrl),fit: BoxFit.cover,),
                            Container(
                              color: Color(0xDD333639),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(bannerImages[index].bannerText , style: TextStyle(color: Colors.white),),
                            ),
                          )
                          ],
                        ),
                    );
    })
                )
            )
          ],
        ),
      ),
    );
  }

  _makeDrawer(BuildContext context , AsyncValue<List<CategoryShop>> categoriesApiResult) {

    return Drawer(
      child: categoriesApiResult.when(
        loading: () => Center(child: CircularProgressIndicator(),),
        error: (error,stack) => Center(child: Text('$error'),),
        data: (categories) => ListView.builder(
            itemCount:  categories.length,
            itemBuilder: (context,index){
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        CircleAvatar(backgroundImage: NetworkImage(categories[index].categoryImg),),
                        SizedBox(width: 30,),
                        (categories[index].categoryName as String).length <= 10 ?
                          Text(categories[index].categoryName , overflow: TextOverflow.ellipsis,) :
                          Text(categories[index].categoryName, overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 9),)
                      ],
                    ),
                    children: _buildList(context,categories[index]),
                  ),
                ),
              );
            })),
    );

  }

  _buildList(BuildContext context,CategoryShop category) {

    var list = <Widget>[];
    List<SubCategories> castSubCategories = category.subCategories;
    castSubCategories.forEach((element) {
      list.add(
        GestureDetector(
          onTap: (){
            print('tap on ${element.subCategoryName}');
            context.read(subCategorySelected).state = element;
            Navigator.pushNamed(context, '/productList');
          },
          child: Padding(padding: EdgeInsets.all(8),
            child: Text(element.subCategoryName , style: TextStyle(fontSize: 12),), ),
        )
      );
    });

    return list;
  }

}


