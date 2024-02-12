import 'package:app_driver_ns/data/models/cliente.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientTileInfo extends StatelessWidget {
  final Color carColor;
  final ClienteCreateParams? clienteData;

  const ClientTileInfo({this.carColor = Colors.white, this.clienteData});

  @override
  Widget build(BuildContext context) {
    final avatarSize = Get.width * 0.12;

    Widget tile = Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: ImageFade(
            width: avatarSize,
            height: avatarSize,
            imageUrl:
                'https://laguiauruguay.com.uy/wp-content/uploads/avatar-default.png',
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AkText(
                clienteData?.nombres ?? '',
                type: AkTextType.subtitle1,
              ),
              SizedBox(height: 2.0),
              Row(
                children: [
                  AkText(
                    'Pasajero'.toUpperCase(),
                    style: TextStyle(
                        color: akTextColor.withOpacity(.56),
                        fontSize: akFontSize * 0.65),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 15.0),
        Column(
          children: [
            Row(
              children: [
                Icon(Icons.star_rounded,
                    color: akAccentColor, size: akFontSize * 1.15),
                SizedBox(width: 5.0),
                AkText(
                  '4.8',
                  type: AkTextType.caption,
                  style: TextStyle(
                    color: akTextColor.withOpacity(.95),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return tile;
  }
}
