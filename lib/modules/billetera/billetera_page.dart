import 'package:app_driver_ns/data/models/conductor.dart';
import 'package:app_driver_ns/modules/billetera/billetera_controller.dart';
import 'package:app_driver_ns/modules/billetera/detalle_ingresos/mis_ingresos_detalle_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BilleteraPage extends StatelessWidget {
  final _conX = Get.put(BilleteraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: akPrimaryColor),
        title: Text(
          'Tu billetera',
          style: TextStyle(color: akPrimaryColor),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: akContentPadding),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: AkText(
                "El control de tus cuentas en tus manos",
                textAlign: TextAlign.start,
              ),
            ),
            Obx(() =>
                TabMonto("Taxi Waa te debe: ", _conX.pendientepago.value)),
            Obx(() =>
                TabMonto("Tus ganancias del día: ", _conX.totalefectivo.value)),
            Obx(() => TabMonto("Saldo actual: ", _conX.saldoactual.value)),
            TabRecargar("Recargar"),
            TabMisIngresos("Mis ingresos")

            // Expanded(
            //   child: Container(
            //     width: double.infinity,
            //     child: Obx(
            //       () => AnimatedSwitcher(
            //         duration: Duration(milliseconds: 300),
            //         child: _conX.fetching.value
            //             ? _ResultSkeletonList()
            //             : _ResultList(conX: _conX),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Container TabMonto(String etiqueta, String monto) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: akWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF8B8D8D).withOpacity(.10),
            offset: Offset(0, 4),
            spreadRadius: 4,
            blurRadius: 8,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                // await Get.delete<MisViajesDetalleController>();
                //  Get.toNamed(AppRoutes.MIS_VIAJES_DETALLE,
                //arguments: MisViajesDetalleArguments(servicio: servicio));
                print('tab');
              },
              child: Container(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(akContentPadding * 0.76),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AkText(
                            etiqueta,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: akTitleColor,
                              fontWeight: FontWeight.w500,
                              fontSize: akFontSize,
                              height: 1.4,
                            ),
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AkText(
                                  'S/. ' + monto,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: akTitleColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: akFontSize + 4.0,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_sharp)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container TabRecargar(String etiqueta) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: akWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF8B8D8D).withOpacity(.10),
            offset: Offset(0, 4),
            spreadRadius: 4,
            blurRadius: 8,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: _conX.goToPageRecargar,
              child: Container(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(akContentPadding * 0.76),
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                            width: 20,
                          ),
                          AkText(
                            etiqueta,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: akTitleColor,
                              fontWeight: FontWeight.w500,
                              fontSize: akFontSize,
                              height: 1.4,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Icon(Icons.arrow_forward_ios_sharp)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container TabMisIngresos(String etiqueta) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: akWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF8B8D8D).withOpacity(.10),
            offset: Offset(0, 4),
            spreadRadius: 4,
            blurRadius: 8,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: _conX.goToPageMisIngresos,
              child: Container(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(akContentPadding * 0.76),
                      child: Row(
                        children: [
                          Icon(Icons.attach_money),
                          SizedBox(
                            width: 20,
                          ),
                          AkText(
                            etiqueta,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: akTitleColor,
                              fontWeight: FontWeight.w500,
                              fontSize: akFontSize,
                              height: 1.4,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Icon(Icons.arrow_forward_ios_sharp)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultSkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (_, i) => _SkeletonItem(),
    );
  }
}

class _SkeletonItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Content(
      child: Container(
        margin: EdgeInsets.only(bottom: 18.0),
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 20.0,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Helpers.darken(akScaffoldBackgroundColor, 0.02)),
        child: Opacity(
          opacity: .55,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 8, child: Skeleton(fluid: true, height: 18.0)),
                  Expanded(flex: 4, child: SizedBox())
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(flex: 4, child: Skeleton(fluid: true, height: 12.0)),
                  Expanded(flex: 6, child: SizedBox()),
                  Expanded(flex: 2, child: Skeleton(fluid: true, height: 12.0))
                ],
              ),
              SizedBox(height: 2.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  final BilleteraController conX;

  const _ResultList({Key? key, required this.conX}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (conX.lista.length == 0) {
      return _NoItems();
    }

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: conX.lista.length,
      itemBuilder: (_, i) {
        return Content(
          child: _ListItem(
            transaccion: conX.lista[i],
          ),
        );
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  final Transaccione transaccion;

  const _ListItem({
    Key? key,
    required this.transaccion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String destino = servicio.ruta?.nombreDestino ?? '';
    // final arrSplit = destino.split(',');
    // if (arrSplit.isNotEmpty) {
    //   destino = arrSplit[0];
    // }

    String fechaSalida = '';

    // final dia = Helpers.capitalizeFirstLetter(
    //     DateFormat('EEEE', 'es').format(servicio.fechaSalida));
    // fechaSalida = dia +
    //     ', ' +
    //     DateFormat('d', 'es').format(servicio.fechaSalida) +
    //     ' de ' +
    //     DateFormat('MMMM', 'es').format(servicio.fechaSalida) +
    //     ' a las ' +
    //     DateFormat('h:mm aa', 'es').format(servicio.fechaSalida);

    return Container(
      margin: EdgeInsets.only(bottom: akContentPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: akWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF8B8D8D).withOpacity(.10),
            offset: Offset(0, 4),
            spreadRadius: 4,
            blurRadius: 8,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              // onTap: () async {
              //   await Get.delete<MisViajesDetalleController>();
              //   Get.toNamed(AppRoutes.MIS_VIAJES_DETALLE,
              //       arguments: MisViajesDetalleArguments(servicio: servicio));
              // },
              child: Container(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(akContentPadding * 0.76),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AkText(
                              'S/. ' + transaccion.monto.toString(),
                              maxLines: 2,
                              style: TextStyle(
                                color: akTitleColor,
                                fontWeight: FontWeight.w500,
                                fontSize: akFontSize + 2.0,
                                height: 1.4,
                              ),
                            ),
                          ),
                          Expanded(
                            child: AkText(
                              transaccion.idTipoAbono == 1
                                  ? 'Abono'
                                  : 'Comision',
                              maxLines: 2,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: transaccion.idTipoAbono == 1
                                    ? Color(0xFF007DE5)
                                    : akSecondaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: akFontSize - 1.0,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LabelTypeDetalleViaje extends StatelessWidget {
  final bool isReserva;

  const LabelTypeDetalleViaje({Key? key, this.isReserva = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: (isReserva ? akSecondaryColor : Color(0xFF007DE5))
            .withOpacity(0.12),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: isReserva ? akSecondaryColor : Color(0xFF007DE5),
            size: akFontSize,
          ),
          SizedBox(width: 4.0),
          AkText(
            isReserva ? 'Reserva' : 'Regular',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isReserva ? akSecondaryColor : Color(0xFF007DE5),
              fontSize: akFontSize - 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .6,
      child: Container(
        color: Colors.transparent,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: akContentPadding * 2,
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: Get.width * 0.35),
              /* SvgPicture.asset(
                'assets/icons/empty_box.svg',
                width: Get.width * 0.22,
                color: akTextColor.withOpacity(.45),
              ), */
              AkText(
                'No hay resultados',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
