import 'package:flutter/material.dart';

class AddDoctorPage extends StatelessWidget {
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _medicalNameController = TextEditingController();
  final TextEditingController _specialistTypeController =
      TextEditingController();

  AddDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _doctorNameController,
              decoration: const InputDecoration(
                labelText: 'Doctor Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _medicalNameController,
              decoration: const InputDecoration(
                labelText: 'Medical Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: 'Heart Specialist', // Default value or from a controller
              onChanged: (newValue) {
                _specialistTypeController.text = newValue ?? 'Heart Specialist';
              },
              items: <String>[
                'Heart Specialist',
                'Dentist',
                'Surgeon',
                'Pediatrician'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Specialist Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Logic to save the doctor's details
              },
              child: const Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }
}
