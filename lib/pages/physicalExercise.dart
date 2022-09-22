import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class PhysicalExercise extends StatefulWidget {
  @override
  State<PhysicalExercise> createState() => _PhysicalExerciseState();
}

class _PhysicalExerciseState extends State<PhysicalExercise> {
  final box = GetStorage();

  Map<String, bool> exercise = {
    'Walking 30min': false,
    'Meditation': false,
  };

  @override
  void initState() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String today = formatter.format(now);
    String date1 = box.read("phdate") ?? "2022-01-01";
    if (today == date1) {
      exercise['Walking 30min'] = box.read("Walking 30min") ?? false;
      exercise['Meditation'] = box.read("Meditation") ?? false;
    } else {
      box.write("phdate", today);
      box.write("Walking 30min", false);
      box.write("Meditation", false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Physical Exercise"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(exercise.length, (index) {
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
                      title: Text(exercise.keys.elementAt(index)),
                      autofocus: false,
                      activeColor: Colors.white,
                      checkColor: Colors.green,
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: const EdgeInsets.all(0),
                      value: exercise.values.elementAt(index),
                      selected: exercise.values.elementAt(index),
                      onChanged: (value) {
                        setState(() {
                          exercise[exercise.keys.elementAt(index)] = value!;
                          box.write(exercise.keys.elementAt(index), value);
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
