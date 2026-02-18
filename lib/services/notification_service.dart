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
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Makassar'));
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(initSettings);

    const AndroidNotificationChannel alarm = AndroidNotificationChannel(
      'med_alarm',
      'Alarm Obat',
      description: 'Alarm utama waktu minum obat',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
      enableVibration: true,
      enableLights: true,
    );

    const AndroidNotificationChannel reminder = AndroidNotificationChannel(
      'med_reminder',
      'Pengingat Obat',
      description: 'Pengingat sebelum waktu minum obat',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(alarm);
    await androidPlugin?.createNotificationChannel(reminder);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
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

  Future<void> scheduleMedicationReminders({
    required int id,
    required String medicationName,
    required DateTime scheduledTime,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final mainTime = tz.TZDateTime.from(scheduledTime, tz.local);

    final reminder30 = mainTime.subtract(const Duration(minutes: 30));
    final reminder5 = mainTime.subtract(const Duration(minutes: 5));

    if (reminder30.isAfter(now)) {
      await _scheduleReminder(
        id: id + 100,
        medicationName: medicationName,
        time: reminder30,
        message: '30 menit lagi waktunya minum obat $medicationName',
      );
    }

    if (reminder5.isAfter(now)) {
      await _scheduleReminder(
        id: id + 200,
        medicationName: medicationName,
        time: reminder5,
        message: '5 menit lagi waktunya minum obat $medicationName',
      );
    }

    if (mainTime.isAfter(now)) {
      await _scheduleAlarm(
        id: id + 300,
        medicationName: medicationName,
        time: mainTime,
      );
    }
  }

  Future<void> _scheduleReminder({
    required int id,
    required String medicationName,
    required tz.TZDateTime time,
    required String message,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      'Pengingat Obat',
      message,
      time,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'med_reminder',
          'Pengingat Obat',
          channelDescription: 'Pengingat sebelum waktu minum obat',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> _scheduleAlarm({
    required int id,
    required String medicationName,
    required tz.TZDateTime time,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      'Waktunya Minum Obat!',
      'Segera minum $medicationName sekarang!',
      time,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'med_alarm',
          'Alarm Obat',
          channelDescription: 'Alarm utama waktu minum obat',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm_sound'),
          enableVibration: true,
          fullScreenIntent: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
