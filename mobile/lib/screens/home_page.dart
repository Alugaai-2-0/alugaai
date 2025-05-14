import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/widgets/chat_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        Column(
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const TemosVagasSection(),
                    // Add more content below if needed
                  ],
                ),
              ),
            ),
          ],
        ),

        // Chat widget positioned in bottom right
        const ChatWidget(),
      ],
    );
  }
}

class TemosVagasSection extends StatefulWidget {
  const TemosVagasSection({Key? key}) : super(key: key);

  @override
  State<TemosVagasSection> createState() => _TemosVagasSectionState();
}

class _TemosVagasSectionState extends State<TemosVagasSection> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with star icon and text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Temos vagas',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.circle_outlined,
                  color: Colors.grey.shade300,
                  size: 20,
                ),
              ],
            ),
          ),

          // Tab bar
          Row(
            children: [
              _buildTab('Encontre o seu colega ideal', 0),
              _buildTab('Match por interesses', 1),
            ],
          ),

          // Divider
          Divider(height: 2, thickness: 1, color: Colors.grey.shade200),

          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jornada universitária segura',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Nossa prioridade é garantir um ambiente confiável e protegido para você viver e aproveitar ao máximo sua jornada universitária.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.orange : Colors.transparent,
                width: 2.0,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black87 : Colors.grey,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
