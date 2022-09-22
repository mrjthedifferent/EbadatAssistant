import 'dart:io';
import 'package:ebadat_assistant/models/waqt.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:ebadat_assistant/services/database.dart';
import 'package:flutter/material.dart';

import '../services/notification_service.dart';
import '../util/constant.dart';

class NamazPage extends StatefulWidget {
  const NamazPage({Key? key}) : super(key: key);

  @override
  State<NamazPage> createState() => _NamazPageState();
}

class _NamazPageState extends State<NamazPage> {
  final box = GetStorage();

  List<Waqt> namaz = [];

  LocationData? _locationData;

  @override
  void initState() {
    AndroidAlarmManager.initialize();
    getLocation();
    super.initState();
  }

  void getLocation() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
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

        _locationData = await location.getLocation();

        namaz = await Database().getNamazTime(
            "${_locationData!.latitude}", "${_locationData!.longitude}");
        setState(() {});
      }
    } on SocketException catch (_) {
      print('not connected');
      try {
        namaz =[
          new Waqt(
            id: 1,
            name: FAJR,
            time: DateTime.parse(box.read(FAJR_TIME)),
            isActive: box.read(FAJR) ?? false,
          ),
          new Waqt(
            id: 2,
            name: DHUHR,
            time: DateTime.parse(box.read(DHUHR_TIME)),
            isActive: box.read(DHUHR) ?? false,
          ),
          new Waqt(
            id: 3,
            name: ASR,
            time: DateTime.parse(box.read(ASR_TIME)),
            isActive: box.read(ASR) ?? false,
          ),
          new Waqt(
            id: 4,
            name: MAGHRIB,
            time: DateTime.parse(box.read(MAGHRIB_TIME)),
            isActive: box.read(MAGHRIB) ?? false,
          ),
          new Waqt(
            id: 5,
            name: ISHA,
            time: DateTime.parse(box.read(ISHA_TIME)),
            isActive: box.read(ISHA) ?? false,
          )
        ];
        setState(() {});
      }catch (e) {
        print("Error: " + e.toString());
      }
    }
  }

  static void startAlarm() async {
    await NotificationService().showNotifications();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
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

        LocationData _locationData = await location.getLocation();

        List<Waqt> _namaz = await Database().getNamazTime(
            "${_locationData.latitude}", "${_locationData.longitude}");


        /**
         * Rescheduling the alarms as per new updated time.
         */

        for(Waqt waqt in _namaz) {
          bool _cancel = await AndroidAlarmManager.cancel(waqt.id);
          if(_cancel){
            await AndroidAlarmManager.periodic(
                const Duration(days: 1), waqt.id, startAlarm,
                startAt: waqt.time);
            print("Alarm started for ${waqt.name} at: " + waqt.time.toString());
          }
        }
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Namaz'),
      ),
      body: namaz.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _locationData == null
                      ? Container()
                      : Text(
                          "Your location: \nLatitude: ${_locationData?.latitude} Longitude: ${_locationData?.longitude}"),
                  const SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(namaz.length, (index) {
                          Waqt _waqt = namaz[index];
                          return _buildButton(buttonWidth, _waqt);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildButton(double? width, Waqt waqt) {
    return Column(
      children: [
        SizedBox(
          width: width,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: Text(
                      "${waqt.name} : ${DateFormat().add_jm().format(waqt.time)}"),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                  onPressed: () async {
                    if (waqt.isActive == false) {
                      await AndroidAlarmManager.periodic(
                          const Duration(days: 1), waqt.id, startAlarm,
                          startAt: waqt.time);
                      print("Alarm started for ${waqt.name} at: " + waqt.time.toString());
                      box.write(waqt.name, true);
                      var snackBar = SnackBar(
                        content: Text("Alarm started for ${waqt.name} at: " + waqt.time.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      //overwriting local db
                      box.write(waqt.name, false);
                      //cancelling alarm
                      bool cancel = await AndroidAlarmManager.cancel(waqt.id);
                      //checking if cancelled and showSnackBar
                      if (cancel) {
                        var snackBar = SnackBar(
                          content: Text("Cancelled"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                    //redrawing the screen
                    setState(() {
                      waqt.isActive = !waqt.isActive;
                    });
                  },
                  icon: Icon(waqt.isActive
                      ? Icons.notifications_off_outlined
                      : Icons.notifications_active))
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
