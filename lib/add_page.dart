import 'package:flutter/material.dart';
import 'models/article.dart';

class AddPage extends StatefulWidget {
  final Function(Article) onArticleAdded;

  const AddPage({super.key, required this.onArticleAdded});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _viewsController = TextEditingController(); // เปลี่ยนชื่อให้ชัดเจน
  final _contentController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _viewsController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a date')));
        return;
      }
      final newArticle = Article(
        id: UniqueKey().toString(),
        title: _titleController.text,
        author: _authorController.text,
        views: int.parse(_viewsController.text),
        date: _selectedDate!,
        category: _selectedCategory ?? 'General',
        content: _contentController.text,
      );
      widget.onArticleAdded(newArticle);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Article')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ชื่อบทความ
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                ),
                // ชื่อผู้เขียน
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(labelText: 'Author'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter an author' : null,
                ),
                // จำนวนวิว
                TextFormField(
                  controller: _viewsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Views'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter a number';
                    if (int.tryParse(value) == null)
                      return 'Enter a valid number';
                    return null;
                  },
                ),
                // ตัวเลือกวันที่
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                    ),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                // Dropdown เลือกหมวดหมู่
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: _selectedCategory,
                  items:
                      [
                            'Technology',
                            'Health',
                            'Business',
                            'Entertainment',
                            'Politics',
                          ]
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator:
                      (value) =>
                          value == null ? 'Please select a category' : null,
                ),
                // ปุ่มเพิ่มข้อมูล
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Article'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
