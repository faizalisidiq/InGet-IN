import 'package:flutter/material.dart';
import 'package:todolist/database/database.dart';
import 'package:todolist/models/task.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController content = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;
  bool _isReminderOn = false;
  int _reminderMinutes = 15;

  void _saveTodo() async {
    if (_titleController.text.isEmpty || _startTime == null || _endTime == null)
      return;

    final newTodo = Todo(
      title: _titleController.text,
      content: content.text,
      startTime: _startTime!,
      endTime: _endTime!,
      reminderMinutes: _isReminderOn ? _reminderMinutes : null,
    );

    await DBHelper.insertNote(newTodo);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah To-Do")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: content,
              decoration: InputDecoration(labelText: 'Tambahkan Detail'),
            ),
            ListTile(
              title: Text("Waktu Mulai: ${_startTime?.toString() ?? 'Pilih'}"),
              onTap: () async {
                final picked = await showDateTimePicker(context);
                if (picked != null) setState(() => _startTime = picked);
              },
            ),
            ListTile(
              title: Text("Waktu Selesai: ${_endTime?.toString() ?? 'Pilih'}"),
              onTap: () async {
                final picked = await showDateTimePicker(context);
                if (picked != null) setState(() => _endTime = picked);
              },
            ),
            SwitchListTile(
              title: Text("Atur Pengingat"),
              value: _isReminderOn,
              onChanged: (val) => setState(() => _isReminderOn = val),
            ),
            if (_isReminderOn)
              DropdownButton<int>(
                value: _reminderMinutes,
                items:
                    [5, 10, 15, 30, 60].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text('$e Menit Sebelum'),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _reminderMinutes = val!),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isEmpty ||
                    _startTime == null ||
                    _endTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Harap isi semua data')),
                  );
                  return;
                }

                final todo = Todo(
                  title: _titleController.text,
                  content: content.text,
                  startTime: _startTime!,
                  endTime: _endTime!,
                  reminderMinutes: _isReminderOn ? _reminderMinutes : null,
                );

                await DBHelper.insertNote(todo);

                Navigator.pop(context, true); // kembali dan trigger refresh
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}