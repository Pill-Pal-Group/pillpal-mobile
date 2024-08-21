import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillpalmobile/constants.dart';

class MsButton extends StatelessWidget {
  final String lable;
  final Function()? onTap;
  const MsButton({
    super.key,
    required this.lable,
    required this.onTap
    
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: primaryClr
          ),
          child: Center(
            child: Text(
              lable,
              style: const TextStyle(
                color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }
}