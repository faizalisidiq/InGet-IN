import 'package:flutter/material.dart';
import 'todo_list.dart';
import 'memo.dart';
import 'dart:async';

class fiturScreen extends StatefulWidget {
  const fiturScreen({super.key});

  @override
  State<fiturScreen> createState() => _FiturScreenState();
}

class _FiturScreenState extends State<fiturScreen> {
  late DateTime _currentDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();

    // Mengupdate tanggal setiap menit
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _currentDate = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Format tanggal ke format Indonesia
  String _formatDate(DateTime date) {
    final months = [
      'JANUARI',
      'FEBRUARI',
      'MARET',
      'APRIL',
      'MEI',
      'JUNI',
      'JULI',
      'AGUSTUS',
      'SEPTEMBER',
      'OKTOBER',
      'NOVEMBER',
      'DESEMBER',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7B7FDA), Color(0xFF474E98)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Spacer(),
                    const Text(
                      'HARI INI',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balance with back button
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Text(
                  _formatDate(_currentDate),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 60),
              FeatureButton(
                title: 'To-Do-List',
                iconPath: 'assets/images/todo_icon.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TodoListScreen()),
                  );
                },
              ),
              const SizedBox(height: 30),
              FeatureButton(
                title: 'Memo',
                iconPath: 'assets/images/memo_icon.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MemoScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onPressed;

  const FeatureButton({
    required this.title,
    required this.iconPath,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.more_vert, color: Colors.white, size: 24),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gunakan Icon sebagai placeholder jika image tidak tersedia
                    title == 'To-Do-List'
                        ? const Icon(
                          Icons.check_box,
                          color: Colors.white,
                          size: 40,
                        )
                        : const Icon(Icons.note, color: Colors.white, size: 40),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
