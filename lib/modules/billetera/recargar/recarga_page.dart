import 'package:app_driver_ns/modules/billetera/recargar/recarga_controller.dart';
import 'package:app_driver_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecargaPage extends StatelessWidget {
  const RecargaPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final _conX = Get.put(RecargaController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Recarga de Saldo'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAmountInput(),
                SizedBox(height: 20),
                _buildNextButton(context),
              ],
            ),
          ),
          Obx(() => LoadingOverlay(_conX.loading.value)),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    final _conX = Get.find<RecargaController>();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: _conX.montoController,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: ' S/  Monto en soles ',
          prefixText: 'S/',
          prefixStyle: TextStyle(fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Theme.of(Get.context!).primaryColor, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    final _conX = Get.find<RecargaController>();
    return ElevatedButton(
      onPressed: () {
        if (_conX.isValidMonto()) {
          _mostrarDesplegable(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Siguiente',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  void _mostrarDesplegable(BuildContext context) {
    final _conX = Get.find<RecargaController>();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close)),
                  Expanded(
                    child: Text('Seleccione el metodo de pago',
                        textAlign: TextAlign.center),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  // Actualiza el método de pago y cierra el desplegable
                  _conX.tipoPago.value = 3;
                  Navigator.of(context).pop();

                  _mostrarDialogo();
                },
                child: Text(
                  'Yape',
                ),
              ),
              SizedBox(height: 16),
              // Puedes agregar más opciones según tus necesidades
            ],
          ),
        );
      },
    );
  }

  void _mostrarDialogo() {
    final _conX = Get.find<RecargaController>();
    final _monto = _conX.montoController.text;

    Get.dialog(
      AlertDialog(
        title: Text('Detalles de la Recarga'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text('Monto de la recarga: $_monto  S/',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            TextField(
              controller: _conX.telefonoController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Número de teléfono',
                prefixIcon: Icon(
                  Icons.phone_android,
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _conX.codigoAprobacionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Código de aprobación',
                prefixIcon: Icon(
                  Icons.security,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(Get.overlayContext!).pop();
            },
            child: Text(
              'Cancelar',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Aquí puedes realizar la lógica de procesamiento de recarga
              if (_conX.isValidData()) {
                _conX.payment();
                Navigator.of(Get.overlayContext!).pop();
              }
            },
            child: Text('Aceptar', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
