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

  // Filter state variables
  double _maxAge = 30;
  List<String> _selectedPersonalities = [];


  // Mock list of available personalities for filtering
  final List<String> _availablePersonalities = [
    // UNIP Students
    'ama cozinhar',
    'gosta de plantas',
    'organizada',
    'gosta de séries',
    'prefere estudar em casa',
    'toca piano',
    'vegana',
    'gamer',
    'programador',
    'noturno',
    'toca guitarra',
    'gosta de animes',
    'pratica e-sports',
    'fã de tecnologia',

    // FACENS Students
    'atleta',
    'madrugador',
    'gosta de esportes',
    'pratica natação',
    'organizado',
    'fã de podcasts',
    'gosta de documentários',
    'músico',
    'artista',
    'criativo',
    'gosta de fotografia',
    'fã de jazz',
    'pratica meditação',
    'vegetariano',
    'dançarina',
    'gosta de viajar',
    'extrovertida',
    'pratica volleyball',
    'ama pets',
    'fã de música pop'
  ];

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

  Future<void> _loadStudents({
    double? maxAge,
    List<String>? personalities,
  }) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      // Fetch students from the service
      final fetchedStudents = await _studentService.fetchStudents(
        maxAge: maxAge?.toInt(),
        personalities: personalities?.toSet(),
      );

      setState(() {
        students = fetchedStudents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Falha ao carregar estudantes: $e';
        isLoading = false;
      });
      print('Falha ao carregar estudantes: $e');
    }
  }

  void _openFilterDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildFilterDrawer(),
      body: Builder(
        builder: (context) => isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.orange))
            : errorMessage.isNotEmpty
            ? _buildErrorView()
            : students.isEmpty
            ? _buildEmptyView()
            : _buildSwipeView(context),
      ),
      // Set resizeToAvoidBottomInset to true to prevent keyboard issues
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildFilterDrawer() {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 30),

              // Max Age Filter
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Idade máxima:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${_maxAge.round()} anos',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _maxAge,
                    min: 18,
                    max: 50,
                    divisions: 32,
                    activeColor: Colors.orange,
                    inactiveColor: Colors.orange.withOpacity(0.2),
                    onChanged: (value) {
                      setState(() {
                        _maxAge = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Personalities Filter
              const Text(
                'Personalidades:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),

              // Custom Autocomplete with all options visible
              LayoutBuilder(
                builder: (context, constraints) {
                  return RawAutocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return _availablePersonalities;
                      }
                      return _availablePersonalities.where((option) {
                        return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      if (!_selectedPersonalities.contains(selection)) {
                        setState(() {
                          _selectedPersonalities.add(selection);

                        });
                      }
                    },
                    fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {

                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: 'Procurar personalidades',
                          suffixIcon: Icon(Icons.search, color: Colors.orange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                        onTap: () {
                          // Show all options when the field is tapped
                          textEditingController.text = '';
                          onFieldSubmitted();
                        },
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 200, // Limit the height of the options list
                              maxWidth: constraints.maxWidth, // Match the width of the text field
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options.elementAt(index);
                                return ListTile(
                                  title: Text(option),
                                  onTap: () {
                                    onSelected(option);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 10),

              // Selected personalities chips
              Wrap(
                spacing: 8.0,
                children: _selectedPersonalities.map((personality) {
                  return Chip(
                    label: Text(personality),
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    deleteIconColor: Colors.orange,
                    onDeleted: () {
                      setState(() {
                        _selectedPersonalities.remove(personality);
                      });
                    },
                  );
                }).toList(),
              ),

              const Spacer(),

              // Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Here you would implement the actual filtering logic
                    Navigator.pop(context);

                    _loadStudents(
                      maxAge: _maxAge,
                      personalities: _selectedPersonalities.isNotEmpty
                          ? _selectedPersonalities
                          : null,
                    );

                    // For now, just close the drawer since we're only mocking the UI
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Aplicar Filtros',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            'Oops! Algo deu errado.',
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
            child: const Text('Tentar novamente'),
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
            'Nenhum estudante encontrado',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Volte depois para matchs em potencial',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadStudents,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Atualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeView(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Filter button at the top of cards
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: ElevatedButton.icon(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.filter_list, color: Colors.white),
                label: const Text('Filtrar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            // Conditional rendering based on number of students
            students.isEmpty
                ? _buildNoCardsView()
                : students.length == 1
                ? _buildSingleCardView(students[0])
                : _buildMultiCardSwiper(),
            const SizedBox(height: 20),
            // Existing swipe buttons and map button (only show if at least one card)
            if (students.isNotEmpty) _buildSwipeControls(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleCardView(Student student) {
    return SizedBox(
      height: 430,
      width: 340,
      child: _buildProfileCard(student),
    );
  }

  Widget _buildMultiCardSwiper() {
    return SizedBox(
      height: 430,
      width: 340,
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
    );
  }

  Widget _buildNoCardsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off, color: Colors.orange, size: 60),
          const SizedBox(height: 16),
          const Text(
            'Nenhum estudante se aplica aos filtros',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tente ajustar seus filtros',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadStudents,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Resetar Filtros'),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeControls(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        const SizedBox(height: 20),
        // Mapa button
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton.icon(
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
        ),
      ],
    );
  }


  Widget _buildProfileCard(Student student) {
    // Calculate age based on birthDate
    final int age = DateTime.now().year - student.birthDate.year;

    // Check if student has an image
    Widget profileImage;

    if (student.image != null && student.image!.imageData64.isNotEmpty) {
      // Use base64 image data
      profileImage = Container(
        height: 120, // Reduced from 140
        width: 120, // Reduced from 140
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
        height: 120, // Reduced from 140
        width: 120, // Reduced from 140
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
      child: Container(
        height: 400, // Fixed height for the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo (Circle at the top)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0), // Reduced from 20
                child: profileImage,
              ),
            ),
            const SizedBox(height: 8), // Reduced from 15
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0, // Add run spacing for better wrapping
                  alignment: WrapAlignment.center,
                  children: _buildInterestChips(student.personalities.toList()),
                ),
              ),
            ),
            const SizedBox(height: 8), // Reduced from 15
            // Name, age and college
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  // Name and age - will take as much space as needed (won't be truncated)
                  Text(
                    '${student.userName}, $age - ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // College name - will expand but can be truncated
                  Expanded(
                    child: Text(
                      student.collegeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                      overflow: TextOverflow.ellipsis,
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
            const SizedBox(height: 8), // Reduced from 10
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
        padding: const EdgeInsets.all(2), // Reduced from 3
        labelPadding: const EdgeInsets.symmetric(horizontal: 2), // Reduced from 3
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Make the chip more compact
      );
    }).toList();
  }
}