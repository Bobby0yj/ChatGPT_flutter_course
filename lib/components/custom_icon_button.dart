import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {

  final IconData icon;
  final Function onPress;

  CustomIconButton({
    required this.icon,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3B3B3B),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: IconButton(
        onPressed: (){
          onPress();
        },
        icon: Icon(icon, color: Colors.white,),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF3B3B3B)),
          elevation: MaterialStateProperty.all(4.0),
        ),
      ),
    );
  }
}