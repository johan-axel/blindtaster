import 'package:flutter/material.dart';
import '../models/custom_field.dart';
import '../models/settings.dart';
import '../services/storage_service.dart';

class CustomFieldsSettings extends StatefulWidget {
  final Settings settings;
  final VoidCallback onSettingsChanged;

  const CustomFieldsSettings({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<CustomFieldsSettings> createState() => _CustomFieldsSettingsState();
}

class _CustomFieldsSettingsState extends State<CustomFieldsSettings> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  CustomFieldType _selectedType = CustomFieldType.text;
  bool _isRequired = false;
  double _minValue = 0;
  double _maxValue = 5;
  int _divisions = 5;

  void _addField() {
    if (!_formKey.currentState!.validate()) return;

    CustomField field;
    switch (_selectedType) {
      case CustomFieldType.text:
        field = CustomField.text(
          name: _nameController.text,
          required: _isRequired,
        );
        break;
      case CustomFieldType.number:
        field = CustomField.number(
          name: _nameController.text,
          required: _isRequired,
          min: _minValue,
          max: _maxValue,
        );
        break;
      case CustomFieldType.slider:
        field = CustomField.slider(
          name: _nameController.text,
          required: _isRequired,
          min: _minValue,
          max: _maxValue,
          divisions: _divisions,
        );
        break;
    }

    setState(() {
      widget.settings.customFields = [...widget.settings.customFields, field];
    });
    widget.onSettingsChanged();
    _nameController.clear();
    _resetForm();
  }

  void _removeField(int index) {
    setState(() {
      widget.settings.customFields = List.from(widget.settings.customFields)
        ..removeAt(index);
    });
    widget.onSettingsChanged();
  }

  void _resetForm() {
    setState(() {
      _selectedType = CustomFieldType.text;
      _isRequired = false;
      _minValue = 0;
      _maxValue = 5;
      _divisions = 5;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Custom Fields',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Field Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a field name';
                  }
                  if (widget.settings.customFields
                      .any((f) => f.name == value)) {
                    return 'A field with this name already exists';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<CustomFieldType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Field Type',
                  border: OutlineInputBorder(),
                ),
                items: CustomFieldType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('Required'),
                value: _isRequired,
                onChanged: (value) {
                  setState(() {
                    _isRequired = value!;
                  });
                },
              ),
              if (_selectedType != CustomFieldType.text) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _minValue.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Min Value',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _minValue = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: _maxValue.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Max Value',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _maxValue = double.tryParse(value) ?? 5;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
              if (_selectedType == CustomFieldType.slider) ...[
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: _divisions.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Divisions',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _divisions = int.tryParse(value) ?? 5;
                    });
                  },
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addField,
                child: const Text('Add Field'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Existing Fields',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.settings.customFields.length,
          itemBuilder: (context, index) {
            final field = widget.settings.customFields[index];
            return Card(
              child: ListTile(
                title: Text(field.name),
                subtitle: Text(
                  'Type: ${field.type.name.toUpperCase()}'
                  '${field.required ? ' (Required)' : ''}'
                  '${field.type != CustomFieldType.text ? ' [${field.minValue}-${field.maxValue}]' : ''}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeField(index),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
