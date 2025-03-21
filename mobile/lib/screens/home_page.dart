import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/Colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stack wrapped in a SizedBox to define its height
        SizedBox(
          height: 150, // Adjust this height to match your needs
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              // Orange Rectangle
              IntrinsicHeight(
                child: Container(
                  width: double.infinity,
                  color: Color(0xFFFFEAD5),
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Conectando estudantes na busca de',
                        style: TextStyle(
                          color: AppColors.primaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                        ),
                        children: [
                          TextSpan(
                            text: ' companheiros de quarto',
                            style: TextStyle(
                              color: AppColors.primaryOrangeColor,
                              fontWeight: FontWeight.bold,
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
                top: null,
                bottom: 0,
                child: Image.asset(
                  'lib/assets/images/home/imageHome1.png',
                  width: 217,
                  height: 35,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        // Expanded widget below the Stack
        Expanded(
            child: Text('Rest of the content goes here'),

        ),
      ],
    );
  }
}