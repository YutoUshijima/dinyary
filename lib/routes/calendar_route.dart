import 'package:dinyary/routes/timeline_route.dart';
import 'package:flutter/material.dart';
import 'header.dart';
import 'footer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'NoteViewModel.dart';

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

// Utils
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

int getHashCode(DateTime key) { // used for LinkedHashMap
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 2, kToday.month, 1);
final kLastDay = DateTime(kToday.year + 1, kToday.month, 1);


class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _TableState createState() => _TableState();
}

class _TableState extends State<Calendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final LinkedHashMap<DateTime, List<Event>> _eventsList = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.disabled;
  // disable the functionality of range selection
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoading = true;

  void _initAsync() async {
    final data = await NoteViewModel.getNotes();
    // print(data);

    setState(() {
      for (final item in data) {
        final event = Event(item['diary']);
        (_eventsList[DateTime.parse(item['createdAt'])] == null)
            ? _eventsList[DateTime.parse(item['createdAt'])] = [event]
            : _eventsList[DateTime.parse(item['createdAt'])]!.add(event);
        // print(item['createdAt'].runtimeType.toString());
        // print(_eventsList);
      }
      _isLoading = false;
    });

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return _eventsList[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
    bottomNavigationBar: Footer(
        pageid: 2),
      body: _isLoading ? const Center(child: CircularProgressIndicator())
      : Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => TimeLine(),
                            )
                          );
                        },
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}