import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/notification.dart';
import 'package:openzo_frontend/src/bytes/byte.dart';

class BytesPage extends StatefulWidget {
  const BytesPage({super.key});

  @override
  State<BytesPage> createState() => _BytesPageState();
}

class _BytesPageState extends State<BytesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Bytes'),
      ),
      body: FutureBuilder(
          future: NotificationByte.fetchMany("721301"),
          builder: (BuildContext context,
              AsyncSnapshot<List<NotificationByte>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Byte(notificationByte: snapshot.data![index]);
                },
              );
            }
          }),
    );
  }
}
