import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:mobile/models/student_model.dart';
import 'package:mobile/services/student_service.dart';
import 'dart:convert';
// Import the MapPage
import 'map_page.dart'; // Adjust the import path as needed for your project structure

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final CardSwiperController controller;
  final StudentService _studentService = StudentService();
  List<Student> students = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    controller = CardSwiperController();
    _loadStudents();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Fetch students from the service
      final fetchedStudents = await _studentService.fetchStudents();
      setState(() {
        students = fetchedStudents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load students: $e';
        isLoading = false;
      });
      print('Error loading students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : errorMessage.isNotEmpty
          ? _buildErrorView()
          : students.isEmpty
          ? _buildEmptyView()
          : _buildSwipeView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.orange, size: 60),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadStudents,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off, color: Colors.orange, size: 60),
          const SizedBox(height: 16),
          const Text(
            'No students found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check back later for potential matches',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadStudents,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 500, // Adjust height as needed
            width: 340,  // Adjust width as needed
            child: CardSwiper(
              controller: controller,
              cardsCount: students.length,
              cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                return _buildProfileCard(students[index]);
              },
              onSwipe: (previousIndex, currentIndex, direction) {
                print('Profile $previousIndex was swiped $direction');
                return true;
              },
            ),
          ),
          const SizedBox(height: 20),
          // Swipe buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Existing swipe buttons row
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
              const SizedBox(height: 20), // Add some vertical spacing
              // Mapa button - Updated with navigation to MapPage
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to MapPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapPage()),
                  );
                },
                icon: const Icon(Icons.map, color: Colors.white),
                label: const Text('Mapa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Student student) {
    // Calculate age based on birthDate
    final int age = DateTime.now().year - student.birthDate.year;

    // Check if student has an image
    String imageSource = '';
    Widget profileImage;

    if (student.image != null && student.image!.imageData64.isNotEmpty) {
      // Use base64 image data
      profileImage = Container(
        height: 140,
        width: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: MemoryImage(base64Decode(student.image!.imageData64)),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // Use placeholder image
      profileImage = Container(
        height: 140,
        width: 140,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('lib/assets/images/search/profile1.png'),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Photo (Circle at the top)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: profileImage,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Wrap(
                spacing: 4.0,
                children: _buildInterestChips(student.personalities.toList()),
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
                  '${student.userName}, $age - ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  student.collegeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                if (student.collegeName == 'FACENS')
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
              student.description,
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
                print('Ver mais clicked for ${student.userName}');
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
        backgroundColor: Colors.grey.withOpacity(0.1), // Very light grey
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