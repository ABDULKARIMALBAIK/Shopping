import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/model/Product.dart';
import 'package:flutter_shopping_app/model/ProductSizes.dart';
import 'package:flutter_shopping_app/model/SizeModel.dart';
import 'package:flutter_shopping_app/state/StateManagement.dart';
import 'package:flutter_riverpod/all.dart';

class SizeWidget extends StatelessWidget{

  final SizeModel sizeModel;
  final ProductSizes productSizes;


  SizeWidget(this.sizeModel, this.productSizes);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 50.0,
      height: 50.0,
      child: Center(
        child:
        Text(sizeModel.productSizes.size.sizeName,
          style: TextStyle(
              color: sizeModel.productSizes.number == 0 ? Colors.white : sizeModel.isSelected ? Colors.white : Colors.black , fontSize: 18),
        ),
      ),
      decoration: BoxDecoration(
        color: sizeModel.productSizes.number == 0 ? Colors.grey : sizeModel.isSelected ? Colors.black : Colors.transparent,
        border: Border.all(width: 1 , color: sizeModel.isSelected ? Colors.black : Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(2))
      ),
    );
  }

}