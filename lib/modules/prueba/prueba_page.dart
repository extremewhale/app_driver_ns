import 'package:app_driver_ns/modules/prueba/prueba_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PruebaPage extends StatelessWidget {
  final _conX = Get.put(PruebaController());

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Ejemplo de ancho y altura limitada de ConstrainedBox'),
      ),
      body: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              color: Colors.blue,
              width: 40.0,
              height: 70.0,
            ),
            Container(
              color: Colors.red,
              width: 40.0,
              height: 60.0,
            ),
            Container(color: Colors.yellow, width: 40.0),
            Container(color: Colors.yellow, width: 40.0),
          ],
        ),
      ),
    );
  }
}
