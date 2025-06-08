import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';

class SmsParser {
  final SmsQuery _query = SmsQuery();

  /// Requests SMS permissions. Returns true if granted.
  Future<bool> requestPermissions() async {
    final status = await Permission.sms.request();
    final receiveStatus = await Permission.receiveSms.request();
    return status.isGranted && receiveStatus.isGranted;
  }

  /// Fetches all SMS messages from the inbox.
  Future<List<SmsMessage>> fetchSms() async {
    return await _query.querySms(kind: SmsQueryKind.Inbox);
  }

  /// Parses SMS messages for expense data (customize as needed).
  List<Map<String, dynamic>> parseExpenses(List<SmsMessage> messages) {
    final expenses = <Map<String, dynamic>>[];
    for (final msg in messages) {
      // Example: Parse messages containing 'debited' and extract amount
      final body = msg.body?.toLowerCase() ?? '';
      if (body.contains('debited')) {
        final amountMatch = RegExp(r'rs\.?\s?(\d+[,.]?\d*)').firstMatch(body);
        if (amountMatch != null) {
          expenses.add({
            'amount': amountMatch.group(1),
            'date': msg.dateSent,
            'sender': msg.sender,
            'body': msg.body,
          });
        }
      }
    }
    return expenses;
  }
}
