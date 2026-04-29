import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../data/models/announcement_model.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'sgm_announcements';
  static const _channelName = 'SGM Announcements';

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);

    // Create the notification channel (Android 8+)
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'School announcements and notices',
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Request permission (Android 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showAnnouncementNotification(AnnouncementModel announcement) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'School announcements and notices',
        importance: Importance.high,
        priority: Priority.high,
        subText: _typeLabel(announcement.type),
        styleInformation: BigTextStyleInformation(announcement.body),
        ticker: announcement.title,
      ),
    );

    await _plugin.show(
      announcement.id.hashCode.abs() % 100000,
      announcement.title,
      announcement.body,
      details,
    );
  }

  String _typeLabel(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.exam: return 'Exam';
      case AnnouncementType.holiday: return 'Holiday';
      case AnnouncementType.event: return 'Event';
      case AnnouncementType.fee: return 'Fee';
      case AnnouncementType.sports: return 'Sports';
      case AnnouncementType.general: return 'General';
    }
  }
}
