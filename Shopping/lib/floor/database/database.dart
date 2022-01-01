
//Need import
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter_shopping_app/floor/dao/CartDao.dart';
import 'package:flutter_shopping_app/floor/entity/CartProduct.dart';
import 'package:sqflite/sqflite.dart' as sqflite;  //need as sqlfile here

part 'database.g.dart';  //generate code

@Database(version:1 , entities: [Cart])
abstract class AppDatabase extends FloorDatabase{
  CartDao get cartDao;

}