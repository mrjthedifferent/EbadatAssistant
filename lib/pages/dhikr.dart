import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class Dhikr extends StatefulWidget {
  @override
  State<Dhikr> createState() => _DhikrState();
}

class _DhikrState extends State<Dhikr> {
  final box = GetStorage();

  Map<String, bool> dhikrs = {
    'Dhikr 1': false,
    'Dhikr 2': false,
    'Dhikr 3': false,
    'Dhikr 4': false,
    'Dhikr 5': false,
  };

  @override
  void initState() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String today = formatter.format(now);
    String date1 = box.read("dhdate") ?? "2022-01-01";
    if (today == date1) {
      dhikrs["Dhikr 1"] = box.read("Dhikr 1") ?? false;
      dhikrs["Dhikr 2"] = box.read("Dhikr 2") ?? false;
      dhikrs["Dhikr 3"] = box.read("Dhikr 3") ?? false;
      dhikrs["Dhikr 4"] = box.read("Dhikr 4") ?? false;
      dhikrs["Dhikr 5"] = box.read("Dhikr 5") ?? false;
    } else {
      box.write("dhdate", today);
      box.write("Dhikr 1", false);
      box.write("Dhikr 2", false);
      box.write("Dhikr 3", false);
      box.write("Dhikr 4", false);
      box.write("Dhikr 5", false);
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Dhikr"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(dhikrs.length, (index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Card(
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  color: Colors.lightGreen,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: CheckboxListTile(
                      title: Text(dhikrs.keys.elementAt(index)),
                      autofocus: false,
                      activeColor: Colors.white,
                      checkColor: Colors.green,
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: const EdgeInsets.all(0),
                      value: dhikrs.values.elementAt(index),
                      selected: dhikrs.values.elementAt(index),
                      onChanged: (value) {
                        setState(() {
                          dhikrs[dhikrs.keys.elementAt(index)] = value!;
                          box.write(dhikrs.keys.elementAt(index), value);
                        });
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
