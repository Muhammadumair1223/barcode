import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'DailyStop Stock';

  static Color kPrimaryColor = const Color(0xFF6F35A5);
  static Color kPrimaryLightColor = const Color(0xFFF1E6FF);
  static double defaultPadding = 16.0;

  static const int customerId = 54; // Walking	Customer

  static const String urlBase = "https://efoodapiapi.azure-api.net";

  static const String urlStorageBase = "https://efood.blob.core.windows.net";

  static const String branch = "/api/branch";

  static const String product = "/api/product/all/branch";

  static const String category = "/api/category/branch";

  static const String side = "/api/side/branch";

  static const String addon = "/api/addon/branch";

  static const String login = "/token/authenticate";

  static const String profile = "/api/chef/profile";

  static const String receiptEmail = "jose082@gmail.com";

  static const String placeOrder = "/api/order/place";

  static const String customerAdd = "/api/stripe/customer/add";

  static const String paymentAdd = "/api/stripe/payment/add";

  static String urlSaleCloud2 = "https://dev.pay.link/payapi/GenerateSnippet";

  static String urlGetTransaccionCloud2 =
      "https://dev.pay.link/payapi/GetTransactionResponse";

  // Shared Key
  static const String token = 'token';
  static const String branchId = 'branch_id';

  //static const String tokenPaymentCloud2 = "243b24acbd8745f59fe04ca30be8eed2";
  //static const String serialDevice = "1240204912";

  static const String tokenPaymentCloud2 = "41af75d8638d4b4498dc4e8c56e089db";
  static const String serialDevice = "2290004840";

  static const int branchIdDailyStop = 31;

  // Shared Key
  static const String theme = 'theme';

  static const String urlRemoveBg = "https://api.remove.bg/v1.0/removebg";

  static const String tokenRemoveBg = "RcavZs7cJy8NndySSwkQErWK";
}
