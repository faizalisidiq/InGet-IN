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
  bool _reminder = false;
  List<String> _reminderList = [];

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
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () => _selectDate(context),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 16,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF5A56D2),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    blurRadius: 10,
                                                    offset: const Offset(5, 5),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    _formatDate(_selectedDay),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Icon(
                                                    Icons.edit_calendar,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),


                                  
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF9DA3FF,
                                                    ),
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        blurRadius: 4,
                                                        offset: const Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  final task =
                                                      'Tugas pada ${_formatDate(_selectedDay)}';
                                                  Navigator.pop(context, {
                                                    'date': _selectedDay,
                                                    'task': task,
                                                  });
                                                },
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF9DA3FF,
                                                    ),
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        blurRadius: 4,
                                                        offset: const Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),

                                    TextField(
                                  onChanged: (value) {
                                    _task = value; // Simpan input pengguna ke variabel _task
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Masukkan tugas baru...",
                                    hintStyle: const TextStyle(color: Colors.black54),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.notifications,
                                                      size: 22,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      'Atur Pengingat',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Switch(
                                                      value: _reminder,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _reminder = value;
                                                          if (!value) {
                                                            _reminderList
                                                                .clear();
                                                          } else if (_reminderList
                                                              .isEmpty) {
                                                            _reminderList.add(
                                                              '15 Menit Sebelum',
                                                            );
                                                          }
                                                        });
                                                      },
                                                      activeColor: Colors.blue,
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: _reminder,
                                                  child: Column(
                                                    children: [
                                                      Column(
                                                        children: List.generate(
                                                          _reminderList.length,
                                                          (index) => Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  left: 40,
                                                                ),
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.alarm,
                                                                  size: 20,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  _reminderList[index],
                                                                  style:
                                                                      const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                ),
                                                                const Spacer(),
                                                                IconButton(
                                                                  icon: const Icon(
                                                                    Icons.close,
                                                                    size: 20,
                                                                  ),
                                                                  onPressed: () {
                                                                    _removeReminder(
                                                                      index,
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      if (_reminderList
                                                          .isNotEmpty)
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 40,
                                                              ),
                                                          child: Divider(
                                                            thickness: 1,
                                                          ),
                                                        ),
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (
                                                                  context,
                                                                ) => SimpleDialog(
                                                                  title: const Text(
                                                                    'Pilih waktu pengingat',
                                                                  ),
                                                                  children: [
                                                                    SimpleDialogOption(
                                                                      onPressed: () {
                                                                        _addReminder(
                                                                          '5 menit sebelum',
                                                                        );
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: const Text(
                                                                        '5 menit sebelum',
                                                                      ),
                                                                    ),
                                                                    SimpleDialogOption(
                                                                      onPressed: () {
                                                                        _addReminder(
                                                                          '10 menit sebelum',
                                                                        );
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: const Text(
                                                                        '10 menit sebelum',
                                                                      ),
                                                                    ),
                                                                    SimpleDialogOption(
                                                                      onPressed: () {
                                                                        _addReminder(
                                                                          '15 menit sebelum',
                                                                        );
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: const Text(
                                                                        '15 menit sebelum',
                                                                      ),
                                                                    ),
                                                                    SimpleDialogOption(
                                                                      onPressed: () {
                                                                        _addReminder(
                                                                          '30 menit sebelum',
                                                                        );
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: const Text(
                                                                        '30 menit sebelum',
                                                                      ),
                                                                    ),
                                                                    SimpleDialogOption(
                                                                      onPressed: () {
                                                                        _addReminder(
                                                                          '1 jam sebelum',
                                                                        );
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: const Text(
                                                                        '1 jam sebelum',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 40,
                                                              ),
                                                          child: Row(
                                                            children: const [
                                                              Icon(
                                                                Icons.add,
                                                                size: 20,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                'Tambahkan Pengingat',
                                                                style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih Tanggal';
    return DateFormat('dd MMM yyyy').format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = picked;
      });
    }
  }

  void _addReminder(String reminder) {
    setState(() {
      _reminderList.add(reminder);
    });
  }

  void _removeReminder(int index) {
    setState(() {
      _reminderList.removeAt(index);
    });
  }
}
