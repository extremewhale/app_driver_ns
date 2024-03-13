part of 'app_pages.dart';

abstract class AppRoutes {
  static const SPLASH = '/splash';

  static const INTRO = '/intro';

  static const COUNTRY_SELECTION = '/country_selection';

  static const LOGIN = '/login';
  static const LOGIN_ENTER_EMAIL = '/login_enter_email';
  static const LOGIN_ENTER_PASSWORD = '/login_enter_password';
  static const LOGIN_RESET_PASSWORD = '/login_reset_password';
  static const LOGIN_EXTRA_INFO = '/login_extra_info';

  // MI CUENTA
  static const PERFIL_INICIO = '/perfil_inicio';
  static const PERFIL_DATOS = '/perfil_datos';
  static const PERFIL_DNI_DETAILS = '/perfil_dni';
  static const PERFIL_BANCO = '/perfil_banco';
  static const PERFIL_EMAIL_DETAILS = '/perfil_email_details';
  static const PERFIL_LICENCIA = '/perfil_licencia';

  // static const SECURE_PHONE = '/secure_phone';
  // static const SECURE_EMAIL = '/secure_email';
  // static const SECURE_PASSWORD = '/secure_password';
  // static const SECURE_BACKEND_USER = '/secure_backend_user';

  static const REQUISITOS = '/requisitos';
  static const REQUISITOS_IMAGEN = '/requisitos_imagen';
  static const REQUISITOS_REVISION = '/requisitos_revision';
  static const CANCELACION_SERVICIO = '/cancelacion_servicio';

  static const MAPA = '/mapa';
  static const REQUEST = '/request';

  static const TRAVEL = '/travel';
  static const TRAVEL_MORE_OPTIONS = '/travel_more_options';
  static const TRAVEL_FINISHED = '/travel_finished';
  static const TRAVEL_RATING = '/travel_rating';
  static const TRAVEL_ENTER_SECURE = '/travel_enter_secure';
  static const TRAVEL_CHARGES = '/travel_charges';

  static const CONTACT = '/contact';

  static const TERMINOS_CONDICIONES = '/terminos_condiciones';

  static const PRUEBA = '/prueba';

  static const WIKI_SECURE_CODE = '/wiki_secure_code';

  static const MISC_ERROR = '/misc_error';

  static const FAQ = '/faq';

  static const MIS_VIAJES = '/mis_viajes';
  static const MIS_VIAJES_DETALLE = '/mis_viajes_detalle';

  static const MI_BILLETERA = '/mi_billetera';
  static const RECARGA = '/recarga';
  static const MIS_INGRESOS = '/mis_ingresos';
  static const MIS_INGRESOS_DETALLE = '/mis_ingresos_detalle';
}
