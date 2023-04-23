
import 'package:flutter/material.dart';
import 'package:users_app/schedulescreen/scheduler.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
    'Target Runs'
  ];
  late String _selectedDay;
  final Map<String, String> _minutesBetweenShuttles = {
    '7:00 AM - 8:00 AM': '30 min',
    '8:00 AM - 6:00 PM': '15 min',
    '6:00 PM - 1:00 AM': '30 min',
    '6:00 PM - 2:00 AM': '30 min',
    '6:59 AM - 1:00 AM': '30 min',
    'Drop Off Only': ' ',
    'Pick Up Only': ' ',
    'AK 11:00 AM /CMC 11:15 AM / T 11:30 AM': 'Not Available',
    'AK 12:00 PM /CMC 12:15 PM / T 12:30 PM': 'Not Available',
    'AK 1:00 PM /CMC 1:15 PM / T 1:30 PM': 'Not Available',
    'AK 2:00 PM / AK 2:45 PM': 'Not Available',
    'CMC 2:15 PM / CMC 3:00 PM': 'Not Available',
    'T 2:30 PM': 'Not Available'
  };

  final Map<String, String> _numShuttles = {
    '7:00 AM - 8:00 AM': '1',
    '8:00 AM - 6:00 PM': '2',
    '6:00 PM - 1:00 AM': '1',
    '6:00 PM - 2:00 AM': '1',
    '6:59 AM - 1:00 AM': '1',
    'Drop Off Only': ' ',
    'Pick Up Only': ' ',
    'AK 11:00 AM /CMC 11:15 AM / T 11:30 AM': '1',
    'AK 12:00 PM /CMC 12:15 PM / T 12:30 PM': '1',
    'AK 1:00 PM /CMC 1:15 PM / T 1:30 PM': '1',
    'AK 2:00 PM / AK 2:45 PM': '1',
    'CMC 2:15 PM / CMC 3:00 PM': '1',
    'T 2:30 PM': '1'
  };
  final Map<String, List<String>> _schedule = {
    'Monday': ['7:00 AM - 8:00 AM', '8:00 AM - 6:00 PM', '6:00 PM - 1:00 AM'],
    'Tuesday': ['7:00 AM - 8:00 AM', '8:00 AM - 6:00 PM', '6:00 PM - 1:00 AM'],
    'Wednesday': [
      '7:00 AM - 8:00 AM',
      '8:00 AM - 6:00 PM',
      '6:00 PM - 1:00 AM'
    ],
    'Thursday': ['7:00 AM - 8:00 AM', '8:00 AM - 6:00 PM', '6:00 PM - 2:00 AM'],
    'Friday': ['7:00 AM - 8:00 AM', '8:00 AM - 6:00 PM', '6:00 PM - 2:00 AM'],
    'Saturday': ['7:00 AM - 8:00 AM', '8:00 AM - 6:00 PM', '6:00 PM - 2:00 AM'],
    'Sunday': ['6:59 AM - 1:00 AM'],
    'Target Runs': [
      'AK 11:00 AM /CMC 11:15 AM / T 11:30 AM',
      'AK 12:00 PM /CMC 12:15 PM / T 12:30 PM',
      'AK 1:00 PM /CMC 1:15 PM / T 1:30 PM',
      'Drop Off Only',
      'AK 2:00 PM / AK 2:45 PM',
      'CMC 2:15 PM / CMC 3:00 PM',
      'Pick Up Only',
      'T 2:30 PM'
    ]
  };
  @override
  void initState() {
    super.initState();
    _selectedDay = _days[DateTime.now().weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shuttle Schedule'),
        backgroundColor: Colors.red.shade900,
      ),
      body: Column(

        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedDay,
              items: _days.map((String day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedDay = value!),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FittedBox(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Shuttles running')),
                    DataColumn(label: Text('Time interval'))
                  ],
                  rows: [
                    for (final schedule in _schedule[_selectedDay]!)
                      DataRow(cells: [
                        DataCell(Text(schedule)),
                        DataCell(Text(_numShuttles[schedule].toString())),
                        DataCell(Text('${_minutesBetweenShuttles[schedule]}')),
                      ]),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(100.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Text Color
                backgroundColor: Colors.red.shade900,

              ),
              child: const Text('Schedule A Reminder'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage(title: "scheduler")),
                );
              },
            ),

          ),
        ],
      ),
    );
  }
}
