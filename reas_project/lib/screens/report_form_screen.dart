
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportViewState {
  form,
  empty,
  loading,
  success,
  error,
}

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() =>
      _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _customerController = TextEditingController();
  final _purchaseController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _categories = [
    'Food',
    'Clothing',
    'School Supplies',
    'Electronics',
    'Other',
  ];

  String _selectedCategory = 'Food';
  ReportViewState _state = ReportViewState.form;

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _state = ReportViewState.loading;
    });

    // Simulate the submission process.
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Demo success response.
    setState(() {
      _state = ReportViewState.success;
    });
  }

  void _showErrorState() {
    setState(() {
      _state = ReportViewState.error;
    });
  }

  void _showEmptyState() {
    setState(() {
      _state = ReportViewState.empty;
    });
  }

  void _backToForm() {
    setState(() {
      _state = ReportViewState.form;
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _customerController.clear();
    _purchaseController.clear();
    _amountController.clear();
    _descriptionController.clear();

    setState(() {
      _selectedCategory = 'Food';
      _state = ReportViewState.form;
    });
  }

  @override
  void dispose() {
    _customerController.dispose();
    _purchaseController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF176B87);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Report'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        leading: _state == ReportViewState.form
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to form',
                onPressed: _backToForm,
              ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: _buildCurrentState(primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentState(Color primaryColor) {
    switch (_state) {
      case ReportViewState.form:
        return _buildForm(primaryColor);

      case ReportViewState.empty:
        return _buildMessageState(
          icon: Icons.inbox_outlined,
          title: 'No Purchase Reports Yet',
          message:
              'There are currently no purchase reports to display. '
              'Create your first report to get started.',
          buttonText: 'Create First Report',
          buttonIcon: Icons.add,
          onPressed: _backToForm,
          color: primaryColor,
        );

      case ReportViewState.loading:
        return _buildLoadingState();

      case ReportViewState.success:
        return _buildMessageState(
          icon: Icons.check_circle_outline,
          title: 'Report Submitted!',
          message:
              'Your report passed the demo submission process.\n\n'
              'Customer: ${_customerController.text}\n'
              'Purchase: ${_purchaseController.text}\n'
              'Category: $_selectedCategory\n'
              'Amount: ₱${_amountController.text}\n\n'
              'Demo only: the report was not saved to a database.',
          buttonText: 'Create Another Report',
          buttonIcon: Icons.add,
          onPressed: _resetForm,
          color: Colors.green,
        );

      case ReportViewState.error:
        return _buildMessageState(
          icon: Icons.error_outline,
          title: 'Unable to Submit Report',
          message:
              'Something went wrong while submitting the report. '
              'Please try again.\n\n'
              'Demo error state: no real server request was made.',
          buttonText: 'Retry',
          buttonIcon: Icons.refresh,
          onPressed: _backToForm,
          color: Colors.red,
        );
    }
  }

  Widget _buildForm(Color primaryColor) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.receipt_long,
                size: 56,
                color: const Color(0xFF176B87),
              ),
              const SizedBox(height: 12),
              Text(
                'Purchase Report Form',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              AppTextField(
                label: 'Customer Name',
                icon: Icons.person,
                controller: _customerController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Purchase Item',
                icon: Icons.shopping_bag,
                controller: _purchaseController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter purchase item';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Purchase Category',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Amount (₱)',
                icon: Icons.payments,
                controller: _amountController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter amount';
                  }

                  final amount = double.tryParse(value.trim());

                  if (amount == null) {
                    return 'Enter a valid number';
                  }

                  if (amount <= 0) {
                    return 'Amount must be greater than zero';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              AppTextField(
                label: 'Description (optional)',
                icon: Icons.notes,
                controller: _descriptionController,
              ),
              const SizedBox(height: 24),

              AppButton(
                text: 'Submit Report',
                onPressed: _submitReport,
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              const Text(
                'Activity 9 — State Preview',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _showEmptyState,
                icon: const Icon(Icons.inbox_outlined),
                label: const Text('Preview Empty State'),
              ),
              const SizedBox(height: 8),

              OutlinedButton.icon(
                onPressed: _showErrorState,
                icon: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
                label: const Text('Preview Error State'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            const Text(
              'Submitting Report...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please wait while we process your report.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageState({
    required IconData icon,
    required String title,
    required String message,
    required String buttonText,
    required IconData buttonIcon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 88, color: color),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onPressed,
                icon: Icon(buttonIcon),
                label: Text(buttonText),
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _backToForm,
              child: const Text('Back to Report Form'),
            ),
          ],
        ),
      ),
    );
  }
}