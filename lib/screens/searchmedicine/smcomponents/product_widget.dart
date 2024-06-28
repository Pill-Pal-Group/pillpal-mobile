import 'dart:math';

import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  final String image;
  final String medicineName;
  final bool rqr;
  const ProductWidget(
      {super.key, required this.image, required this.medicineName,required this.rqr});
  final String oke = "Thuốc đại trà";
  final String notoke = "Thuốc kê đơn";
  
  @override
  Widget build(BuildContext context) {
    String? textne;
    void okenene(){
    if(rqr){
      textne = oke;
    }else{
      textne = notoke;
    }
  }
   okenene();
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // Ảnh
          Align(
            alignment: Alignment.topCenter,
            child: Transform.rotate(
                angle: 2.05 * pi,
                child: Image.network(
                  image, //url,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset("assets/picture/wsa.jpg");
                  },
                  height: 80,
                )),
          ),

          //thông tin mô tả
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  // product based box shadow
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicineName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    softWrap: false,
                  ),
                  const SizedBox(height: 5),
                  Text(textne ?? "oke"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
