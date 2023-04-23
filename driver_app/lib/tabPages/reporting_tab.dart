import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/global/global.dart';
import 'package:intl/intl.dart';

class ReportingTab extends StatefulWidget {
  @override
  _ReportingTabState createState() => _ReportingTabState();
}

class _ReportingTabState extends State<ReportingTab> {
  final _formKey = GlobalKey<FormState>();

  late String _location;

  late int _passengers;
  late String _driverName;
  late String _driverId;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final user = fAuth.currentUser;
    if (user != null) {
      setState(() {
        // _driverName = user.user!;
        _driverId = user.uid;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      DateTime now = DateTime.now();
      String formattedTime = DateFormat('kk:mm:ss').format(now);
      String dateStr = "${now.day}-${now.month}-${now.year}";

      final data = {
        'date': dateStr,
        'time': formattedTime,
        'passengers': _passengers,
        'driverName': _driverName,
        'driverId': _driverId,
        'location': _location
      };

      await FirebaseDatabase.instance
          .ref()
          .child('reports')
          .child(_driverId)
          .push()
          .set(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted')),
      );

    _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reporting'), backgroundColor: Colors.lightBlue[900],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Driver Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                   _driverName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Passengers'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the number of passengers';
                  }
                  return null;
                },
                onSaved: (value) {
                  _passengers = int.parse(value!);
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                ),
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

