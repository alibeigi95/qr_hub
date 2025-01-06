import 'package:easy_qr_code/easy_qr_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../qr_hub.dart';

class DetailsController extends GetxController {
  DetailsController({
    required this.id,
    required this.type,
  });

  String id;
  String type;
  QrCodeScanHistory? itemScan;
  QrCodeGenerateHistory? itemGenerait;
  RxBool isLoading = false.obs;
  final qrGenerator = EasyQRCodeGenerator();

  @override
  void onInit() {
    if (type == '1') {
      getOneItemGenerait();
    } else {
      getOneItemScan();
    }
    super.onInit();
  }

  Future<void> getOneItemScan() async {
    isLoading.value = true;
    final box = await Hive.openBox<QrCodeScanHistory>('historyBox');
    itemScan = box.get(id);
    isLoading.value = false;
  }

  Future<void> getOneItemGenerait() async {
    isLoading.value = true;
    final box =
        await Hive.openBox<QrCodeGenerateHistory>('qrCodeGenerationHistoryBox');
    itemGenerait = box.get(id);
    isLoading.value = false;
  }

  // Method to save generated QR code image
  Future<void> saveQRCodeImage() async {
    if (type == '1') {
      qrGenerator.saveQRCodeFromBytes(qrBytes: itemGenerait!.photo!);
      _showSnackBar('در دانلود ها ذخیره شد');
    } else {
      qrGenerator.saveQRCodeFromBytes(qrBytes: itemScan!.photo!);
      _showSnackBar('در دانلود ها ذخیره شد');
    }
  }

  void copyToClipboard() {
    if (type == '1') {
      Clipboard.setData(ClipboardData(text: itemGenerait!.text));
    } else {
      Clipboard.setData(ClipboardData(text: itemScan!.text));
    }
    _showSnackBar('متن کپی شد.');
  }

  void _showSnackBar( String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  bool isValidUrl(String url) {
    const urlPattern = r'^(https?:\/\/)?'
        r'(([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6})'
        r'(\/[^\s]*)?$';
    final regex = RegExp(urlPattern);
    return regex.hasMatch(url);
  }

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // Method to share generated QR code image
  Future<void> shareQRCodeImage() async {
    if (type == '1') {
      qrGenerator.shareQRCodeFromBytes(qrBytes: itemGenerait!.photo!);
    } else {
      qrGenerator.shareQRCodeFromBytes(qrBytes: itemScan!.photo!);
    }
  }
}
