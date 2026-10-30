import 'package:url_launcher/url_launcher.dart';

class PhoneLauncher {
  PhoneLauncher._();

  static Future<void> call(String phone) async {
    final number = phone.trim().replaceAll(RegExp(r'[\s-]'), '');

    if (number.isEmpty) {
      throw Exception('Phone number is not available');
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: number);

    final bool launched = await launchUrl(
      phoneUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw Exception('Could not open phone dialer');
    }
  }
}
