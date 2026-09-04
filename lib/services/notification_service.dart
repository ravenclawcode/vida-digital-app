import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _prefKeyReminderEnabled = 'med_reminder_enabled';

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    try {
      final String currentTimeZone =
          (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Makassar'));
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings darwinSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('Notifikasi ditekan: ${response.payload}');
      },
    );

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

  Future<bool> isReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKeyReminderEnabled) ?? true;
  }

  Future<void> setReminderEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKeyReminderEnabled, enabled);
    if (!enabled) {
      await cancelAllNotifications();
    }
  }

  static int baseIdFor(String medicationId) {
    int hash = 0;
    for (final code in medicationId.codeUnits) {
      hash = ((hash * 31) + code) & 0x7fffffff;
    }
    return hash % 200000000;
  }

  Future<void> cancelReminder(int baseId) async {
    await _notificationsPlugin.cancel(baseId + 100);
    await _notificationsPlugin.cancel(baseId + 200);
    await _notificationsPlugin.cancel(baseId + 300);
  }

  Future<void> cancelReminderFor(String medicationId) {
    return cancelReminder(baseIdFor(medicationId));
  }

  Future<void> requestAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final canSchedule =
          await androidPlugin?.canScheduleExactNotifications() ?? true;
      if (canSchedule == false) {
        await androidPlugin?.requestExactAlarmsPermission();
      }
    } catch (_) {
    }
  }

  Future<bool> _canUseExactAlarms() async {
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin == null) return true; 
      return await androidPlugin.canScheduleExactNotifications() ?? true;
    } catch (_) {
      return false;
    }
  }

  Future<void> scheduleMedicationReminders({
    required int id,
    required String medicationName,
    required DateTime scheduledTime,
    bool isEveryday = false,
  }) async {
    if (!await isReminderEnabled()) return;

    final now = tz.TZDateTime.now(tz.local);
    final mainTime = tz.TZDateTime.from(scheduledTime, tz.local);

    final reminder30 = mainTime.subtract(const Duration(minutes: 30));
    final reminder5 = mainTime.subtract(const Duration(minutes: 5));

    if (isEveryday) {
      await _scheduleReminder(
        id: id + 100,
        medicationName: medicationName,
        time: reminder30,
        message: '30 menit lagi waktunya minum obat $medicationName',
        daily: true,
      );
      await _scheduleReminder(
        id: id + 200,
        medicationName: medicationName,
        time: reminder5,
        message: '5 menit lagi waktunya minum obat $medicationName',
        daily: true,
      );
      await _scheduleAlarm(
        id: id + 300,
        medicationName: medicationName,
        time: mainTime,
        daily: true,
      );
      return;
    }

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
    bool daily = false,
  }) async {
    final exact = await _canUseExactAlarms();
    try {
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
            category: AndroidNotificationCategory.reminder,
            visibility: NotificationVisibility.public,
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: 'med_reminder',
          ),
        ),
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: daily ? DateTimeComponents.time : null,
      );
    } catch (e) {
      debugPrint('Gagal menjadwalkan pengingat $id: $e');
      if (exact) {
        try {
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
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: daily ? DateTimeComponents.time : null,
          );
        } catch (e2) {
          debugPrint('Fallback pengingat $id juga gagal: $e2');
        }
      }
    }
  }

  Future<void> _scheduleAlarm({
    required int id,
    required String medicationName,
    required tz.TZDateTime time,
    bool daily = false,
  }) async {
    final exact = await _canUseExactAlarms();
    try {
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
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: 'med_alarm',
            presentAlert: true,
            presentSound: true,
            presentBadge: true,
          ),
        ),
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        payload: medicationName,
        matchDateTimeComponents: daily ? DateTimeComponents.time : null,
      );
    } catch (e) {
      debugPrint('Gagal menjadwalkan alarm $id: $e');
      if (exact) {
        try {
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
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: medicationName,
            matchDateTimeComponents: daily ? DateTimeComponents.time : null,
          );
        } catch (e2) {
          debugPrint('Fallback alarm $id juga gagal: $e2');
        }
      }
    }
  }

  Future<List<PendingNotificationRequest>> pendingNotifications() {
    return _notificationsPlugin.pendingNotificationRequests();
  }
}
