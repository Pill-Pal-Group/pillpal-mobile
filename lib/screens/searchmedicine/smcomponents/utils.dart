import 'package:flutter/material.dart';
import 'package:pillpalmobile/constants.dart';

final boxShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 1,
    spreadRadius: 1,
    offset: const Offset(1, 1),
  ),
];

Widget iconWidget(IconData icon, bool dotExists) {
  return Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: boxShadow,
      shape: BoxShape.circle,
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(icon),
        if (dotExists)
          Positioned(
            right: 12,
            top: 15,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    ),
  );
}

const Color primary = Color(0xFF1FCC79);
const Color Secondary = Color(0xFFFF6464);
const Color mainText = Color(0xFF2E3E5C);
const Color SecondaryText = Color(0xFF9FA5C0);
const Color outline = Color(0xFFD0DBEA);
const Color form = Color(0xFFF4F5F7);

