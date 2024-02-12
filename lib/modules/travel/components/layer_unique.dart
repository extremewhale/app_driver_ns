part of '../travel_page.dart';

class _LayerUnique extends StatelessWidget {
  final TravelController conX;

  const _LayerUnique({required this.conX});

  final _radiusPanel = 20.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildToolbarButtons(),
        _buildGPSTopCard(),
        _getBuilderPanel(context),
      ],
    );
  }

  Widget _buildGPSTopCard() {
    final double _cp = akContentPadding * 0.5;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: _cp,
            horizontal: _cp,
          ),
          child: Obx(
            () => conX.gpsCardTitle.value.isEmpty
                ? SizedBox()
                : FadeInDown(
                    from: 50.0,
                    key: ValueKey('gcT' + conX.gpsCardTitle.value),
                    duration: Duration(milliseconds: 600),
                    child: Container(
                      decoration: BoxDecoration(
                          color: akPrimaryColor,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                              color: akPrimaryColor.withOpacity(.2),
                              blurRadius: 8.0,
                              spreadRadius: 2.0,
                              offset: Offset(0.0, 5.0),
                            )
                          ]),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: SvgPicture.asset(
                              'assets/icons/up_arrow.svg',
                              width: Get.size.width * 0.10,
                              color: akWhiteColor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 15.0, right: 15.0, bottom: 15.0),
                              child: Column(
                                children: [
                                  AkText(
                                    conX.gpsCardTitle.value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: akWhiteColor,
                                      fontSize: akFontSize + 3.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Divider(
                                    height: 10.0,
                                    thickness: 1.0,
                                    color: akWhiteColor.withOpacity(.035),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  AkText(
                                    conX.gpsCardSubTitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: akWhiteColor.withOpacity(.45),
                                      fontSize: akFontSize - 2.0,
                                    ),
                                  )
                                ],
                              ),
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

  Widget _getBuilderPanel(BuildContext context) {
    // Reset variables. Important!
    conX.panelHeightUpdated = false;
    conX.heightFromWidgets = false;

    return GetBuilder<TravelController>(
        id: 'gbSlidePanel',
        builder: (_) {
          return SlidingUpPanel(
            controller: conX.slidePanelController,
            boxShadow: [
              BoxShadow(
                  color: akCardShadowColor.withOpacity(1),
                  offset: Offset(0, 8),
                  blurRadius: 8,
                  spreadRadius: 10)
            ],
            maxHeight: conX.panelHeightOpen,
            minHeight: conX.panelHeightClosed,
            backdropEnabled: true,
            backdropOpacity: .15,
            panelBuilder: (sc) => _buildPanelCard(sc, context),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            onPanelSlide: (double pos) {
              conX.updatePanelMaxHeight();
            },
          );
        });
  }

  Widget _buildPanelCard(ScrollController sc, BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        children: [
          _buildPanelTitle(),
          Expanded(
            child: SingleChildScrollView(
              physics: conX.heightFromWidgets
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(),
              controller: sc,
              child: _buildPanelBody(),
            ),
          ),
        ],
      ),
    );
  }

  RepaintBoundary _buildPanelTitle() {
    return RepaintBoundary(
      key: conX.panelTitleKey,
      child: Column(children: [
        Stack(
          children: [
            Positioned.fill(
              child: Container(
                // Para corregir el error del pixel visible
                margin: EdgeInsets.only(bottom: 3.0),
                decoration: BoxDecoration(
                  color: akPrimaryColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(_radiusPanel)),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: akContentPadding * 0.75,
                        horizontal: akContentPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Obx(
                            () => FadeInDown(
                              from: 50.0,
                              key: ValueKey(
                                  'tsL' + conX.travelStatusLabel.value),
                              duration: Duration(milliseconds: 600),
                              child: AkText(
                                conX.travelStatusLabel.value,
                                type: AkTextType.h9,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: akWhiteColor),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 7.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: akWhiteColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          /* child: AkText(
                            '10 min',
                            style: TextStyle(
                                color: akWhiteColor,
                                fontWeight: FontWeight.bold),
                          ), */
                          child: Icon(
                            Icons.person,
                            color: akWhiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(_radiusPanel))),
                    child: Column(
                      children: [
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 35,
                              height: 4.5,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }

  RepaintBoundary _buildPanelBody() {
    return RepaintBoundary(
      key: conX.panelBodyKey,
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 10.0),
            _buildSlideToConfirm(),
            SizedBox(height: 20.0),
            Divider(color: Color(0xFFF6F6F6), height: 2.0, thickness: 2.0),
            SizedBox(height: 10.0),
            // Info del conductor
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: akContentPadding * 0.75),
                    child: ClientTileInfo(
                      clienteData: conX.cliente,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Divider(color: Color(0xFFF6F6F6), height: 2.0, thickness: 2.0),
            SizedBox(height: 5.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: akContentPadding),
              child: EtiquetasInicioFinStyle2(
                origenText: conX.origenNombre,
                destinoText: conX.destinoNombre,
              ),
            ),

            SizedBox(height: 5.0),
            Container(
              width: double.infinity,
              color: akPrimaryColor,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: akWhiteColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    height: 20,
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _hideButton(
                          text: 'Cancelar',
                          icon: Icons.close,
                          onTap: conX.cancelTravel),
                      _hideButton(
                          text: 'Llamar al 105',
                          icon: Icons.phone,
                          emergency: true,
                          onTap: conX.call105),
                      _hideButton(
                          text: 'Enviar SOS',
                          icon: Icons.warning_amber_rounded,
                          emergency: true,
                          // onTap: conX.onEmergencyBtnTap
                          onTap: conX.sendSOS),
                    ],
                  ),
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hideButton(
      {IconData icon = Icons.check,
      String text = '',
      void Function()? onTap,
      bool emergency = false}) {
    final txtColor = emergency ? akSecondaryColor : akWhiteColor;

    final btn = AkButton(
      contentPadding: EdgeInsets.all(akFontSize * 0.75),
      variant: emergency ? AkButtonVariant.secondary : AkButtonVariant.white,
      type: AkButtonType.outline,
      enableMargin: false,
      onPressed: () {
        onTap?.call();
      },
      child: Column(
        children: [
          Icon(
            icon,
            color: txtColor,
            size: akFontSize * 1.85,
          ),
          AkText(
            text,
            type: AkTextType.comment,
            style: TextStyle(color: txtColor),
          )
        ],
      ),
    );

    return Opacity(
        opacity: .45, child: Transform.scale(scale: .85, child: btn));
  }

  Widget _buildToolbarButtons() {
    return GetBuilder<TravelController>(
      id: 'gbMapButtons',
      builder: (_) => Positioned(
        bottom: conX.panelHeightClosed + 15.0,
        right: akContentPadding * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(
              () => AnimatedSwitcher(
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                duration: Duration(milliseconds: 400),
                child: conX.hideMapControlsButtons.value
                    ? SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CommonButtonMap(
                            child: SvgPicture.asset(
                              'assets/icons/compass.svg',
                              width: 20.5,
                              color: akPrimaryColor,
                            ),
                            onTap: () async {
                              conX.hideMapControlsButtons.value = true;
                              conX.onCompassButtonTap();
                              await Helpers.sleep(1000);
                              conX.onCompassButtonTap();
                            },
                          ),
                          SizedBox(height: 10.0),
                          CommonButtonMap(
                            child: SvgPicture.asset(
                              'assets/icons/route_3.svg',
                              width: 20.5,
                              color: akPrimaryColor,
                            ),
                            onTap: () async {
                              conX.hideMapControlsButtons.value = true;
                              conX.onBoundsButtonTap();
                              await Helpers.sleep(1000);
                              conX.onBoundsButtonTap();
                            },
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 10.0),
            NavigateButtonMap(onTap: conX.launchURL),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideToConfirm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: akContentPadding * 0.5),
      child: GetBuilder<TravelController>(
          id: 'gbConfirmButton',
          builder: (_) {
            if (conX.confirmButtonLoading) {
              return Container(
                width: double.infinity,
                height: 68.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: akAccentColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinLoadingIcon(
                      color: akTextColor,
                      size: 25.0,
                      strokeWidth: 3.0,
                    ),
                  ],
                ),
              );
            }

            String text = '';
            if (conX.travelStatus == TravelStatus.ACCEPTED) {
              text = 'Anunciar llegada';
            } else if (conX.travelStatus == TravelStatus.ARRIVED) {
              text = 'Iniciar viaje';
            } else if (conX.travelStatus == TravelStatus.STARTED) {
              text = 'Finalizar viaje';
            } else {
              text = 'No mapeado';
            }

            return Container(
              key: ValueKey('cfB${conX.travelStatus.toString()}'),
              child: SliderButtonConfirm(
                btnColor: akAccentColor,
                iconColor: akTextColor,
                textColor: akTextColor,
                prefixText: 'Desliza para',
                mainText: text,
                onSubmit: conX.onConfirmSubmit,
              ),
            );
          }),
    );
  }
}
