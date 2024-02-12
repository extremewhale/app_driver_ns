import 'package:app_driver_ns/modules/travel/more_options/travel_more_options_controller.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelMoreOptionsPage extends StatelessWidget {
  final _conX = Get.find<TravelMoreOptionsController>();

  @override
  Widget build(BuildContext context) {
    final acp = akContentPadding;

    return Scaffold(
      appBar: AppBar(
        title: Text('Información'),
        backgroundColor: akScaffoldBackgroundColor,
        elevation: 2.0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: akTextColor,
            size: akFontSize + 20.0,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: acp, right: acp, bottom: acp),
        child: Column(
          children: [
            SizedBox(height: akContentPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedAvatar(),
                SizedBox(width: akContentPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AkText(
                        'Alec González',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.0),
                      AkText(
                        '4.7',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        type: AkTextType.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            AkButton(
              fluid: true,
              variant: AkButtonVariant.red,
              type: AkButtonType.outline,
              onPressed: _conX.cancelTravel,
              text: 'Cancelar viaje',
            ),
          ],
        ),
      ),
    );
  }
}
