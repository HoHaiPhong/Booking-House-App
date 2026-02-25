import 'package:flutter/material.dart';
import '../../models/property_model.dart';
import '../../services/api_service.dart';

class AddEditPropertyScreen extends StatefulWidget {
  final Property? property; // If null, it's Add mode. If not null, it's Edit mode.

  const AddEditPropertyScreen({super.key, this.property});

  @override
  State<AddEditPropertyScreen> createState() => _AddEditPropertyScreenState();
}

class _AddEditPropertyScreenState extends State<AddEditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;
  late TextEditingController _areaController;
  late TextEditingController _descController;
  
  // Default values
  int _selectedCategoryId = 1; 

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.property?.name ?? '');
    _addressController = TextEditingController(text: widget.property?.address ?? '');
    _priceController = TextEditingController(text: widget.property?.price.toString() ?? '');
    _areaController = TextEditingController(text: widget.property?.area?.toString() ?? '');
    _descController = TextEditingController(text: widget.property?.description ?? '');
    if (widget.property != null) {
      _selectedCategoryId = widget.property!.categoryId ?? 1;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'ten_bds': _nameController.text,
      'dia_chi': _addressController.text,
      'gia_thue': double.tryParse(_priceController.text) ?? 0,
      'dien_tich': int.tryParse(_areaController.text) ?? 0,
      'mo_ta': _descController.text,
      'loai_id': _selectedCategoryId,
      // Hardcoded coordinates for now, ideal would be Map picker
      'lat': 10.776,
      'lng': 106.660, 
    };

    try {
      if (widget.property == null) {
        // Add
        await _apiService.post('/properties', data);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added successfully')));
      } else {
        // Edit
        await _apiService.put('/properties/${widget.property!.id}', data);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated successfully')));
      }
      if (mounted) Navigator.pop(context, true); // Return true to refresh
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.property != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Property' : 'Add New Property'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Property Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price (VND)', border: OutlineInputBorder()),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _areaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Area (m2)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Phòng Trọ')),
                  DropdownMenuItem(value: 2, child: Text('Căn Hộ Mini')),
                  DropdownMenuItem(value: 3, child: Text('Nhà Nguyên Căn')),
                ], 
                onChanged: (val) => setState(() => _selectedCategoryId = val!),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(isEditing ? 'Update Property' : 'Submit Listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
