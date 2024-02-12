import 'dart:math';

import 'package:app_driver_ns/modules/travel/charges/travel_charges_controller.dart';
import 'package:app_driver_ns/themes/ak_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show NumberFormat;

class TravelChargesPage extends StatelessWidget {
  final _conX = Get.put(TravelChargesController());

  static const _kBasePadding = 16.0;
  static const kExpandedHeight = 110.0;

  final ValueNotifier<double> _titlePaddingNotifier =
      ValueNotifier(_kBasePadding);

  final _scrollController = ScrollController();

  double get _horizontalTitlePadding {
    const kCollapsedPadding = 60.0;

    if (_scrollController.hasClients) {
      return min(
          _kBasePadding + kCollapsedPadding,
          _kBasePadding +
              (kCollapsedPadding * _scrollController.offset) /
                  (kExpandedHeight - kToolbarHeight));
    }

    return _kBasePadding;
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });

    return Scaffold(
      body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: akPrimaryColor,
                  expandedHeight: kExpandedHeight,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    centerTitle: false,
                    titlePadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    title: ValueListenableBuilder(
                      valueListenable: _titlePaddingNotifier,
                      builder: (context, value, child) {
                        final pad = value as double;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: pad),
                          child: AkText(
                            'Cargos adicionales',
                            style: TextStyle(color: akWhiteColor),
                          ),
                        );
                      },
                    ),
                    // background: Container(color: Colors.green),
                  ),
                  leading: IconButton(
                      onPressed: _conX.onBackTap,
                      icon: Icon(
                        Icons.arrow_downward_rounded,
                        color: akWhiteColor,
                      )),
                ),
              ),
            ];
          },
          body: Builder(builder: (context) {
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: _buildContent(),
                ),
              ],
            );
          })),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(akContentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AkText(
            'Selecciona alguno de los cargos adicionales para agregar al pago total.',
            style: TextStyle(
              color: akTextColor.withOpacity(0.65),
            ),
          ),
          _ChargeListOptions(),
          _buildSpecificAmount(),
          Row(
            children: [
              Expanded(
                  child: AkButton(
                onPressed: _conX.onBackTap,
                text: 'Cancelar',
                type: AkButtonType.outline,
              )),
              SizedBox(width: 10.0),
              Expanded(
                  child: AkButton(
                onPressed: _conX.onAddTap,
                text: ' Agregar',
                prefixIcon: Icon(Icons.add),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificAmount() {
    return Obx(
      () => AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: !_conX.showInputAmount.value
            ? SizedBox(height: 30.0)
            : Column(
                children: [
                  SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.centerRight,
                    child: AkText(
                      'Incluir monto    ',
                      type: AkTextType.body1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AkInput(
                    controller: _conX.amountCtrl,
                    focusNode: _conX.amountIptFocus,
                    filledColor: Colors.transparent,
                    type: AkInputType.underline,
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AkText(
                          ' S/.',
                          style: TextStyle(
                            fontSize: akFontSize + 8.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    // textStyle: TextStyle(fontSize: akFontSize + 6.0),
                    textAlign: TextAlign.end,
                    enableClean: false,
                    maxLength: 5,
                    inputFormatters: [
                      // _moneyMaskFormatter
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        String newText = newValue.text
                            // .replaceAll(MoneyTextFormField._cents, '')
                            .replaceAll('.', '')
                            .replaceAll(',', '')
                            .replaceAll('_', '')
                            .replaceAll('-', '');

                        String value = newText;
                        int cursorPosition = newText.length;

                        if (newText.isNotEmpty) {
                          value = _formatCurrency(
                            double.parse(newText),
                          );
                          cursorPosition = value.length;
                        }

                        return TextEditingValue(
                          text: value,
                          selection: TextSelection.collapsed(
                            offset: cursorPosition,
                          ),
                        );
                      }),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
      ),
    );
  }

  String _formatCurrency(num value) {
    ArgumentError.checkNotNull(value, 'value');

    value = value / 100;

    return NumberFormat.currency(
      // customPattern: '###.###,##',
      customPattern: '###,###.##',
      // locale: 'pt_BR',
    ).format(value);
  }
}

class _ChargeListOptions extends StatelessWidget {
  final _conX = Get.find<TravelChargesController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TravelChargesController>(
      id: 'gbListCharges',
      builder: (_) {
        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (c, i) => _ChargeListItem(
            selected: _conX.idxSelected == i,
            amount: _conX.list[i].finalAmount,
            text: _conX.list[i].fullText,
            onTap: () {
              _conX.onItemTap(i);
            },
          ),
          separatorBuilder: (c, i) => SizedBox(height: 10.0),
          itemCount: _conX.list.length,
        );
      },
    );
  }
}

class _ChargeListItem extends StatelessWidget {
  final String text;
  final String amount;
  final bool selected;
  final void Function()? onTap;

  _ChargeListItem(
      {this.selected = false, this.text = '', this.amount = '', this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: this.selected
              ? Color(0xFF43C589)
              : akPrimaryColor.withOpacity(.2),
          width: this.selected ? 1 : 1,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        onTap: () {
          this.onTap?.call();
        },
        contentPadding:
            EdgeInsets.only(left: 12.0, right: 0.0, top: 0.0, bottom: 0.0),
        minLeadingWidth: 10,
        dense: true,
        title: Container(
          margin: EdgeInsets.only(right: 15, top: 12.0, bottom: 12.0),
          child: AkText(
            this.text,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: akTextColor.withOpacity(.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leading: this.selected
            ? Icon(
                Icons.check_circle_sharp,
                color: Color(0xFF43C589),
                size: 26,
              )
            : Icon(
                Icons.circle_outlined,
                color: akTextColor.withOpacity(0.25),
                size: 26,
              ),
      ),
    );
  }
}
