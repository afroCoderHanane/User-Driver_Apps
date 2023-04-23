import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'Services/notifi_service.dart';

DateTime scheduleTime = DateTime.now().add(Duration(seconds: 30));

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Text(widget.title),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            DatePickerTxt(),
            ScheduleBtn(),
          ],
        ),
      ),
    );
  }
}

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) => scheduleTime = date,
          onConfirm: (date) {},
        );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final formattedScheduleTime = dateFormat.format(scheduleTime);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
      onPressed: () {

        debugPrint('Notification Scheduled for $formattedScheduleTime');
        NotificationService().scheduleNotification(
            title: 'Shuttlez',
            body:
                " Your departure is scheduled at $formattedScheduleTime: Don't miss your shuttle :) ",
            scheduledNotificationDateTime: scheduleTime);
        Fluttertoast.showToast(msg: "Notification Scheduled for $formattedScheduleTime");
      },
      child: const Text('Schedule notification'),
    );
  }
}
