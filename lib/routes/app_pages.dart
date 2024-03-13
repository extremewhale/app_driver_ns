import 'package:app_driver_ns/modules/billetera/billetera_page.dart';
import 'package:app_driver_ns/modules/billetera/detalle_ingresos/mis_ingresos_detalle_page.dart';
import 'package:app_driver_ns/modules/billetera/ingresos/mis_ingresos_page.dart';
import 'package:app_driver_ns/modules/billetera/recargar/recarga_page.dart';
import 'package:app_driver_ns/modules/cancelacion/cancelado/cancelacion_servicio_page.dart';
import 'package:app_driver_ns/modules/contact/contact_page.dart';
import 'package:app_driver_ns/modules/faq/faq_binding.dart';
import 'package:app_driver_ns/modules/faq/faq_page.dart';
import 'package:app_driver_ns/modules/intro/intro_page.dart';
import 'package:app_driver_ns/modules/mapa/mapa_page.dart';
import 'package:app_driver_ns/modules/mis_viajes/detalle/mis_viajes_detalle_page.dart';
import 'package:app_driver_ns/modules/mis_viajes/mis_viajes_page.dart';
import 'package:app_driver_ns/modules/misc/error/misc_error_page.dart';
import 'package:app_driver_ns/modules/perfil/banco/perfil_banco_page.dart';
import 'package:app_driver_ns/modules/perfil/datos/perfil_datos_page.dart';
import 'package:app_driver_ns/modules/perfil/dni_details/perfil_dni_details_page.dart';
import 'package:app_driver_ns/modules/perfil/email_details/perfil_email_details_page.dart';
import 'package:app_driver_ns/modules/perfil/inicio/perfil_inicio_page.dart';
import 'package:app_driver_ns/modules/perfil/licencia/perfil_licencia_page.dart';
import 'package:app_driver_ns/modules/prueba/prueba_page.dart';
import 'package:app_driver_ns/modules/requisitos/imagen/requisitos_imagen_page.dart';
import 'package:app_driver_ns/modules/requisitos/requisitos_page.dart';
import 'package:app_driver_ns/modules/requisitos/revision/requisitos_revision_page.dart';
import 'package:app_driver_ns/modules/secure/countries/country_selection_page.dart';
import 'package:app_driver_ns/modules/splash/splash_page.dart';
import 'package:app_driver_ns/modules/terminos/terminos_condiciones_page.dart';
import 'package:app_driver_ns/modules/travel/charges/travel_charges_page.dart';
import 'package:app_driver_ns/modules/travel/enter_secure/travel_enter_secure_page.dart';
import 'package:app_driver_ns/modules/travel/finished/travel_finished_page.dart';
import 'package:app_driver_ns/modules/travel/more_options/travel_more_options_binding.dart';
import 'package:app_driver_ns/modules/travel/more_options/travel_more_options_page.dart';
import 'package:app_driver_ns/modules/travel/rating/travel_rating_binding.dart';
import 'package:app_driver_ns/modules/travel/rating/travel_rating_page.dart';
import 'package:app_driver_ns/modules/travel/travel_page.dart';
import 'package:app_driver_ns/modules/wiki/wiki_secure_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;
  static const _transition = Transition.cupertino;

  static final routes = [
    GetPage(
        name: AppRoutes.SPLASH,
        page: () => SplashPage(),
        transition: _transition),

    GetPage(
        name: AppRoutes.INTRO,
        page: () => IntroPage(),
        transition: _transition),

    GetPage(
      name: AppRoutes.COUNTRY_SELECTION,
      page: () => CountrySelectionPage(),
      transition: _transition,
    ),

    // MIS DATOS
    GetPage(
      name: AppRoutes.PERFIL_INICIO,
      page: () => PerfilInicioPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.PERFIL_DATOS,
      page: () => PerfilDatosPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.PERFIL_DNI_DETAILS,
      page: () => PerfilDniDetailsPage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.PERFIL_BANCO,
      page: () => PerfilBancoPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.PERFIL_EMAIL_DETAILS,
      page: () => PerfilEmailDetailsPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.PERFIL_LICENCIA,
      page: () => PerfilLicenciaPage(),
      transition: _transition,
    ),

    // SECURE
    /* GetPage(
      name: AppRoutes.SECURE_PHONE,
      page: () => SecurePhonePage(),
      transition: _transition,
    ), */
    /* GetPage(
      name: AppRoutes.SECURE_EMAIL,
      page: () => SecureEmailPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.SECURE_PASSWORD,
      page: () => SecurePasswordPage(),
      transition: _transition,
    ), */
    /* GetPage(
      name: AppRoutes.SECURE_BACKEND_USER,
      page: () => SecureBackendUserPage(),
      transition: _transition,
    ), */

    GetPage(
      name: AppRoutes.REQUISITOS,
      page: () => RequisitosPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.REQUISITOS_IMAGEN,
      page: () => RequisitosImagenPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.REQUISITOS_REVISION,
      page: () => RequisitosRevisionPage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.MAPA,
      page: () => MapaPage(),
      transition: _transition,
    ),
    // TRAVEL PAGES ========================
    GetPage(
        name: AppRoutes.TRAVEL,
        page: () => TravelPage(),
        transition: _transition),
    GetPage(
        name: AppRoutes.TRAVEL_MORE_OPTIONS,
        page: () => TravelMoreOptionsPage(),
        fullscreenDialog: true,
        curve: Curves.easeInOut,
        transitionDuration: Duration(milliseconds: 700),
        binding: TravelMoreOptionsBinding()),
    GetPage(
      name: AppRoutes.TRAVEL_FINISHED,
      page: () => TravelFinishedPage(),
      transition: _transition,
    ),
    GetPage(
        name: AppRoutes.TRAVEL_RATING,
        page: () => TravelRatingPage(),
        transition: _transition,
        binding: TravelRatingBinding()),
    GetPage(
        name: AppRoutes.TRAVEL_ENTER_SECURE,
        page: () => TravelEnterSecurePage(),
        fullscreenDialog: true,
        curve: Curves.easeInOut,
        transitionDuration: Duration(milliseconds: 400)),
    GetPage(
        name: AppRoutes.TRAVEL_CHARGES,
        page: () => TravelChargesPage(),
        fullscreenDialog: true,
        curve: Curves.easeInOut,
        transitionDuration: Duration(milliseconds: 400)),

    GetPage(
        name: AppRoutes.CONTACT,
        page: () => ContactPage(),
        transition: _transition),

    GetPage(
        name: AppRoutes.TERMINOS_CONDICIONES,
        page: () => TerminosCondicionesPage(),
        transition: _transition),

    GetPage(
        name: AppRoutes.FAQ,
        page: () => FaqPage(),
        transition: _transition,
        binding: FaqBinding()),

    GetPage(
        name: AppRoutes.PRUEBA,
        page: () => PruebaPage(),
        transition: _transition),

    GetPage(
        name: AppRoutes.WIKI_SECURE_CODE,
        page: () => WikiSecureCodePage(),
        transition: _transition),

    GetPage(
        name: AppRoutes.MISC_ERROR,
        page: () => MiscErrorPage(),
        transition: _transition),

    // MIS VIAJES
    GetPage(
      name: AppRoutes.MIS_VIAJES,
      page: () => MisViajesPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.MIS_VIAJES_DETALLE,
      page: () => MisViajesDetallePage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.MI_BILLETERA,
      page: () => BilleteraPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.RECARGA,
      page: () => RecargaPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.MIS_INGRESOS,
      page: () => MisIngresosPage(),
      transition: _transition,
    ),
    GetPage(
      name: AppRoutes.MIS_INGRESOS_DETALLE,
      page: () => MisIngresosDetallePage(),
      transition: _transition,
    ),

    GetPage(
      name: AppRoutes.CANCELACION_SERVICIO,
      page: () => CancelacionRevisionPage(),
      transition: _transition,
    ),
  ];
}
