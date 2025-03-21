import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/Colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stack to overlap the image and the rectangle
        Stack(
          alignment: Alignment.topCenter, // Align the stack to the top
          clipBehavior: Clip.none, // Allow the image to overflow
          children: [
            // Orange Rectangle
            IntrinsicHeight(
              child: Container(
                width: double.infinity, // Takes all available horizontal space
                color: Color(0xFFFFEAD5), // Orange background color
                padding: EdgeInsets.all(16), // Add padding inside the container
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Conectando estudantes na busca de',
                      style: TextStyle(
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        fontSize: 27,
                      ), // Default style
                      children: [
                        TextSpan(

                          text: ' companheiros de quarto',
                          style: TextStyle(
                            color: AppColors.primaryOrangeColor,

                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            fontSize: 27,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Image that invades the rectangle from below
            Positioned(
              top: null, // Do not set top (let it flow naturally)
              bottom: -20, // Adjust this value to overlap by 50% of the image height
              child: Image.asset(
                'lib/assets/images/home/imageHome1.png', // Path to your image
                width: 217, // Set image width
                height: 35, // Set image height
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        // Add other widgets below the stack (if needed)
        // Example:
        // Expanded(
        //   child: Center(
        //     child: Text('Rest of the content goes here'),
        //   ),
        // ),
      ],
    );
  }
}