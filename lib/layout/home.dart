import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:halamanutama/database/database.dart';
import 'package:halamanutama/models/task.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _tasksByDate = {};
  String? _task;

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
                    child: Column(
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => AlertDialog(
                                    title: const Text("Add Task"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              _task = value;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Subscribe...',
                                          ),
                                        ),
                                        MaterialButton(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          onPressed: () {
                                            if (_task == null ||
                                                _task!.isEmpty) {
                                              return;
                                            }
                                            _databaseService.addTask(_task!);
                                            setState(() {
                                              _task = null;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Add",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            );
                          },
                          child: const Icon(Icons.add),
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
                          FutureBuilder(
                            future: _databaseService.getTasks(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Text(
                                  "Belum ada tugas.",
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  Task task = snapshot.data![index];
                                  return ListTile(
                                    leading: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _databaseService.deleteTask(task.id);
                                        setState(() {});
                                      },
                                    ),
                                    title: Text(task.content),
                                    trailing: Checkbox(
                                      value: task.status == 1,
                                      onChanged: (value) {
                                        _databaseService.updateTaskStatus(
                                          task.id,
                                          value == true ? 1 : 0,
                                        );
                                        setState(() {});
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        items: [TabItem(icon: Icons.home, title: 'Home')],
        backgroundColor: const Color(0xFF4949B1),
        onTap: (int i) => print('click index=$i'),
      ),
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
