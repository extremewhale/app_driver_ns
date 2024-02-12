import 'package:animate_do/animate_do.dart';
import 'package:app_driver_ns/data/models/travel_info.dart';
import 'package:app_driver_ns/modules/travel/components/client_info_tile.dart';
import 'package:app_driver_ns/modules/travel/components/slider_button_confirm.dart';
import 'package:app_driver_ns/modules/travel/travel_controller.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/custom_markers.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'components/layer_unique.dart';

class TravelPage extends StatelessWidget {
  final _conX = Get.put(TravelController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _conX.handleBack(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _buildMap(),
            _buildView(),
            _buildPlacerHolder(),
            _buildMarkers(),

            // AkInput(),
            // _buildSecureCodeDialog(),
            /* AlertDialog(
              content: Text('¿Desea cerrar la aplicación?'),
              actions: [
                MaterialButton(
                  child: Text('SI'),
                  onPressed: () {
                    Get.back(result: true);
                  },
                ),
                MaterialButton(
                  child: Text('NO'),
                  onPressed: () {
                    Get.back(result: false);
                  },
                )
              ],
            ), */
            // _buildStarting(),
          ],
        ),
      ),
    );
  }

  Widget _buildView() {
    return Obx(() {
      Widget widget = SizedBox();
      switch (_conX.modoVista.value) {
        case ModoVistaT.unique:
          widget = _LayerUnique(conX: _conX);
          break;
      }
      return widget;
    });
  }

  Widget _buildMap() {
    return GetBuilder<TravelController>(
      id: 'gbOnlyMap',
      builder: (_) {
        return _conX.existsPosition
            ? Listener(
                onPointerDown: _conX.onUserStartMoveMap,
                child: GoogleMap(
                  padding: _conX.mapInsetPadding,
                  initialCameraPosition: _conX.initialPosition!,
                  mapType: MapType.normal,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  tiltGesturesEnabled: false,
                  markers: _conX.markers,
                  polylines: _conX.polylines,
                  onMapCreated: _conX.onMapCreated,
                  minMaxZoomPreference: MinMaxZoomPreference(1, 19),
                ),
              )
            : SizedBox();
      },
    );
  }

/*   Widget _buildMarkers() {
    return GetBuilder<TravelController>(
      id: 'gbMarkers',
      builder: (_) {
        return IgnorePointer(
          child: Transform.translate(
            offset: Offset(-Get.width, -Get.height),
            child: Column(
              children: [
                RepaintBoundary(
                  key: _conX.markerOrigenKey,
                  child: PopupMarker(
                    origin: true,
                    streetName: 'Partida',
                    mini: true,
                    onlyDot: true,
                  ),
                ),
                RepaintBoundary(
                  key: _conX.markerDestinoKey,
                  child: PopupMarker(
                    origin: false,
                    streetName: 'Destino',
                    mini: true,
                    onlyDot: true,
                  ),
                ),
                RepaintBoundary(
                  key: _conX.markerMyPositionKey,
                  child: MyPositionMarker(
                    pSize: 65.0,
                  ),
                ),
                /* RepaintBoundary(
                  key: _conX.markerNewClientKey,
                  child: DestinyMarker(
                    origin: false,
                    hidePopup: true,
                    pSize: 55.0,
                  ),
                ), */
                /* RepaintBoundary(
                    key: _conX.markerMyPositionKey,
                  child: DestinyMarker(
                    origin: false,
                    pSize: 45.0,
                    streetName: 'Destino',
                  ),
                ), */
              ],
            ),
          ),
        );
      },
    );
  } */
  Widget _buildMarkers() {
    return GetBuilder<TravelController>(
      id: 'gbMarkers',
      builder: (_) {
        return Transform.translate(
          offset: Offset(-Get.width, -Get.height),
          child: Column(
            children: [
              RepaintBoundary(
                key: _conX.markerOrigenKey,
                child: PopupMarker(
                  origin: true,
                  streetName: 'Partida',
                  mini: true,
                ),
              ),
              RepaintBoundary(
                key: _conX.markerDestinoKey,
                child: PopupMarker(
                  origin: false,
                  streetName: 'Destino',
                  mini: true,
                ),
              ),
              RepaintBoundary(
                key: _conX.markerDriverKey,
                child: Image.asset(
                  'assets/img/car_1_grey.png',
                  width: 18.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlacerHolder() {
    Widget layer = Stack(
      children: [
        Container(color: akPrimaryColor),
        Opacity(
          opacity: .6,
          child: Container(
            decoration: BoxDecoration(
              color: akPrimaryColor,
              image: DecorationImage(
                image: AssetImage("assets/img/street_map_pattern_white.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(akContentPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.all(Get.width * 0.03),
                decoration: BoxDecoration(
                  color: Helpers.darken(akAccentColor, 0.075),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: PulseAnimationCustom(
                  infinite: true,
                  child: RadarIcon(origin: false, pSize: Get.width * 0.20),
                  maxZoom: 1.2,
                ),
              ),
              SizedBox(height: 20.0),
              AkText(
                'Servicio iniciado!', // .toUpperCase(),
                type: AkTextType.h6,
                style: TextStyle(color: akWhiteColor),
              ),
              SizedBox(height: 10.0),
              /* AkText(
                'Cargando...',
                type: AkTextType.h9,
                style: TextStyle(
                  color: akWhiteColor.withOpacity(.45),
                  fontWeight: FontWeight.normal,
                ),
              ), */
              SpinLoadingIcon(
                color: akWhiteColor.withOpacity(.45),
                size: akFontSize + 10.0,
              ),
              SizedBox(height: 50.0),
            ],
          ),
        ),
      ],
    );

    return Obx(
      () => AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: _conX.isLocalizando.value ? layer : SizedBox(),
      ),
    );
  }
}
