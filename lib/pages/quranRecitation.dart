import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class QuranRecitation extends StatefulWidget {
  @override
  State<QuranRecitation> createState() => _QuranRecitationState();
}

class _QuranRecitationState extends State<QuranRecitation> {
  final box = GetStorage();

  Map<String, bool> quran = {
    'Only Recite': false,
    'Recite With Meaning': false,
    'Memorize Some Verse': false,
  };

  @override
  void initState() {

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String today = formatter.format(now);
    String date1 = box.read("qudate") ?? "2022-01-01";
    if (today == date1) {
      quran["Only Recite"] = box.read("Only Recite") ?? false;
      quran["Recite With Meaning"] = box.read("Recite With Meaning") ?? false;
      quran["Memorize Some Verse"] = box.read("Memorize Some Verse") ?? false;
    }else {
      box.write("qudate", today);
      box.write("Only Recite", false);
      box.write("Recite With Meaning", false);
      box.write("Memorize Some Verse", false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Quran Recitation"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(quran.length, (index) {
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
                      title: Text(quran.keys.elementAt(index)),
                      autofocus: false,
                      activeColor: Colors.white,
                      checkColor: Colors.green,
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: const EdgeInsets.all(0),
                      value: quran.values.elementAt(index),
                      selected: quran.values.elementAt(index),
                      onChanged: (value) {
                        setState(() {
                          quran[quran.keys.elementAt(index)] = value!;
                          box.write(quran.keys.elementAt(index), value);
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
