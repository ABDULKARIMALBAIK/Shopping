
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shopping_app/const/ConstApp.dart';
import 'package:flutter_shopping_app/const/Utils.dart';
import 'package:flutter_shopping_app/floor/dao/CartDao.dart';
import 'package:flutter_shopping_app/floor/entity/CartProduct.dart';
import 'package:flutter_shopping_app/model/Category.dart';
import 'package:flutter_shopping_app/model/Product.dart';
import 'package:flutter_shopping_app/model/SizeModel.dart';
import 'package:flutter_shopping_app/model/SubCategories.dart';
import 'package:flutter_shopping_app/network/api_request.dart';
import 'package:flutter_shopping_app/state/StateManagement.dart';
import 'package:flutter_shopping_app/widgets/ProductCard.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_shopping_app/widgets/SizeWidget.dart';

class ProductDetailsScreen extends ConsumerWidget{

  final CartDao dao;

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  //Ignore: top_level_function_literal_block
  final _fetchProductById = FutureProvider.family<Product , int>((ref,id) async {
    var result = await fetchProductDetails(id);
    return result;
  });


  ProductDetailsScreen(this.dao);

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    var productsApiResult = watch(_fetchProductById(context.read(productSelected).state.productId));
    var _productSizeSelected = watch(productSizeSelected).state;  //Listen change to re-render


