import 'package:flutter/material.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({Key? key}) : super(key: key);

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  final TextEditingController _titleController = TextEditingController(
    text: 'Judul 1',
  );
  final TextEditingController _detailController = TextEditingController(
    text: 'Detail',
  );
  bool _isEditing = false;
  final List<Map<String, String>> _memos = [];

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    // Title
                    const Text(
                      'Memo',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    // Save button
                    ElevatedButton(
                      onPressed: () {
                        // Kirim data memo ke halaman home.dart
                        Navigator.pop(context, {
                          'title': _titleController.text,
                          'detail': _detailController.text,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCFD2FF),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCFD2FF),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 10,
                        offset: Offset(10, 10),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Title section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child:
                            _isEditing
                                ? TextField(
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Judul',
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                                : Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _titleController.text,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                      ),

                      // Divider
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(thickness: 1, color: Colors.black54),
                      ),

                      // Content section
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child:
                              _isEditing
                                  ? TextField(
                                    controller: _detailController,
                                    maxLines: null,
                                    expands: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Detail',
                                      alignLabelWithHint: true,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                  : SingleChildScrollView(
                                    child: Text(
                                      _detailController.text,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Edit button
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_isEditing) {
                        // Simpan data saat selesai mengedit
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Perubahan disimpan!')),
                        );
                        // Simpan data ke penyimpanan lokal atau server
                        print('Judul: ${_titleController.text}');
                        print('Detail: ${_detailController.text}');
                      }
                      _isEditing = !_isEditing; // Toggle mode edit
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8289F8),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(140, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Selesai' : 'Edit',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
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
