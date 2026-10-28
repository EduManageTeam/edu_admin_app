import 'package:edu_admin/feature/student_screen/model/student_model.dart';
import 'package:edu_admin/feature/student_screen/service/student_service.dart';
import 'package:flutter/material.dart';
import 'package:edu_admin/model/color_system.dart';

class AddStudentScreen extends StatefulWidget {
  final StudentModel? studentToEdit;
  const AddStudentScreen({super.key, this.studentToEdit});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final parentIdController = TextEditingController();

  String gender = 'Male';
  String status = 'active';
  DateTime? dateOfBirth;
  int? classId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.studentToEdit;
    if (s != null) {
      nameController.text = s.name;
      phoneController.text = s.phone;
      addressController.text = s.address;
      parentIdController.text = s.parentId?.toString() ?? '';
      gender = s.gender.isEmpty ? 'Male' : s.gender;
      status = s.status.isEmpty ? 'active' : s.status;
      classId = s.classId;
      try {
        dateOfBirth = DateTime.parse(s.dateOfBirth);
      } catch (_) {
        dateOfBirth = null;
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    parentIdController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        dateOfBirth = selectedDate;
      });
    }
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    if (dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date of birth')),
      );
      return;
    }

    if (classId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a class')),
      );
      return;
    }

    final dob = '${dateOfBirth!.year.toString().padLeft(4, '0')}-'
        '${dateOfBirth!.month.toString().padLeft(2, '0')}-'
        '${dateOfBirth!.day.toString().padLeft(2, '0')}';

    final body = <String, dynamic>{
      'name': nameController.text.trim(),
      'gender': gender,
      'date_of_birth': dob,
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
      'photo': null,
      'class_id': classId,
      'parent_id': parentIdController.text.trim().isEmpty
          ? null
          : int.tryParse(parentIdController.text.trim()),
      'status': status,
    };

    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      if (widget.studentToEdit == null) {
        await StudentService.createStudent(body);
        if (!mounted) return;
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student added successfully')),
        );
        Navigator.pop(context, true);
      } else {
        await StudentService.updateStudent(widget.studentToEdit!.id, body);
        if (!mounted) return;
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student updated successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: ColorSystem.dark),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: ColorSystem.dark, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          widget.studentToEdit == null ? 'Add Student' : 'Update Student',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Student information
            _sectionTitle('Personal Information'),
            const SizedBox(height: 12),

            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: _decoration('Full Name', Icons.person_outline),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter student name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: gender,
              decoration: _decoration('Gender', Icons.wc_outlined),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => gender = value);
              },
            ),

            const SizedBox(height: 16),

            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: _decoration(
                  'Date of Birth',
                  Icons.calendar_month_outlined,
                ),
                child: Text(
                  dateOfBirth == null
                      ? 'Select date of birth'
                      : '${dateOfBirth!.year}-'
                        '${dateOfBirth!.month.toString().padLeft(2, '0')}-'
                        '${dateOfBirth!.day.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: dateOfBirth == null
                        ? Colors.grey.shade600
                        : Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Contact information
            _sectionTitle('Contact Information'),
            const SizedBox(height: 12),

            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: _decoration('Phone Number', Icons.phone_outlined),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: addressController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: _decoration(
                'Address',
                Icons.location_on_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Academic information
            _sectionTitle('Academic Information'),
            const SizedBox(height: 12),

            DropdownButtonFormField<int>(
              initialValue: classId,
              decoration: _decoration('Class', Icons.school_outlined),
              hint: const Text('Select class'),
              items: List.generate(
                5,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('Grade ${index + 1}'),
                ),
              ),
              onChanged: (value) {
                setState(() => classId = value);
              },
              validator: (value) {
                if (value == null) return 'Please select a class';
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: parentIdController,
              keyboardType: TextInputType.number,
              decoration: _decoration(
                'Parent ID (Optional)',
                Icons.family_restroom_outlined,
              ),
              validator: (value) {
                if (value != null &&
                    value.trim().isNotEmpty &&
                    int.tryParse(value.trim()) == null) {
                  return 'Parent ID must be a number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: status,
              decoration: _decoration(
                'Student Status',
                Icons.check_circle_outline,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'active',
                  child: Text('Active'),
                ),
                DropdownMenuItem(
                  value: 'inactive',
                  child: Text('Inactive'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => status = value);
              },
            ),

            const SizedBox(height: 28),

            // Save button
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveStudent,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(
                  _isSaving
                      ? (widget.studentToEdit == null ? 'Saving...' : 'Updating...')
                      : (widget.studentToEdit == null ? 'Save Student' : 'Update Student'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSystem.dark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ColorSystem.dark,
      ),
    );
  }
}