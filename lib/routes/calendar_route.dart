import 'package:flutter/material.dart';
import 'header.dart';
import 'package:table_calendar/table_calendar.dart';

// class Calendar extends StatelessWidget { // <- (※1)
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Header(),
//       body: Center(child: Text("カレンダー") // <- (※3)
//           ),
//     );
//   }
// }

class Calendar extends StatefulWidget {

  @override
  _TableState createState() => _TableState();
}

class _TableState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: TableCalendar(
        firstDay: DateTime.utc(2000, 01, 01),
        lastDay: DateTime.utc(2050, 07, 26),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },

      ),
    );
  }
}