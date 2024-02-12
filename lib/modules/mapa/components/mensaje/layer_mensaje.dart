part of '../../mapa_page.dart';

class _LayerMensaje extends StatelessWidget {
  _LayerMensaje({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ModalBasic extends StatelessWidget {
  ModalBasic({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Container(
            color: Colors.transparent,
          ),
          _buildCardBottom()
        ],
      ),
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
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPopup() {
    final _c = akPrimaryColor;
    final _radius = 20.0;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: akContentPadding * 0.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          color: akWhiteColor,
          boxShadow: [
            BoxShadow(
              color: _c.withOpacity(0.12),
              offset: Offset(0.0, 20.0),
              blurRadius: 40,
            )
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius - 2),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(akContentPadding),
                        color: akPrimaryColor,
                        child: Row(
                          children: [
                            Icon(
                              Icons.taxi_alert,
                              color: akAccentColor,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: AkText(
                                title,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: akWhiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: akFontSize + 2.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: akContentPadding),
              Content(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AkText(
                      content,
                      style: TextStyle(
                        fontSize: akFontSize + 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: akContentPadding),
              Content(
                child: AkButton(
                  enableMargin: false,
                  backgroundColor: Helpers.darken(akWhiteColor, 0.02),
                  onPressed: () => Get.back(),
                  text: 'Entendido',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: akFontSize + 1.0,
                  ),
                  textColor: akTitleColor,
                ),
              ),
              SizedBox(height: akContentPadding),
            ],
          ),
        ),
      ),
    );
  }
}
