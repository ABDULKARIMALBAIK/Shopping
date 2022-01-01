
import 'package:floor/floor.dart';
import 'package:flutter_shopping_app/floor/entity/CartProduct.dart';


@dao
abstract class CartDao {

  @Query("SELECT * FROM Cart WHERE uid=:uid")
  Stream<List<Cart>> getAllItemInCartByUid(String uid);

  @Query("SELECT * FROM Cart WHERE uid=:uid AND productId=:id AND size=:size")
  Future<List<Cart>> getItemInCartByUid(String uid , int id , String size);

  @Query("DELETE FROM Cart WHERE uid=:uid")
  Future<List<Cart>> clearCartByUid(String uid);

  @Query("UPDATE Cart SET uid=:uid")
  Future<void> updateUidCart(String uid);

  @insert
  Future<void> insertCart(Cart product);

  @update
  Future<void> updateCart(Cart product);

  @delete
  Future<void> deleteCart(Cart product);

}