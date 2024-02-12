part of '../../mapa_page.dart';

class _LayerSolicitud extends StatelessWidget {
  _LayerSolicitud({Key? key}) : super(key: key);

  final _conX = Get.find<MapaController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildCardBottom(),
      ],
    );
  }

  Widget _buildCardBottom() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              akWhiteColor.withOpacity(0.0),
              akWhiteColor.withOpacity(0.25),
              akWhiteColor.withOpacity(0.95),
              akWhiteColor,
            ],
          ),
        ),
        child: Column(
          children: [
            BounceInUp(
              duration: Duration(milliseconds: 600),
              child: _buildNewPopup(),
            ),
            SizedBox(height: 0),
            FadeIn(
              delay: Duration(milliseconds: 600),
              duration: Duration(milliseconds: 600),
              child: _buildRejectTravelButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectTravelButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _conX.rejectTravel(true);
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: akContentPadding),
          padding: EdgeInsets.symmetric(vertical: akContentPadding),
          // color: Colors.blue,
          child: Column(
            children: [
              Icon(Icons.close_rounded),
              AkText('Rechazar viaje'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewPopup() {
    final _c = akPrimaryColor;
    final _radius = 15.0;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: akContentPadding * 0.5),
      decoration: BoxDecoration(
          border: Border.all(color: _c, width: 2.0),
          borderRadius: BorderRadius.circular(_radius),
          color: akPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: _c.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0.0, 10.0),
            )
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius - 2),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: _c.withOpacity(0.25),
            highlightColor: _c.withOpacity(0.15),
            onTap: _conX.acceptTravel,
            child: Stack(
              children: [
                Positioned.fill(
                  top: -2,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: double.infinity,
                    color: akWhiteColor,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(akContentPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 50.0),
                      AkText(
                        'SOLICITUD DE VIAJE',
                        textAlign: TextAlign.center,
                        type: AkTextType.h9,
                      ),
                      SizedBox(height: 20.0),
                      AkText(
                        'Recoger en',
                        textAlign: TextAlign.center,
                        type: AkTextType.comment,
                        style: TextStyle(
                          color: akTextColor.withOpacity(.5),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      AkText(
                        _conX.nrqOrigenName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: akTextColor.withOpacity(.75),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      _buildTimer(),
                      SizedBox(height: 5.0),
                    ],
                  ),
                ),
                Obx(() => _conX.loadingAccepting.value
                    ? Positioned.fill(
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: SpinLoadingIcon(
                              color: akPrimaryColor,
                              strokeWidth: 3.0,
                              size: akFontSize + 10.0,
                            ),
                          ),
                        ),
                      )
                    : SizedBox()),
                Container(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 7 / 1,
                    child: CustomPaint(
                      painter: CurvePainter2(
                        color: _c,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    Widget _bar = GetBuilder<MapaController>(
        id: _conX.gbProgressBar,
        builder: (_) => Container(
              width: double.infinity,
              height: 30.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: _conX.animationTween != null
                        ? _conX.animationTween!.value
                        : 50.0,
                    decoration: BoxDecoration(
                      color: akAccentColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: _conX.waitTime <= 5
                        ? Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: AkText(
                              '${_conX.waitTime > 10 ? _conX.waitTime : '0' + _conX.waitTime.toString()}',
                              type: AkTextType.caption,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: akPrimaryColor.withOpacity(.35)),
                            ),
                          )
                        : SizedBox(height: 6.0),
                    // child: SizedBox(height: 6.0),
                  ),
                ],
              ),
            ));
    return Column(
      children: [
        _bar,
      ],
    );
  }
}
