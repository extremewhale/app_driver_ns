import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:app_driver_ns/modules/mapa/mapa_controller.dart';
import 'package:app_driver_ns/routes/app_pages.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/utils/utils.dart';
import 'package:app_driver_ns/widgets/custom_markers.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'components/inicial/layer_inicial.dart';
part 'components/mensaje/layer_mensaje.dart';
part 'components/solicitud/layer_solicitud.dart';

class MapaPage extends StatelessWidget {
  final _conX = Get.put(MapaController());

  @override
  Widget build(BuildContext context) {
    _conX.setContext(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _conX.drawerKey,
        drawer: AppDrawer(drawerKey: _conX.drawerKey),
        body: GetBuilder<MapaController>(
          id: _conX.gbScaffold,
          builder: (_) {
            return Stack(
              children: [
                _buildMap(),
                _buildOfflineShadow(),
                _buildView(),
                _buildPlaceHolder(),
                _buildMarkers(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildView() {
    return Obx(() {
      Widget widget = SizedBox();
      switch (_conX.modoVista.value) {
        case ModoVista.inicial:
          widget = _LayerInicial(drawerKey: _conX.drawerKey);
          break;
        case ModoVista.solicitud:
          widget = _LayerSolicitud();
          break;
        case ModoVista.mensaje:
          widget = _LayerMensaje();
          break;
      }
      return AnimatedSwitcher(
        // Artificio para el error que surge cuando llega una solicitud
        // y el usuario está en otra página que no es el mapa
        key: Get.currentRoute == AppRoutes.MAPA
            ? null
            : ValueKey('_vKASBv_${_conX.modoVista.value}'),
        duration: Duration(milliseconds: 600),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: widget,
      );
    });
  }

  Widget _buildMap() {
    return GetBuilder<MapaController>(
      id: _conX.gbOnlyMap,
      builder: (_) {
        return _conX.existsPosition
            ? GoogleMap(
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
                // onCameraMove: taxiX.onMapMoving,
                // onCameraIdle: taxiX.onMapStopCamera,
              )
            : SizedBox();
      },
    );
  }

  Widget _buildOfflineShadow() {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      bottom: 0,
      child: Obx(
        () => Stack(
          children: [
            AnimatedOpacity(
              opacity: !_conX.isConnect.value ? 0.7 : 0,
              duration: Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: _conX.isConnect.value,
                child: Stack(
                  children: [
                    const DimmerOffline(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceHolder() {
    return Obx(() => AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _conX.isLocalizando.value ? 1 : 0,
          child: MapPlaceholder(
            ignorePoint: !_conX.isLocalizando.value,
            text: 'Cargando mapa...',
          ),
        ));
  }

  Widget _buildMarkers() {
    return GetBuilder<MapaController>(
      id: _conX.gbMarkers,
      builder: (_) {
        return IgnorePointer(
          child: Transform.translate(
            offset: Offset(-Get.width, -Get.height),
            child: Column(
              children: [
                RepaintBoundary(
                  key: _conX.markerMyPositionKey,
                  child: MyPositionMarker(
                    pSize: 65.0,
                  ),
                ),
                RepaintBoundary(
                  key: _conX.markerNewClientKey,
                  child: DestinyMarker(
                    origin: false,
                    hidePopup: true,
                    pSize: 55.0,
                  ),
                ),
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
  }
}
