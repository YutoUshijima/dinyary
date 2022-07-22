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
  final String diary;
  final String tag;

  const Event(this.diary, this.tag);

  @override
  String toString() => diary;
  List<String> _getValue() => [diary, tag];
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
        final event = Event(item['diary'], item['tag']);
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
            locale: 'ja_JP',
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              cellMargin: EdgeInsets.all(6.0),
              outsideTextStyle: TextStyle(
                color: Color(0xFFE0E0E0) // Colors.grey[300]
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              selectedTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEF9A9A), // Colors.red[200]
              ),
              todayTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
              weekendTextStyle: TextStyle(
                color: Color(0xFFFF8A65), // Colors.deepOrange[300]
              ),
            ),
            daysOfWeekHeight: 40.0,
            daysOfWeekStyle: const DaysOfWeekStyle(
              decoration: UnderlineTabIndicator(
                insets: EdgeInsets.only(top: 20.0),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Color(0xFFE0E0E0), // Colors.grey[300]
                ),
              ),
              weekendStyle: TextStyle(
                color: Color(0xFFFF8A65),
                fontWeight: FontWeight.bold,
              ),
              weekdayStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onDaySelected: _onDaySelected,
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },

            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, _, events) {
                if (events.isNotEmpty) {
                  return _markerBuildEvents(events);
                }
                return null;
              }
            ),

          ),

          const Divider(
            height: 8.0,
            thickness: 1.5,
          ),

          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE0E0E0), // Colors.grey[300]
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        color: const Color(0xFFE0E0E0), // Colors.grey[300]
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const TimeLine(),
                            )
                          );
                        },
                        title: Text('Diary: ${value[index]._getValue()[0]}'),
                        subtitle: Text('Tags: ${value[index]._getValue()[1]}'),
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

  Widget _markerBuildEvents(List events) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          shape: BoxShape.circle,
          color: const Color(0xFFEF5350), // Colors.red[400]
        ),
        width: 13.0,
        height: 13.0,
        child: Text(
          '${events.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      )
    );
  }
}


