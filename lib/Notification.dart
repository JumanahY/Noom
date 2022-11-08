import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:noom_app2/utilities.dart';

Future<void> createPlantFoodNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueID(),
      channelKey: 'basic_channel',
      title:
          '${Emojis.money_money_bag + Emojis.plant_cactus} Your Awesome Child Slipt Well!!!',
      body: 'You are A sleeping Star.',
      bigPicture: 'asset://images/bg2.png',
      notificationLayout: NotificationLayout.BigPicture,
    ),
  );
}