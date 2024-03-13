part of '../../mapa_page.dart';

class _LayerInicial extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey;

  _LayerInicial({Key? key, required this.drawerKey}) : super(key: key);

  final _conX = Get.find<MapaController>();

  final _radiusPanel = 20.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildHeader(context),
        Positioned(
          bottom: _conX.lyInicialPanelHeightClosed + 15.0,
          right: akContentPadding * 0.5,
          child: Column(
            children: [
              /* CommonButtonMap(
                icon: Icons.edit,
                isDark: _conX.isDarkTheme,
                onTap: _conX.escribir,
              ),
              SizedBox(height: 10.0), */
              /* CommonButtonMap(
                icon: Icons.view_agenda,
                isDark: _conX.isDarkTheme,
                onTap: _conX.acceptTravel,
              ),
              SizedBox(height: 10.0),
              CommonButtonMap(
                icon: Icons.person,
                isDark: _conX.isDarkTheme,
                onTap: _conX.toggleTheme,
              ),
              SizedBox(height: 10.0), */
              CommonButtonMap(
                icon: Icons.my_location,
                isDark: _conX.isDarkTheme,
                onTap: () {
                  _conX.onCenterButtonTap();
                  return;
                  // _conX.centerToMyPosition;
                  Get.offAllNamed(AppRoutes.TRAVEL, arguments: {
                    'uidClient': 'GKGSU8e05uZPeGvW5bUxYcM26fr2',
                    'idServicio': '43',
                    'clientLatLng': LatLng(-11.9397, -77.0021),
                  });
                },
              ),
            ],
          ),
        ),
        _getBuilderPanel(
          context,
        ),
      ],
    );
  }

  Widget _getBuilderPanel(BuildContext context, {bool isDark = false}) {
    // Reset variables. Important!
    _conX.lyInicialPanelHeightUpdated = false;
    _conX.lyInicialHeightFromWidgets = false;

    return GetBuilder<MapaController>(
        id: 'gbSlidePanel',
        builder: (_) {
          return SlidingUpPanel(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: Offset(0, 8),
                  blurRadius: 15,
                  spreadRadius: 5)
            ],
            color: isDark ? akPrimaryColor : akWhiteColor,
            maxHeight: _conX.lyInicialPanelHeightOpen,
            minHeight: _conX.lyInicialPanelHeightClosed,
            backdropEnabled: true,
            backdropOpacity: .15,
            panelBuilder: (sc) => _buildPanelCard(sc, context, isDark),
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(_radiusPanel)),
            onPanelSlide: (double pos) {
              _conX.updateLyInicialPanelMaxHeight();
            },
          );
        });
  }

  Widget _buildPanelCard(ScrollController sc, BuildContext context, isDark) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        children: [
          _buildPanelTitle(isDark),
          Expanded(
            child: SingleChildScrollView(
              physics: _conX.lyInicialHeightFromWidgets
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(),
              controller: sc,
              child: _buildPanelBody(isDark),
            ),
          ),
        ],
      ),
    );
  }

  RepaintBoundary _buildPanelTitle(bool isDark) {
    return RepaintBoundary(
      key: _conX.lyInicialTitleKey,
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
                    child: Column(
                      children: [
                        SizedBox(height: 6.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AkText(
                                'Hola, ${_conX.nombreConductor}',
                                style: TextStyle(
                                  color: akWhiteColor.withOpacity(.65),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Icon(Icons.person_rounded,
                                color: akWhiteColor.withOpacity(.35)),
                          ],
                        ),
                        SizedBox(height: 6.0),
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

  RepaintBoundary _buildPanelBody(bool isDark) {
    return RepaintBoundary(
      key: _conX.lyInicialBodyKey,
      child: Container(
        child: Column(
          children: [
            Column(children: [
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(
                  left: akContentPadding * 0.5,
                  right: akContentPadding * 0.75,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.list_rounded,
                      color: isDark
                          ? akWhiteColor.withOpacity(.75)
                          : akTextColor.withOpacity(.75),
                      size: akFontSize + 20.0,
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Obx(() => Column(
                            children: [
                              SizedBox(height: 0.0),
                              AkText(
                                _conX.isConnect.value
                                    ? 'Conectado'
                                    : 'Desconectado',
                                type: AkTextType.h7,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: _conX.isConnect.value
                                      ? akTitleColor
                                      : akTextColor,
                                ),
                              ),
                              AkText(
                                _conX.isConnect.value
                                    ? 'Esperando viajes...'
                                    : 'Sin servicio',
                                style: TextStyle(
                                    color: isDark
                                        ? akWhiteColor.withOpacity(.75)
                                        : akTextColor.withOpacity(.75),
                                    fontSize: akFontSize - 1.0),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: _conX.toggleStatus,
                      child: Obx(() => ClipRRect(
                            borderRadius: BorderRadius.circular(400.0),
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              color: _conX.isConnect.value
                                  ? akAccentColor
                                  : akPrimaryColor,
                              child: Icon(
                                Icons.power_settings_new_rounded,
                                color: _conX.isConnect.value
                                    ? akPrimaryColor
                                    : akWhiteColor,
                                size: akFontSize + 10.0,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Divider(
                  color: isDark
                      ? akWhiteColor.withOpacity(.15)
                      : Color(0xFFF3F2F7),
                  height: 1.0,
                  thickness: 1),
            ]),
            Container(
              padding: EdgeInsets.all(akContentPadding),
              child: Obx(() => AkText(
                    _conX.isConnect.value
                        ? 'Una notificación aparecerá en tu pantalla cuando un cliente requiera un servicio de Taxi.\n\nLa notificación aparecerá solo unos segundos.'
                        : 'Debes seleccionar el botón de arriba para conectarte a nuestros servicios y utilizar la aplicación.\n\nDesconéctate para dejar de recibir notificaciones de servicio.',
                    style: TextStyle(
                      color: isDark
                          ? akWhiteColor.withOpacity(.56)
                          : akTextColor.withOpacity(.56),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Positioned(
      top: akContentPadding,
      left: akContentPadding * 0.7,
      right: akContentPadding * 0.7,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                CommonButtonMap(
                  isDark: _conX.isDarkTheme,
                  icon: Icons.menu_rounded,
                  onTap: () {
                    drawerKey.currentState?.openDrawer();
                    return;
                    // _conX.acceptTravel();
                    //return;
                    //_conX.boton();
                    //return;

                    // drawerKey.currentState?.openDrawer();
                    // return;
                    /* final data = PushNotificationData(
                  uidClient: 'sdfs',
                  idServicio: 43,
                );
                _conX.onNotificationRequestReceived(data); */
                  },
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Obx(() => _conX.isPhotoIncomplete.value ||
                    _conX.isBankIncomplete.value ||
                    _conX.isLicenseIncomplete.value
                ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: akAccentColor,
                            borderRadius:
                                BorderRadius.circular(akRadiusGeneral),
                            boxShadow: [
                              BoxShadow(
                                color: akAccentColor.withOpacity(.45),
                                blurRadius: 3.0,
                                spreadRadius: 1.0,
                                offset: Offset(1.0, 2.0),
                              )
                            ],
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              onTap: _conX.onBannerProfileComplete,
                              borderRadius:
                                  BorderRadius.circular(akRadiusGeneral),
                              child: Container(
                                padding: EdgeInsets.all(akContentPadding * 0.8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          AkText('Para completar tu perfil:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              )),
                                          SizedBox(height: 8.0),
                                          _conX.isPhotoIncomplete.value
                                              ? AkText(
                                                  '• Sube tu foto de perfil')
                                              : SizedBox(),
                                          _conX.isDniIncomplete.value
                                              ? AkText(
                                                  '• Completa tu foto de Dni')
                                              : SizedBox(),
                                          _conX.isDniIncomplete.value
                                              ? AkText(
                                                  '• Completa tu foto de Dni de Reversa')
                                              : SizedBox(),
                                          _conX.isBankIncomplete.value
                                              ? AkText(
                                                  '• Completa tu cuenta bancaria')
                                              : SizedBox(),
                                          _conX.isLicenseIncomplete.value
                                              ? AkText(
                                                  '• Completa tu licencia de conducir')
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox())
          ],
        ),
      ),
    );
  }
}
