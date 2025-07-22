//add multiple base urls if needed
enum ApiType { base, coffee, baseUrl, pincodeUrl }

class BaseUrlConstant {
  static const String base = 'https://jsonplaceholder.typicode.com';
  static const String coffee = 'https://api.sampleapis.com';
  // static const String localbaseUrl = 'http://192.168.1.37:5000/api/v1';

  // static const String baseUrl = 'https://server.supporttacards.com/api/v1';
  static const String baseUrl = 'http://213.210.36.7:5008/api/v1';

  static const String pincodeUrl = 'http://www.postalpincode.in/api';

  static String getBaseUrl(ApiType type) {
    switch (type) {
      case ApiType.pincodeUrl:
        return pincodeUrl;
      case ApiType.base:
        return base;
      case ApiType.coffee:
        return coffee;
      case ApiType.baseUrl:
        return baseUrl;
      // case ApiType.localbaseUrl:
      //   return localbaseUrl;
    }
  }
}
