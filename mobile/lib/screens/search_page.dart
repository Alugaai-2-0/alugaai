//HOME PAGE
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final CardSwiperController controller;

  @override
  void initState() {
    super.initState();
    controller = CardSwiperController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sample profile data - you can replace with your actual data
    List<Map<String, dynamic>> profiles = [
      {
        'name': 'Fernando Soares',
        'age': 27,
        'college': 'FACENS',
        'photo': 'lib/assets/images/search/profile2.png', // Replace with your image path
        'description': 'Sou Fernando Soares, estudante tranquilo e reservado. Nas horas vagas...',
        'interests': ['Estudar', 'Ler', 'Harry Potter', 'Silêncio', 'Animado', 'Música', 'Animais', 'Games', 'Organizado', 'Cordial', 'Exercícios Físicos']
      },
      {
        'name': 'Maria Silva',
        'age': 24,
        'college': 'USP',
        'photo': 'lib/assets/images/search/profile1.png', // Replace with your image path
        'description': 'Estudante de engenharia, amo música e passar tempo com amigos...',
        'interests': ['Música', 'Viagens', 'Cinema', 'Leitura', 'Tecnologia']
      }

    ];

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 550, // Adjust height as needed
              width: 340,  // Adjust width as needed
              child: CardSwiper(
                controller: controller,
                cardsCount: profiles.length,
                cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                  return _buildProfileCard(profiles[index]);
                },
                onSwipe: (previousIndex, currentIndex, direction) {
                  print('Profile $previousIndex was swiped $direction');
                  return true;
                },
              ),
            ),
            const SizedBox(height: 20),
            // Swipe buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dislike button (X)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.orange),
                    onPressed: () {
                      controller.swipe(CardSwiperDirection.left);
                    },
                    iconSize: 30,
                  ),
                ),
                const SizedBox(width: 40),
                // Like button (check)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check, color: Colors.orange),
                    onPressed: () {
                      controller.swipe(CardSwiperDirection.right);
                    },
                    iconSize: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    return Card(
      elevation: 4,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white, //
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Photo (Circle at the top)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(profile['photo']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: _buildInterestChips(profile['interests']),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Name, age and college
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Text(
                  '${profile['name']}, ${profile['age']} - ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  profile['college'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                if (profile['college'] == 'FACENS')
                  const Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Icon(Icons.verified, color: Colors.orange, size: 18),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              profile['description'],
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Ver mais button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextButton(
              onPressed: () {
                // You'll implement this later as mentioned
                print('Ver mais clicked for ${profile['name']}');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              child: const Text(
                'Ver mais',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInterestChips(List<dynamic> interests) {
    return interests.map((interest) {
      return Chip(
        label: Text(
          interest,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87, // Darker text for better contrast
          ),
        ),
        backgroundColor: Colors.grey.withValues(alpha: 0.1), // Very light grey, almost transparent
        side: BorderSide.none, // Remove the border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounder corners
        ),
        padding: const EdgeInsets.all(3),
        labelPadding: const EdgeInsets.symmetric(horizontal: 3),
      );
    }).toList();
  }
}