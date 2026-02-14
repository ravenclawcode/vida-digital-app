import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    try {
      final String currentTimeZone =
          (await FlutterTimezone.getLocalTimezone()) as String;
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('Asia/Makassar'));
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    const AndroidNotificationChannel alarmChannel = AndroidNotificationChannel(
      'med_alarm_channel',
      'Alarm Obat',
      description: 'Channel untuk alarm minum obat dengan suara keras',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
      enableVibration: true,
      enableLights: true,
    );

    const AndroidNotificationChannel reminderChannel =
        AndroidNotificationChannel(
          'med_reminder_channel',
          'Pengingat Obat',
          description: 'Channel untuk pengingat persiapan minum obat',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        );

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(alarmChannel);
    await androidPlugin?.createNotificationChannel(reminderChannel);
    await checkExactAlarmPermission();
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> scheduleMedicationReminders({
    required int id,
    required String medicationName,
    required DateTime scheduledTime,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    print("--- DEBUG SCHEDULING ---");
    print("Nama Obat: $medicationName");
    print("Waktu Sekarang (TZ): $now");
    print("Waktu Jadwal (TZ): $tzScheduledTime");

    if (tzScheduledTime.isAfter(now)) {
      await _schedule(
        id: id + 300,
        title: 'Waktunya Minum Obat!',
        body: 'Segera minum $medicationName sekarang!',
        time: scheduledTime,
        isAlarm: true,
      );
      print("✅ Berhasil dijadwalkan!");
    } else {
      print("❌ Gagal: Waktu sudah lewat.");
    }
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime time,
    bool isAlarm = false,
  }) async {
    final scheduledDate = tz.TZDateTime.from(time, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          isAlarm ? 'med_alarm_channel' : 'med_reminder_channel',
          isAlarm ? 'Alarm Obat' : 'Pengingat Obat',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: isAlarm
              ? const RawResourceAndroidNotificationSound('alarm_sound')
              : null,
          fullScreenIntent: isAlarm,
          category: isAlarm
              ? AndroidNotificationCategory.alarm
              : AndroidNotificationCategory.reminder,
          visibility: NotificationVisibility.public,
          ticker: 'ticker',
          ongoing: isAlarm,
          styleInformation: BigTextStyleInformation(''),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print(
      "Berhasil jadwalkan ${isAlarm ? 'ALARM' : 'Notif'} ID: $id pada $scheduledDate",
    );
  }

  Future<void> cancelReminder(int id) async {
    await _notificationsPlugin.cancel(id + 100);
    await _notificationsPlugin.cancel(id + 200);
    await _notificationsPlugin.cancel(id + 300);
  }

  Future<void> requestAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> testInstantAlarm() async {
    print("Menjalankan Test Alarm Instan...");

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'med_alarm_channel',
          'Alarm Obat',
          channelDescription: 'Channel untuk suara alarm obat',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm_sound'),
          fullScreenIntent: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      999,
      'TES ALARM VIDA',
      'Jika kamu mendengar suara, berarti sistem audio sudah benar!',
      platformDetails,
    );
  }

  Future<void> checkExactAlarmPermission() async {
    final platform = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (platform != null) {
      final bool? granted = await platform.requestNotificationsPermission();
      final bool? canSchedule = await platform.canScheduleExactNotifications();

      print("--- HASIL DIAGNOSA SISTEM ---");
      print("Izin Notifikasi Diberikan: $granted");
      print("Izin Exact Alarm (Tepat Waktu): $canSchedule");
    }
  }
}
