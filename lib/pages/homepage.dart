import 'package:ebadat_assistant/pages/namazpage.dart';
import 'package:ebadat_assistant/pages/physicalExercise.dart';
import 'package:ebadat_assistant/pages/quranRecitation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'dhikr.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;
    checkPermissions();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ebadat Assistant'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              "Namaz",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NamazPage()),
                );
              },
              buttonWidth,
            ),
            const SizedBox(height: 20),
            _buildButton("Dhikr", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dhikr()),
              );
            }, buttonWidth),
            const SizedBox(height: 20),
            _buildButton("Quran Recitation", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuranRecitation()),
              );
            }, buttonWidth),
            const SizedBox(height: 20),
            _buildButton("Physical Exercise", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhysicalExercise()),
              );
            }, buttonWidth),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, double? width) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
        ),
        child: Text(text),
      ),
    );
  }

  void checkPermissions() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
}
