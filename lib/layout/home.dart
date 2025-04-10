import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../services/GoogleCalendar.dart';
import 'fitur.dart';
import 'todo_list.dart';
import 'memo.dart';
=======
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GoogleCalendarService _calendarService = GoogleCalendarService();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _tasksByDate = {};
  String? _memoTitle;
  String? _memoDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA7BCDA), Color(0xFF909BE3), Color(0xFF4949B1)],
            stops: [0.0, 0.48, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/clock_books.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildBlurContainer(
                    child: Column(
                      children: [
                        TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          selectedDayPredicate:
                              (day) => isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            print("Tanggal dipilih: $selectedDay");

                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, events) {
                              if (_tasksByDate[date] != null &&
                                  _tasksByDate[date]!.isNotEmpty) {
                                return Positioned(
                                  right: 1,
                                  bottom: 1,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          calendarStyle: CalendarStyle(
                            selectedDecoration: BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        Text(
                          "Dipilih: ${_selectedDay != null ? DateFormat.yMMMMd('id').format(_selectedDay!) : 'Belum dipilih'}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _focusedDay = DateTime.now();
                              _selectedDay = DateTime.now();
                            });
                          },
                          style: TextButton.styleFrom(
                            // ignore: deprecated_member_use
                            backgroundColor: Colors.white.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Hari Ini",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildBlurContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          backgroundColor: Colors.white.withOpacity(0.3),
                          elevation: 5,
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => fiturScreen(),
                              ),
                            );

                            if (result != null &&
                                result is Map<String, dynamic>) {
                              setState(() {
                                final date = result['date'] as DateTime;
                                final task = result['task'] as String;

                                // Tambahkan tugas ke tanggal yang sesuai
                                if (_tasksByDate[date] == null) {
                                  _tasksByDate[date] = [];
                                }
                                _tasksByDate[date]!.add(task);
                              });
                            }
                          },
                          child: const Icon(
                            Icons.note_add,
                            color: Colors.white,
                          ),
                        ),

                        FloatingActionButton(
                          backgroundColor: Colors.white.withOpacity(0.3),
                          elevation: 5,
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MemoScreen(),
                              ),
                            );

                            if (result != null &&
                                result is Map<String, String>) {
                              setState(() {
                                _memoTitle = result['title'];
                                _memoDetail = result['detail'];
                              });
                            }
                          },
                          child: const Icon(
                            Icons.note_add,
                            color: Colors.white,
                          ),
                        ),

                        FloatingActionButton(
                          backgroundColor: Colors.white.withOpacity(0.3),
                          elevation: 5,
                          onPressed: () async {
                            try {
                              await _calendarService.signInAndGetEvents();
                            } catch (e) {
                              print('Error in button press: $e');
                              // Tambahkan ScaffoldMessenger untuk menampilkan error ke user
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                          child: const Icon(Icons.event, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildBlurContainer(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Catatan",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      if (_memoTitle != null && _memoDetail != null)
                        Column(
                          children: [
                            Text(
                              _memoTitle!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _memoDetail!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      else
                        const Text(
                          "Belum ada catatan.",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                    ],
                  ),
                ),
              ),
            ),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
      items: [
      TabItem(icon: Icons.home, title: 'Home')
      ],
      backgroundColor: const Color(0xFF4949B1),
      // ignore: avoid_print
      onTap: (int i) => print('click index=$i'),
    )
    );
  }

  Widget _buildBlurContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: child,
        ),
      ),
    );
  }
}
