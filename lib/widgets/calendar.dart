// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// class CalendarScreen extends StatefulWidget {
//   const CalendarScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _CalendarScreenState createState() => _CalendarScreenState();
// }

// class _CalendarScreenState extends State<CalendarScreen> {
//   late CalendarFormat _calendarFormat;
//   late DateTime _focusedDay;
//   late DateTime _selectedDay;

//   @override
//   void initState() {
//     super.initState();
//     _calendarFormat = CalendarFormat.month;
//     _focusedDay = DateTime.now();
//     _selectedDay = _focusedDay;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 300,
//       child: TableCalendar(
//         calendarFormat: _calendarFormat,
//         focusedDay: _focusedDay,
//         firstDay: DateTime(DateTime.now().year - 1),
//         lastDay: DateTime(DateTime.now().year + 1),
//         selectedDayPredicate: (day) {
//           return isSameDay(_selectedDay, day);
//         },
//         onDaySelected: (selectedDay, focusedDay) {
//           setState(() {
//             _selectedDay = selectedDay;
//             _focusedDay = focusedDay;
//           });
//         },
//         onPageChanged: (focusedDay) {
//           _focusedDay = focusedDay;
//         },
//       ),
//     );
//   }
// }
