import 'package:app_driver_ns/modules/travel/rating/travel_rating_controller.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class TravelRatingPage extends StatelessWidget {
  final _conX = Get.find<TravelRatingController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(akContentPadding),
      child: Column(
        children: [
          _buildDriverInfo(),
          _buildEnviar(),
        ],
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const RoundedAvatar(),
            SizedBox(height: 5.0),
            // AkText(
            //   _conX.clientName,
            //   style: TextStyle(fontWeight: FontWeight.w800),
            // ),
            // SizedBox(height: 5.0),
            // AkText(
            //   'Miembro desde hace 4 años',
            //   type: AkTextType.comment,
            //   style: TextStyle(color: akTextColor.withOpacity(.5)),
            // ),
            SizedBox(height: 10.0),
            Divider(color: akGreyColor),
            SizedBox(height: 10.0),
            Obx(() => AkText(
                  _conX.ratingName.value,
                  type: AkTextType.body1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: akSecondaryColor),
                )),
            SizedBox(height: 5.0),
            _buildRating(),
            SizedBox(height: 10.0),
            /* AkInput(
              filledColor: Colors.transparent,
              type: AkInputType.underline,
              hintText: 'Escribe una nota de agradecimiento',
            ), */
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _buildRating() {
    return RatingBar.builder(
      glow: false,
      initialRating: _conX.ratingValue,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: _conX.changeRatingValue,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: akPrimaryColor,
      title: Text(
        'Calificar cliente',
        style: TextStyle(color: akWhiteColor),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: akWhiteColor,
        ),
        onPressed: _conX.onCloseTap,
      ),
    );
  }

  Widget _buildEnviar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AkText(
          'Todas las calificaciones son anónimas',
          type: AkTextType.comment,
          style: TextStyle(color: akTextColor.withOpacity(.45)),
        ),
        SizedBox(height: 7.0),
        AkButton(
          enableMargin: false,
          fluid: true,
          onPressed: _conX.guardarCalificacion,
          text: 'Enviar',
        ),
      ],
    );
  }
}
