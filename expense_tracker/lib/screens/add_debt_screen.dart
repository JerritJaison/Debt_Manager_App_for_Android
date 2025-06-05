import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/debt.dart';
import '../services/firestore_service.dart';
import '../utils/validators.dart';
import '../services/notification_service.dart';

class AddDebtScreen extends StatefulWidget {
  final Debt? existingDebt;
  const AddDebtScreen({super.key, this.existingDebt});

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _personController = TextEditingController();
  final _amountController = TextEditingController();
  final _paidController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedDeadline = DateTime.now().add(const Duration(days: 30));

  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _firestore = FirestoreService();

  String? _selectedCategory;

  final List<String> _categories = [
    'Food',
    'Travel',
    'Shopping',
    'Education',
    'Health',
    'Bills',
    'Entertainment',
    'Credit Card',
  ];

  final Map<String, IconData> _categoryIcons = {
    'Food': Icons.restaurant,
    'Travel': Icons.directions_car,
    'Shopping': Icons.shopping_cart,
    'Education': Icons.school,
    'Health': Icons.local_hospital,
    'Bills': Icons.receipt_long,
    'Entertainment': Icons.movie,
    'Credit Card': Icons.credit_card,
  };

  double _remainingAmount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.existingDebt != null) {
      final d = widget.existingDebt!;
      _titleController.text = d.title;
      _personController.text = d.person;
      _amountController.text = d.totalAmount.toString();
      _selectedCategory = d.category;
      _selectedDate = d.date;
      _selectedDeadline = d.deadline;

      final paidSum = d.partialPayments.fold<double>(
        0,
        (sum, p) => sum + (p['amount'] ?? 0),
      );
      _remainingAmount = d.totalAmount - paidSum;

      _paidController.text = '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _personController.dispose();
    _amountController.dispose();
    _paidController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isDeadline) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDeadline ? _selectedDeadline : _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            dialogBackgroundColor: const Color(0xFF1C1C1E),
            colorScheme: const ColorScheme.dark(),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isDeadline) {
          _selectedDeadline = picked;
        } else {
          _selectedDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final total = double.parse(_amountController.text.trim());
    final paidNow = double.tryParse(_paidController.text.trim()) ?? 0;

    if (widget.existingDebt != null && paidNow > _remainingAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only pay up to $_remainingAmount')),
      );
      return;
    }

    final partials = widget.existingDebt?.partialPayments != null
        ? List<Map<String, dynamic>>.from(widget.existingDebt!.partialPayments)
        : <Map<String, dynamic>>[];

    if (paidNow > 0) {
      partials.add({
        'amount': paidNow,
        'date': DateTime.now().toIso8601String(),
      });
    }

    final newDebt = Debt(
      id: widget.existingDebt?.id ?? '',
      ownerId: _uid,
      title: _titleController.text.trim(),
      person: _personController.text.trim(),
      totalAmount: total,
      category: _selectedCategory!,
      date: _selectedDate,
      deadline: _selectedDeadline,
      partialPayments: partials,
      imageUrl: widget.existingDebt?.imageUrl ?? '',
    );

    if (widget.existingDebt != null) {
      await _firestore.updateDebt(_uid, newDebt);
    } else {
      final newId = await _firestore.addDebt(_uid, newDebt);

      final reminderDate = _selectedDeadline.subtract(const Duration(days: 1));
      try{
      await NotificationService.scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        title: '📅 Debt Due Tomorrow!',
        body: 'The debt to ${_personController.text} is due tomorrow.💸 Pay now to avoid charges',
        scheduledDate: reminderDate,
      );
      }catch(e){
        debugPrint('Notification scheduling failed:$e');
        ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification scheduling failed. Please allow exact alarms in settings.'),
      ),
    );
      }
    }

    Navigator.of(context).pop();
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String? Function(String?) validator,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF1F2235),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 4),
          child: Text(
            'Category',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _categories.map((category) {
            final selected = _selectedCategory == category;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_categoryIcons[category], size: 18, color: selected ? Colors.black : Colors.white),
                  const SizedBox(width: 6),
                  Text(category, style: TextStyle(color: selected ? Colors.black : Colors.white)),
                ],
              ),
              selected: selected,
              onSelected: (_) => setState(() => _selectedCategory = category),
              selectedColor: Colors.white,
              backgroundColor: const Color(0xFF1F2235),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            );
          }).toList(),
        ),
        if (_selectedCategory == null)
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 4),
            child: Text(
              'Please select a category',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime date, bool isDeadline) {
    return TextButton.icon(
      onPressed: () => _pickDate(context, isDeadline),
      icon: const Icon(Icons.calendar_today, color: Colors.white70),
      label: Text(
        '$label: ${date.toLocal().toString().split(' ')[0]}',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        title: Text(widget.existingDebt != null ? 'Edit Debt' : 'Add Debt'),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_titleController, 'Title', Validators.required),
              _buildTextField(_personController, 'Person or Company', Validators.required),
              _buildTextField(
                _amountController,
                'Amount',
                Validators.amount,
                keyboardType: TextInputType.number,
              ),
              _buildCategoryRadioButtons(),
              if (widget.existingDebt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Text(
                    'Remaining: ₹${_remainingAmount.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.orangeAccent),
                  ),
                ),
              _buildTextField(
                _paidController,
                'Amount Paid Now',
                Validators.amount,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              _buildDatePicker('Date', _selectedDate, false),
              _buildDatePicker('Deadline', _selectedDeadline, true),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _submit,
                child: Text(widget.existingDebt != null ? 'Update Debt' : 'Add Debt'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
