import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class BaseEncryptUtil {
  static const String secretKey = 'kmsp_secret_key';
  static const String SK_AES = 'dj 32 length key................';

  static String encodeMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    return digest.toString();
  }

  static String encodeMd5Hex(String data) {
    var content = new Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    String digest = base64Encode(content);
    return digest;
  }

  static String decodeBase64(String data) =>
      String.fromCharCodes(base64Decode(data));

  static String encryptMap(Map<String, dynamic> data) {
    final key = utf8.encode(secretKey);
    final plainText = utf8.encode(json.encode(data));

    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(plainText);

    final encryptedData = {
      'data': base64Encode(plainText),
      'hash': digest.toString(),
    };

    return json.encode(encryptedData);
  }

  static Map<String, dynamic> decryptMap(String encryptedData) {
    final Map<String, dynamic> decodedData = json.decode(encryptedData);
    final key = utf8.encode(secretKey);

    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(base64Decode(decodedData['data']));

    if (digest.toString() != decodedData['hash']) {
      throw Exception('Data integrity check failed. Possible tampering.');
    }

    return json.decode(utf8.decode(base64Decode(decodedData['data'])));
  }

  static String encryptAES(str) {
    final key = Key.fromUtf8(SK_AES);
    final iv = IV.allZerosOfLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.encrypt(str, iv: iv).base64;
  }

  static String decryptAES(str) {
    final key = Key.fromUtf8(SK_AES);
    final iv = IV.allZerosOfLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.decrypt64(str!, iv: iv);
  }
}
