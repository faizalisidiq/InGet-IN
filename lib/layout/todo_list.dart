import 'package:flutter/material.dart';
import 'home.dart';
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  bool _allDay = false;
  bool _reminder = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(
    hour: TimeOfDay.now().hour + 1,
    minute: TimeOfDay.now().minute,
  );

  // Tambahkan list untuk menyimpan daftar pengingat
  List<String> _reminderList = ['15 Menit Sebelum'];

  // Format tanggal ke string Indonesia
  String _formatDate(DateTime date) {
    final months = [
      '',
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
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  // Format tanggal singkat
  String _formatShortDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Pilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Pilih waktu mulai
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
        // Jika waktu mulai lebih dari waktu selesai, sesuaikan waktu selesai
        if (_startTime.hour > _endTime.hour ||
            (_startTime.hour == _endTime.hour &&
                _startTime.minute >= _endTime.minute)) {
          _endTime = TimeOfDay(
            hour: (_startTime.hour + 1) % 24,
            minute: _startTime.minute,
          );
        }
      });
    }
  }

  // Pilih waktu selesai
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
        // Jika waktu selesai kurang dari waktu mulai, sesuaikan waktu mulai
        if (_endTime.hour < _startTime.hour ||
            (_endTime.hour == _startTime.hour &&
                _endTime.minute <= _startTime.minute)) {
          _startTime = TimeOfDay(
            hour: (_endTime.hour - 1 + 24) % 24,
            minute: _endTime.minute,
          );
        }
      });
    }
  }

  // Fungsi untuk menambahkan pengingat
  void _addReminder(String reminder) {
    setState(() {
      _reminderList.add(reminder);
    });
  }

  // Fungsi untuk menghapus pengingat
  void _removeReminder(int index) {
    setState(() {
      _reminderList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA6BCD9), Color(0xFF909BE3), Color(0xFF4949B1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'HARI INI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24), // Balance with back button
                  ],
                ),
              ),

              // Date Container - Dibuat dapat diklik
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A56D2),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDate(_selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
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

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9DA3FF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: InkWell(
                     onTap: () {
                    // Simpan tugas dan kembali
                    final task = 'Tugas pada ${_formatDate(_selectedDate)}'; // Contoh tugas
                    Navigator.pop(context, {
                      'date': _selectedDate,
                      'task': task,
                    });
                  },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9DA3FF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
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
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Main Todo Container
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8A91EF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'TO DO',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      // Todo Content Container
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFCFD2FF),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Todo Title and Details
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      top: 20,
                                      right: 15,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Edit this title
                                        const Text(
                                          'Judul 1',
                                          style: TextStyle(
                                            color: Color(0xFF6F6F6F),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Clickable detail text
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (context) => AlertDialog(
                                                    title: const Text(
                                                      'Tambahkan Detail',
                                                    ),
                                                    content: const TextField(
                                                      decoration: InputDecoration(
                                                        hintText:
                                                            'Masukkan detail tugas...',
                                                      ),
                                                      maxLines: 3,
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              context,
                                                            ),
                                                        child: const Text(
                                                          'Batal',
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              context,
                                                            ),
                                                        child: const Text(
                                                          'Simpan',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              'Tambahkan Detail',
                                              style: TextStyle(
                                                color: Color(0xFF6F6F6F),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  // All Day Section
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 20),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Seharian',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Time Selection
                                  Visibility(
                                    visible: !_allDay,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap:
                                                () => _selectStartTime(context),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.arrow_forward,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    GestureDetector(
                                                      onTap:
                                                          () => _selectDate(
                                                            context,
                                                          ),
                                                      child: Text(
                                                        _formatShortDate(
                                                          _selectedDate,
                                                        ),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '${_startTime.hour.toString().padLeft(2, '0')}.${_startTime.minute.toString().padLeft(2, '0')}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          InkWell(
                                            onTap:
                                                () => _selectEndTime(context),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.arrow_back,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    GestureDetector(
                                                      onTap:
                                                          () => _selectDate(
                                                            context,
                                                          ),
                                                      child: Text(
                                                        _formatShortDate(
                                                          _selectedDate,
                                                        ),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '${_endTime.hour.toString().padLeft(2, '0')}.${_endTime.minute.toString().padLeft(2, '0')}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 10,
                                    ),
                                    child: Divider(thickness: 1),
                                  ),

                                  // Reminder Section
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
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            Switch(
                                              value: _reminder,
                                              onChanged: (value) {
                                                setState(() {
                                                  _reminder = value;

                                                  // Jika pengingat dimatikan, hapus semua daftar pengingat
                                                  if (!value) {
                                                    _reminderList.clear();
                                                  } else if (_reminderList
                                                      .isEmpty) {
                                                    // Jika diaktifkan kembali dan daftar kosong, tambahkan default
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

                                        // Reminder options
                                        Visibility(
                                          visible: _reminder,
                                          child: Column(
                                            children: [
                                              // Daftar pengingat yang dinamis
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
                                                                fontSize: 13,
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

                                              if (_reminderList.isNotEmpty)
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 40,
                                                  ),
                                                  child: Divider(thickness: 1),
                                                ),

                                              // Add Reminder
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
                                                      Icon(Icons.add, size: 20),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        'Tambahkan Pengingat',
                                                        style: TextStyle(
                                                          fontSize: 13,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
