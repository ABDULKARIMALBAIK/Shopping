import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shopping_app/const/ConstApp.dart';
import 'package:flutter_shopping_app/const/ScreenConst.dart';
import 'package:flutter_shopping_app/model/OrderModel.dart';
import 'package:flutter_shopping_app/model/Product.dart';
import 'package:flutter_shopping_app/model/ProductSizes.dart';
import 'package:flutter_shopping_app/model/SizeProd.dart';
import 'package:flutter_shopping_app/model/SubCategories.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter_shopping_app/model/UserModel.dart';

final subCategorySelected = StateProvider((ref) => SubCategories());

final productSelected = StateProvider((ref) => Product(productImages: [] , productSizes: [], productId: 0));

final productSizeSelected = StateProvider((ref) => ProductSizes(size: SizeProd()));

final userLogged = StateProvider((ref) => FirebaseAuth.FirebaseAuth.instance.currentUser);

final isInitFCM = StateProvider((ref) => false);

final userToken = StateProvider((ref) => 'none');

final userUpdate = StateProvider((ref) => false);

final selectedOrder = StateProvider((ref) => OrderModel(
  uid: NOT_SIGN_IN,
  orderName: 'UnKnown',
  orderPhone: '+18888888888',
  orderAddress: 'Not Implemented',
  orderNumber: 00000,
  orderStatus: 0,
  orderAmount: 0,
  orderTransactionId: '0000',
  orderDate: DateTime.now().toString(),
  orderDetails: []
));

final adminNavigationMenu = StateProvider((ref) => AdminScreen.HOME);

final userLoggedInfo = StateProvider((ref) => UserModel(
    'uid',
    'name',
    'phone',
    'token',
    0.0));

final forceLoopReload = StateProvider((ref) => false);


final orderChange = StateProvider((ref) => OrderModel(
    uid: NOT_SIGN_IN,
    orderName: 'UnKnown',
    orderPhone: '+18888888888',
    orderAddress: 'Not Implemented',
    orderNumber: 00000,
    orderStatus: 0,
    orderAmount: 0,
    orderTransactionId: '0000',
    orderDate: DateTime.now().toString(),
    orderDetails: []
));



final dataLoadState = StateProvider((ref) => 1);  //Number of Day we will fetch , 1 = Today
