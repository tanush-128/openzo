import 'package:flutter/material.dart';
import 'package:openzo_frontend/constants/styles.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Booking Page'),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TopDate(
                    today: today,
                    selected: true,
                  ),
                  TopDate(today: today.add(const Duration(days: 1))),
                  TopDate(today: today.add(const Duration(days: 2))),
                  TopDate(today: today.add(const Duration(days: 3))),
                  TopDate(today: today.add(const Duration(days: 4))),
                  TopDate(today: today.add(const Duration(days: 5))),
                  TopDate(today: today.add(const Duration(days: 6))),
                ],
              ),
            ),
            Container(
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Choose Time Slot",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TimeSlot(),
                    TimeSlot(),
                    TimeSlot(),
                    TimeSlot(),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class TimeSlot extends StatelessWidget {
  const TimeSlot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Morning (9 AM - 12 PM)",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey.shade400,
                thickness: 2,
              ),
            ),
            SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 2,
                    ),
                    shrinkWrap: true,
                    children: [
                      Slot(
                        time: DateTime.now(),
                        selected: true,
                      ),
                      Slot(
                        time: DateTime.now(),
                        disabled: true,
                      ),
                      Slot(
                        time: DateTime.now(),
                      ),
                      Slot(
                        time: DateTime.now(),
                      ),
                      Slot(
                        time: DateTime.now(),
                      ),
                      Slot(
                        time: DateTime.now(),
                      ),
                      Slot(
                        time: DateTime.now(),
                      ),
                      Slot(
                        time: DateTime.now(),
                      ),
                      Slot(
                        time: DateTime.now(),
                      ),
                      Slot(
                        time: DateTime.now(),
                      ),
                      // Slot(),
                      // Slot(),
                      // Slot(),
                      // Slot(),
                      // Slot(),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Slot extends StatefulWidget {
  Slot({
    super.key,
    required this.time,
    this.selected = false,
    this.disabled = false,
  });
  DateTime time;
  bool selected = false;
  bool disabled = false;

  @override
  State<Slot> createState() => _SlotState();
}

class _SlotState extends State<Slot> {
  getTimef(DateTime time) {
    return time.hour > 12
        ? "${time.hour - 12}:${time.minute} PM"
        : "${time.hour}:${time.minute} AM";
    // return "${time.hour}:${time.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: widget.selected
            ? GlobalStyle.primaryColor.withOpacity(1)
            : widget.disabled
                ? Colors.grey.shade400
                : Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Center(
          child: Text(
            getTimef(widget.time),
            style: TextStyle(
              // fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.selected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class TopDate extends StatelessWidget {
  TopDate({
    super.key,
    required this.today,
    this.selected = false,
  });

  final DateTime today;
  bool selected = false;
  // final List<String> weekdays;
  final weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey),
          color: selected ? GlobalStyle.secondaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              weekdays[today.weekday - 1],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text('${today.day}'),
            // Text('${today.day}/${today.month}/${today.year}'),
          ],
        ),
      ),
    );
  }
}