    return Scaffold(
        key: _key,
        body: Builder(
          builder: (context){
            return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                        child: productsApiResult.when(
                            loading: () => Center(child: CircularProgressIndicator(),),
                            error: (error,stack) => Center(child: Text('$error'),),
                            data: (Product product) => SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CarouselSlider(
                                          items: product.productImages.map((e) => Builder(
                                            builder: (context){
                                              return Container(
                                                child: Image(image: NetworkImage(e.imgUrl), fit: BoxFit.fill,),
                                              );
                                            },
                                          )).toList(),
                                          options: CarouselOptions(
                                              height: MediaQuery.of(context).size.height/3*2.5,
                                              autoPlay: true,
                                              viewportFraction: 1,
                                              initialPage: 0
                                          ))
                                    ],
                                  ),
                                  ///////////////// * Name of Product * /////////////////
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('${product.productName}' , style: TextStyle(fontSize: 20),),
                                  ),
                                  ///////////////// * Price of Product * /////////////////
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text.rich(
                                            TextSpan(children: [
                                              TextSpan(
                                                  text: product.productOldPrice == 0 ? '' : '${product.productOldPrice} \$ / ',
                                                  style: TextStyle(color: Colors.red, decoration: TextDecoration.lineThrough , fontSize: 27)
                                              ),
                                              TextSpan(
                                                  text: '${product.productNewPrice} \$',
                                                  style: TextStyle(fontSize: 27 , color: Theme.of(context).primaryColor)
                                              ),
                                            ])
                                        )
                                      ],
                                    ),
                                  ),
                                  ///////////////// * Details Short * /////////////////
                                  Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text('${product.productShortDescription}',
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.justify,
                                      )
                                  ),
                                  ///////////////// * Size Title * /////////////////
                                  Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text('Size',
                                        style: TextStyle(fontSize: 26 , fontWeight: FontWeight.bold),  //decoration: TextDecoration.underline
                                        textAlign: TextAlign.justify,
                                      )
                                  ),
                                  ///////////////// * Check size of product & list of sizes * /////////////////
                                  product.productSizes != null ?
                                  Wrap(children: product.productSizes.map((size) =>
                                      GestureDetector(
                                          onTap: size.number > 0 ?  (){

                                            //If Size Number > 0 , we will add event
                                            context.read(productSizeSelected).state = size;
                                          } : null,
                                          child: SizeWidget(SizeModel(_productSizeSelected.size == size.size,size),size))
                                  ).toList(),
                                  )
                                      :
                                  Container(),

                                  ///////////////// * Waring Text * /////////////////
                                  _productSizeSelected.number != null && _productSizeSelected.number <= 5 ?
                                  Center(
                                    child: Text(
                                      'Only ${_productSizeSelected.number} left in stock',
                                      style: TextStyle(fontSize: 20 , color: Colors.red),
                                    ),
                                  ) : Container(),

                                  ///////////////// * Buttons * /////////////////
                                  Column(children: [
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                      child: RaisedButton(
                                        color: Colors.black,
                                        elevation: 8,
                                        onPressed: _productSizeSelected.size == null? null : () async {    //Condition means if we haven't choose size , we can't click button
                                          try {
                                            //Get Product
                                            //Default , we don't implemet SIGN In SYSTEM , so is null now aor any we want
                                            var cartProduct = await dao.getItemInCartByUid(
                                              context.read(userLogged).state != null ? context.read(userLogged).state!.uid : NOT_SIGN_IN,
                                              product.productId,
                                              context.read(productSizeSelected).state.size.sizeName
                                            );
                                            if(cartProduct.length > 0){

                                              //If already available item in cart
                                              cartProduct[0].quantity += 1;
                                              await dao.updateCart(cartProduct[0]);
                                              showSnackBarWithViewBag(_key ,context , 'Update item in bag successfully');
                                            }
                                            else {
                                              print('check dao is work here 4.5');
                                              Cart cart = new Cart(
                                                product.productId,
                                                context.read(userLogged).state != null ? context.read(userLogged).state!.uid : NOT_SIGN_IN,
                                                product.productName,
                                                product.productImages[0].imgUrl,
                                                _productSizeSelected.size.sizeName,
                                                product.productCode,
                                                product.productNewPrice,
                                                1
                                              );

                                              await dao.insertCart(cart);
                                              showSnackBarWithViewBag(_key ,context , 'Add item in bag successfully');
                                            }
                                          }
                                          catch(e){showOnlySnackBar(_key , context , '${e.toString()}');}
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Add To Bag' , style: TextStyle(color: Colors.white , fontSize: 19),),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: RaisedButton(
                                            color: Colors.black,
                                            elevation: 8,
                                            onPressed: () => print('Click Wishlist'),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Wishlist' , style: TextStyle(color: Colors.white , fontSize: 16),),
                                            ),
                                          )),
                                          SizedBox(width: 20,),
                                          Expanded(child: RaisedButton(
                                            color: Colors.black,
                                            elevation: 8,
                                            onPressed: () => print('Notify Me'),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Notify Me' , style: TextStyle(color: Colors.white , fontSize: 16),),
                                            ),
                                          )),
                                        ],
                                      ),
                                    )
                                  ],),
                                  ///////////////// * Details Title * /////////////////
                                  Padding(
                                      padding: EdgeInsets.symmetric(vertical:  8, horizontal: 8),
                                      child: Text('Details',
                                        style: TextStyle(fontSize: 26 , fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.justify,
                                      )
                                  ),
                                  ///////////////// * Details Description * /////////////////
                                  Padding(
                                      padding: EdgeInsets.symmetric(vertical:  8, horizontal: 12),
                                      child: Text('${product.productDescription}',
                                        style: TextStyle(fontSize: 20 , ),  //decoration: TextDecoration.underline
                                        textAlign: TextAlign.justify,
                                      )
                                  ),
                                ],
                              ),
                            )
                        )
                    )
                  ],
                )
            );
          },
        )
    );


  }

  _makeDrawer(AsyncValue<List<CategoryShop>> categoriesApiResult) {

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
                          Text(categories[index].categoryName) :
                          Text(categories[index].categoryName , style: TextStyle(fontSize: 12),)
                        ],
                      ),
                      children: [
                        _buildList(categories[index])
                      ],
                    ),
                  ),
                );
              })),
    );

  }


  _buildList(CategoryShop category) {

    var list = <Widget>[];
    List<SubCategories> castSubCategories = category.subCategories;
    castSubCategories.forEach((element) {
      list.add(
          Padding(padding: EdgeInsets.all(8),
            child: Text(element.subCategoryName , style: TextStyle(fontSize: 12),), )
      );
    });

    return list;
  }

}