import 'package:adhan/adhan.dart';
import 'package:ebadat_assistant/models/waqt.dart';
import 'package:get_storage/get_storage.dart';

import '../util/constant.dart';

class Database {
  final box = GetStorage();
  Future<List<Waqt>> getNamazTime(String latitude, String longitude) async {
    final parameters = CalculationMethod.karachi.getParameters();
    parameters.madhab = Madhab.hanafi;
    final prayerTime = PrayerTimes.today(
        Coordinates(double.parse(latitude), double.parse(longitude)),
        parameters);

    // var url = Uri.parse(
    //     "https://api.aladhan.com/v1/calendar?latitude=$latitude&longitude=$longitude&method=1&school=1");
    // var response = await http.get(url);
    // var data = jsonDecode(response.body);
    // var result = data["data"];
    // namaz = Namaz.fromJson(result[0]["timings"]);


    /**
     * We used this format for formatting the date
     * DateFormat().add_jm().format(prayerTime.fajr)
     */

    /**
     * Write new namaz time to local database
     */
    box.write(FAJR_TIME, prayerTime.fajr.toString());
    box.write(DHUHR_TIME, prayerTime.dhuhr.toString());
    box.write(ASR_TIME, prayerTime.asr.toString());
    box.write(MAGHRIB_TIME, prayerTime.maghrib.toString());
    box.write(ISHA_TIME, prayerTime.isha.toString());
    
    List<Waqt> namaz =[
      new Waqt(
        id: 1,
        name: FAJR,
        time: prayerTime.fajr,
        isActive: box.read(FAJR) ?? false,
      ),
      new Waqt(
        id: 2,
        name: DHUHR,
        time: prayerTime.dhuhr,
        isActive: box.read(DHUHR) ?? false,
      ),
      new Waqt(
        id: 3,
        name: ASR,
        time: prayerTime.asr,
        isActive: box.read(ASR) ?? false,
      ),
      new Waqt(
        id: 4,
        name: MAGHRIB,
        time: prayerTime.maghrib,
        isActive: box.read(MAGHRIB) ?? false,
      ),
      new Waqt(
        id: 5,
        name: ISHA,
        time: prayerTime.isha,
        isActive: box.read(ISHA) ?? false,
      )
    ];
    
    return namaz;
  }
}
