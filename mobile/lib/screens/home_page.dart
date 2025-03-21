//HOME PAGE
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/Colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Orange Rectangle
        IntrinsicHeight(
          child: Container(
            width: double.infinity, // Takes all available horizontal space
            // Set a fixed height
            color: Color(0xFFFFEAD5), // Orange background color
            padding: EdgeInsets.all(16), // Add padding inside the container
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,

                text: TextSpan(
                  text: 'Conectando estudantes na busca de',
                  style: TextStyle(color: AppColors.primaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 27), // Default style
                  children: [
                    TextSpan(
                      text: ' companheiros de quarto',
                      style: TextStyle(color: AppColors.primaryOrangeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 27),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Add other widgets below the orange rectangle
           Center(
            child: Text('Rest of the content goes here'),
          ),

      ],
    );
  }
}