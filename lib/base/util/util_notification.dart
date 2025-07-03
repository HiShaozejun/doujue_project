import 'dart:async';
import 'dart:io';

import 'package:djqs/base/entity/notification_entity.dart';
import 'package:djqs/common/module/start/util/app_init_util.dart';
import 'package:djqs/module/home/util/home_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BaseNotificationUtil {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<ReceivedNotificationEntity> receivedNotiStream =
      StreamController<ReceivedNotificationEntity>.broadcast();

  final StreamController<String?> selectNotiStream =
      StreamController<String?>.broadcast();

  MethodChannel platform =
      MethodChannel('dexterx.dev/flutter_local_notifications_example');

  String? selectedNotificationPayload;

  int id = 0;

  BaseNotificationUtil._internal();

  factory BaseNotificationUtil() => _instance;

  static late final BaseNotificationUtil _instance =
      BaseNotificationUtil._internal();

  void init() async {
    await _initNotification();
    isPermissionGranted();
    requestPermissions();
    dealWithReceive();
    dealWithSelect();
  }

  void dealWithSelect() {
    selectNotiStream.stream.listen((String? payload) async {
      cancelAllNotifications();
      await AppInitUtil().routePage(HomeRoute.home);
    });
  }

  void dealWithReceive() {
    receivedNotiStream.stream
        .listen((ReceivedNotificationEntity receivedNotification) async {});
  }

  Future<void> showNotification(String channelId, String channelName,
      {int? id,
      String? title,
      String? body,
      String? payload,
      bool playSound = false}) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelId, channelName,
            importance: Importance.max,
            playSound: playSound,
            priority: Priority.high,
            ticker: 'ticker');
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id ?? this.id++, title, body, notificationDetails,
        payload: payload);
  }

  Future<void> _initNotification() async {
    final NotificationAppLaunchDetails? notiAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notiAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload =
          notiAppLaunchDetails!.notificationResponse?.payload;
      //initialRoute = SecondPage.routeName;
    }

    //
    final List<DarwinNotificationCategory> notiCategoryList =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        'textCategory',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        'plainCategory',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    final DarwinInitializationSettings initSettingIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        receivedNotiStream.add(
          ReceivedNotificationEntity(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      notificationCategories: notiCategoryList,
    );

    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: initSettingIOS),
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotiStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == 'navigationActionId') {
              selectNotiStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<bool> isPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
      return granted;
    }
    return true;
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final bool? grantedNotificationPermission =
          await androidImplementation?.requestPermission();
    }
  }

  void dispose() {
    receivedNotiStream.close();
    selectNotiStream.close();
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}
