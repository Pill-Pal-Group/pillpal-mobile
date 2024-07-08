import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillpalmobile/constants.dart';

class MsInputFeild extends StatelessWidget {
  final String tittle;
  final String hint;
  final TextEditingController? controller;
  final TextInputType type;
  final Widget? widget;
  const MsInputFeild({
    super.key,
    required this.tittle,
    required this.hint,
    required this.type,
    this.controller,
    this.widget
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tittle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 14.0),
            //color: Colors.grey,
            decoration: BoxDecoration(
              border: Border.all(
                color:  Colors.grey,
                width: 1.0
              ),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget==null?false:true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode? Colors.grey[100]:Colors.grey[700],
                    controller: controller,
                    keyboardType: type,
                    style: subtitlestyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subtitlestyle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0
                        )
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0
                        )
                      )
                    ),
                  ),
                  ),

                  widget==null?Container():Container(child: widget,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
