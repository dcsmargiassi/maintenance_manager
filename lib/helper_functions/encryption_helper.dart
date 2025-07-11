import 'package:cloud_functions/cloud_functions.dart';

Future<String> encryptField(String plaintext) async {
  if (plaintext.isEmpty) return '';
  try {
    final callable = FirebaseFunctions.instance.httpsCallable('aesEncrypt');
    final result = await callable.call(<String, dynamic>{'text': plaintext});
  return result.data['encrypted'] as String;
  } catch (e) {
    throw Exception('Encryption failed: $e');
  }
}

Future<String> decryptField(String encrypted) async {
  try {
    final callable = FirebaseFunctions.instance.httpsCallable('aesDecrypt');
    final result = await callable.call({'encrypted': encrypted});
    return result.data['decrypted'];
  } catch (e) {
    throw Exception('Decryption failed: $e');
  }
}