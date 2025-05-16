import 'package:flutter/material.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/database/database.dart';

class TodoFormScreen extends StatefulWidget {
  final bool isEdit;
  final Todo? todo;

  const TodoFormScreen({Key? key, this.isEdit = false, this.todo})
      : super(key: key);

  @override
  State<TodoFormScreen> createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;
  bool _isReminderOn = false;
  int _reminderMinutes = 15;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _contentController.text = widget.todo!.content;
      _startTime = widget.todo!.startTime;
      _endTime = widget.todo!.endTime;
      _isReminderOn = widget.todo!.reminderMinutes != null;
      _reminderMinutes = widget.todo!.reminderMinutes ?? 15;
    }
  }

  void _saveOrUpdate() async {
    if (_titleController.text.isEmpty ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi semua data')),
      );
      return;
    }

    final newTodo = Todo(
      id: widget.isEdit ? widget.todo!.id : null,
      title: _titleController.text,
      content: _contentController.text,
      startTime: _startTime!,
      endTime: _endTime!,
      reminderMinutes: _isReminderOn ? _reminderMinutes : null,
    );

    if (widget.isEdit) {
      await DBHelper.updateNote(newTodo);
    } else {
      await DBHelper.insertTodo(newTodo);
    }

    Navigator.pop(context, true);
  }

  Future<DateTime?> _showDateTimePicker(BuildContext context) async {
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

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit To-Do' : 'Tambah To-Do'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Detail'),
            ),
            ListTile(
              title: Text("Waktu Mulai: ${_startTime?.toString() ?? 'Pilih'}"),
              onTap: () async {
                final picked = await _showDateTimePicker(context);
                if (picked != null) setState(() => _startTime = picked);
              },
            ),
            ListTile(
              title: Text("Waktu Selesai: ${_endTime?.toString() ?? 'Pilih'}"),
              onTap: () async {
                final picked = await _showDateTimePicker(context);
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
                items: [5, 10, 15, 30, 60].map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text('$e Menit Sebelum'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _reminderMinutes = val!),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveOrUpdate,
              child: Text(widget.isEdit ? 'Update' : ''),
            ),
          ],
        ),
      ),
    );
  }
}