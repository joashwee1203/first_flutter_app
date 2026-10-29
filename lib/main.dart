import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Mobile App Dev - Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const Lab02HomeScreen(),
    );
  }
}

// --- Exercise 2.1: Title Section Widget ---
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const Icon(Icons.star, color: Colors.red),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}

// --- Image Section Widget ---
class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.asset(
          imagePath,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// --- Student Profile Card Widget (Overflow Fixed) ---
class StudentProfileCard extends StatelessWidget {
  const StudentProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/profile.jpeg'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'JOASH WEE JIA SHENG',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Student ID: BCS24090049',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const Divider(height: 20, thickness: 1),
                const Text(
                  ' I Like Babymonster ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  " KPOP the best ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Main Home Screen with Orientation & Pickers (Exercises 2.2 & 2.3) ---
class Lab02HomeScreen extends StatefulWidget {
  const Lab02HomeScreen({super.key});

  @override
  State<Lab02HomeScreen> createState() => _Lab02HomeScreenState();
}

class _Lab02HomeScreenState extends State<Lab02HomeScreen> {
  DateTime? _selectedDate = DateTime.now();
  String _selectedRole = 'Gryffindor';

  // 1. Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 2. Cupertino Date Picker (Modal Sheet)
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate ?? DateTime.now(),
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _selectedDate = newDate);
          },
        ),
      ),
    );
  }

  // 4. Cupertino Wheel Picker (Modal Sheet)
  void _showCupertinoRolePicker(BuildContext context) {
    final List<String> roles = ['Gryffindor', 'Slytherin', 'Ravenclaw', 'Hufflepuff'];
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          onSelectedItemChanged: (int index) {
            setState(() => _selectedRole = roles[index]);
          },
          children: roles.map((role) => Center(child: Text(role))).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  // Exercise 2.2: Portrait View (Stacked Vertically)
  Widget _buildPortraitView() {
    return ListView(
      children: [
        const StudentProfileCard(),
        const TitleSection(
          name: 'UTS, School of Computing & Creative Multimedia',
          location: 'Sibu, Sarawak',
          starCount: 100,
        ),
        const ImageSection(imagePath: 'assets/aurora.jpeg'),
        const SizedBox(height: 16),
        _buildPickersSection(),
      ],
    );
  }

  // Exercise 2.2: Landscape View (Side-by-Side)
  Widget _buildLandscapeView() {
    return Row(
      children: [
        const Expanded(child: StudentProfileCard()),
        Expanded(
          child: ListView(
            children: [
              const TitleSection(
                name: 'UTS, School of Computing & Creative Multimedia',
                location: 'Sibu, Sarawak',
                starCount: 100,
              ),
              const ImageSection(imagePath: 'assets/aurora.jpeg'),
              const SizedBox(height: 16),
              _buildPickersSection(),
            ],
          ),
        ),
      ],
    );
  }

  // Exercise 2.3: Pickers Section UI
  Widget _buildPickersSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Interactive Pickers (Lab 2.3)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Selected Date: ${_selectedDate?.toIso8601String().split('T')[0]}',
              ),
              Text('Selected House: $_selectedRole'),
              const Divider(height: 20),

              // Material Date Picker Button
              ElevatedButton.icon(
                onPressed: () => _selectMaterialDate(context),
                icon: const Icon(Icons.calendar_month),
                label: const Text('Material Date Picker'),
              ),
              const SizedBox(height: 8),

              // Cupertino Date Picker Button
              OutlinedButton.icon(
                onPressed: () => _showCupertinoDatePicker(context),
                icon: const Icon(Icons.ios_share),
                label: const Text('Cupertino Date Picker (Modal Sheet)'),
              ),
              const SizedBox(height: 16),

              // Material DropdownButton
              Row(
                children: [
                  const Text('Material Dropdown: '),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _selectedRole,
                    items: ['Gryffindor', 'Slytherin', 'Ravenclaw', 'Hufflepuff']
                        .map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => _selectedRole = newValue);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Cupertino Wheel Picker Button
              OutlinedButton.icon(
                onPressed: () => _showCupertinoRolePicker(context),
                icon: const Icon(Icons.unfold_more),
                label: const Text('Cupertino House Wheel Picker'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}