class Config {
  static const URL_API_BACKEND = 'http://178.128.158.138:8091';
  //static const URL_API_BACKEND = 'http://192.168.100.11:3000';
  static const URL_API_GAMANET = 'http://api2.gamanet.pe/smssend';
  static const API_CARD_GAMANET = '6580052761';
  static const API_KEY_GAMANET = 'MBZ4VLQHGCKZ';
  static const API_TOKEN_GAMANET = 'NjU4MDA1Mjc2MTpNQlo0VkxRSEdDS1o=';
  static String TOKEN = "";
  static const API_GOOGLE_KEY = 'AIzaSyDn0njgdzbg-dYVqbpr-MMFvowOJiMlpbA';
  static const FCM_SERVER_KEY =
      'AAAAbBjad50:APA91bF9lUMQIHUz_EIM2Srlmv2seS6Vm4YCc3I1cv_6LgAUL0of1qGDV3V9phrQxNZJFPIfn6oP9qIT7FchvH3VrwYoka07QAVZXBcPbKVt0sO-r5jXDS6ZfYUsIX4OuwEzprwl7n6L';

  // ID TIPOS SERVICIO
  static const int ID_TIPO_SERVICIO_REGULAR = 8;
  static const int ID_TIPO_SERVICIO_TURISTICO = 7;

  static const DARKTHEME = true;

  // SMS
  static const APP_COMPANY_NAME = 'TaxiGuaa';
  static const APP_SIGNATURE = 'qn6Tubw789g';
  static const TEST_PHONE_NUMBERS = [
    '+51111111111',
    '+51222222222',
    '+51333333333',
    '+51444444444',
    '+51555555555',
    '+51666666666',
    '+51777777777',
    '+51888888888',
    '+51999999999',
  ];
  static const int SMS_RETRY_TIME = 30;
}
