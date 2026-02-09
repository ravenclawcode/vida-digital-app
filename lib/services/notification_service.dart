import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> scheduleMedicationReminders({
    required int id,
    required String medicationName,
    required DateTime scheduledTime,
  }) async {
    await _schedule(
      id: id + 100,
      title: 'Persiapan Minum Obat',
      body: '1 jam lagi waktunya minum $medicationName',
      time: scheduledTime.subtract(const Duration(hours: 1)),
    );

    await _schedule(
      id: id + 200,
      title: 'Hampir Waktunya',
      body: '30 menit lagi waktunya minum $medicationName',
      time: scheduledTime.subtract(const Duration(minutes: 30)),
    );

    await _schedule(
      id: id + 300,
      title: 'Waktunya Minum Obat!',
      body: 'Sekarang waktunya minum $medicationName. Jangan lupa ditandai ya!',
      time: scheduledTime,
      isAlarm: true,
    );
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime time,
    bool isAlarm = false,
  }) async {
    if (time.isBefore(DateTime.now())) {
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_channel',
          'Pengingat Obat',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          fullScreenIntent: isAlarm,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
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
}
