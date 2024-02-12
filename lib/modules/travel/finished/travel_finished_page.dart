import 'package:app_driver_ns/modules/travel/finished/travel_finished_controller.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelFinishedPage extends StatelessWidget {
  final _conX = Get.put(TravelFinishedController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: _buildContent(constraints),
              physics: BouncingScrollPhysics(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
      child: IntrinsicHeight(
        child: Column(
          children: [
            GetBuilder<TravelFinishedController>(
                id: 'gbPayBar',
                builder: (_) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: (_conX.loadingData)
                        ? _buildPaymentTypeBarSkeleton()
                        : _buildPaymentTypeBar(),
                  );
                }),
            GetBuilder<TravelFinishedController>(
                id: 'gbContent',
                builder: (_) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: (_conX.loadingData)
                        ? _buildDetailsSkeleton()
                        : _buildDetails(),
                  );
                }),
            /* AkButton(
              onPressed: _conX.getTravelData,
              text: 'Traer data',
            ), */
            Expanded(child: SizedBox()),
            GetBuilder<TravelFinishedController>(
              id: 'gbBottom',
              builder: (_) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: (_conX.loadingData)
                      ? _buildFinishButtonsSkeleton()
                      : _buildFinishButtons(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
      padding: EdgeInsets.all(akContentPadding * 0.75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.0),
          Container(
              alignment: Alignment.center,
              child: AkText('Total del viaje', type: AkTextType.h9)),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AkText('S/.', type: AkTextType.h6),
              SizedBox(width: 20.0),
              GetBuilder<TravelFinishedController>(
                id: 'gbTotal',
                builder: (_) => AnimatedSwitcher(
                  duration: Duration(milliseconds: 100),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: Obx(
                    () => AkText(_conX.total.value,
                        type: AkTextType.h3,
                        key: ValueKey('gbT' + _conX.total.value)),
                  ),
                ),
              ),
              SizedBox(width: 40.0),
            ],
          ),
          SizedBox(height: 20.0),
          // _buildCalificateClient(),
          _buildAditionalCharges(),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _buildDescriptionTravel() {
    Color _otherTextColor = akTextColor.withOpacity(.65);
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            child: AkText('Detalles del viaje', type: AkTextType.h9)),
        SizedBox(height: 15.0),
        Container(
            padding: EdgeInsets.symmetric(horizontal: akContentPadding),
            alignment: Alignment.center,
            child: AkText(
              _conX.detalleTotal,
              style: TextStyle(color: _otherTextColor),
            )),
      ],
    );
  }

  Widget _buildAditionalCharges() {
    return Obx(
      () => _conX.extraTotal.value.isEmpty
          // VISTA CON CARGOS
          ? Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: AkText(
                    '¿Cargos adicionales?',
                    type: AkTextType.body1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                AkButton(
                  backgroundColor: Color(0xFFF9F9F9),
                  onPressed: _conX.goToChargesPage,
                  text: '',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle, color: akTextColor),
                      SizedBox(width: 10.0),
                      AkText('Incluir cargo adicional'),
                    ],
                  ),
                  variant: AkButtonVariant.white,
                ),
              ],
            )
          // VISTA SIN CARGOS
          : Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: AkText(
                      'Detalles del monto',
                      type: AkTextType.body1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: akContentPadding * 0.5,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10.0),
                        Obx(() => _buildConceptItem(
                            'SubTotal', 'S/ ' + _conX.costo.value)),
                        _buildConceptItem(
                            _conX.extraLabel, 'S/ ' + _conX.extraTotal.value),
                        Dash(
                            direction: Axis.horizontal,
                            length: Get.width - akContentPadding * 2 - (12.0),
                            dashLength: 6,
                            dashColor: akBlackColor.withOpacity(.25)),
                        SizedBox(height: 10.0),
                        _buildConceptItem('Total', 'S/ ' + _conX.total.value,
                            isTotal: true),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: AkButton(
                          type: AkButtonType.outline,
                          variant: AkButtonVariant.red,
                          onPressed: _conX.removeExtraCharges,
                          text: '',
                          borderRadius: 8.0,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.remove_circle,
                                color: akRedColor,
                                size: akFontSize - 1.0,
                              ),
                              SizedBox(width: 10.0),
                              AkText(
                                'Eliminar cargos',
                                style: TextStyle(
                                  color: akRedColor,
                                  fontSize: akFontSize - 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildConceptItem(String concept, String amount,
      {bool isTotal = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AkText(
              concept,
              type: AkTextType.comment,
              style: TextStyle(
                color: isTotal
                    ? akTextColor.withOpacity(.85)
                    : akTextColor.withOpacity(.65),
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          AkText(
            amount,
            type: AkTextType.comment,
            style: TextStyle(
              color: isTotal
                  ? akTextColor.withOpacity(.85)
                  : akTextColor.withOpacity(.65),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalificateClient() {
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            child: AkText('Evalúa al cliente', type: AkTextType.h9)),
        SizedBox(height: 10.0),
        AkButton(
          onPressed: _conX.goToRatingPage,
          text: '',
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const RoundedAvatar(size: 30),
                  SizedBox(width: 10.0),
                  AkText('Alec'),
                ],
              ),
              AkText(
                'Calificar',
                style: TextStyle(color: akSecondaryColor),
              ),
            ],
          ),
          variant: AkButtonVariant.white,
        ),
      ],
    );
  }

  Widget _buildFinishButtons() {
    Widget spin = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinLoadingIcon(
          color: akPrimaryColor,
          size: akFontSize + 3.0,
          strokeWidth: 3.0,
        )
      ],
    );

    return Container(
      padding: EdgeInsets.all(akContentPadding * 0.75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() => AkButton(
                onPressed: _conX.finishPaymentAndContinue,
                text: 'Finalizar cobro y seguir',
                variant: AkButtonVariant.accent,
                textColor: akTextColor,
                child: _conX.loadingPayment.value ? spin : null,
              )),
          AkButton(
            onPressed: _conX.finishPaymentAndOffline,
            text: 'Finalizar cobro y desconectarse',
            type: AkButtonType.outline,
            variant: AkButtonVariant.primary,
            child: _conX.loadingPayment.value ? spin : null,
            enableMargin: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTypeBar() {
    Color _colorPaymentType = Color(0xFF007DE5);
    return Container(
      padding: EdgeInsets.all(akContentPadding),
      color: _colorPaymentType,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Container(
              color: akWhiteColor,
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.attach_money_sharp,
                color: _colorPaymentType,
                size: akFontSize + 3.0,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          AkText(
            'Pago con efectivo',
            style: TextStyle(color: akWhiteColor),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: akPrimaryColor,
      title: Text(
        'Viaje finalizado',
        style: TextStyle(color: akWhiteColor),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildDetailsSkeleton() {
    Widget skel = Column(
      children: [
        SizedBox(height: 25.0),
        Skeleton(
          height: 22.0,
          width: Get.width * 0.4,
          borderRadius: 6.0,
        ),
        SizedBox(height: 20.0),
        Skeleton(
          height: 45.0,
          width: Get.width * 0.30,
          borderRadius: 10.0,
        ),
        SizedBox(height: 20.0),
        Skeleton(
          height: 20.0,
          width: Get.width * 0.4,
          borderRadius: 6.0,
        ),
        SizedBox(height: 20.0),
        Skeleton(
          height: 45.0,
          width: double.infinity,
          borderRadius: 10.0,
        )
      ],
    );

    return Opacity(
        opacity: .56,
        child: Container(
          padding: EdgeInsets.all(akContentPadding * 0.75),
          child: skel,
        ));
  }

  Widget _buildFinishButtonsSkeleton() {
    Widget skel = Column(
      children: [
        Skeleton(
          height: 50.0,
          width: double.infinity,
          borderRadius: 10.0,
        ),
        SizedBox(height: 10.0),
        Skeleton(
          height: 50.0,
          width: double.infinity,
          borderRadius: 10.0,
        )
      ],
    );

    return Opacity(
        opacity: .56,
        child: Container(
          padding: EdgeInsets.all(akContentPadding * 0.75),
          child: skel,
        ));
  }

  Widget _buildPaymentTypeBarSkeleton() {
    Widget skel = Column(
      children: [
        Skeleton(
          height: 68.0,
          width: double.infinity,
          borderRadius: 0.0,
        )
      ],
    );

    return Opacity(opacity: .56, child: skel);
  }
}
