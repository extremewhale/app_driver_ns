// To parse this JSON data, do
//
//     final niubiz = niubizFromJson(jsonString?);

import 'dart:convert';

Niubiz niubizFromJson(String str) => Niubiz.fromJson(json.decode(str));

String niubizToJson(Niubiz data) => json.encode(data.toJson());

class Niubiz {
  String? channel;
  String? captureType;
  String? countable;
  Recarga? recarga;
  Order? order;
  Cards? card;
  CardHolder? cardHolder;
  Yape? yape;

  Niubiz({
    this.channel,
    this.captureType,
    this.countable,
    this.recarga,
    this.order,
    this.card,
    this.cardHolder,
    this.yape,
  });

  factory Niubiz.fromJson(Map<String?, dynamic> json) => Niubiz(
        channel: json["channel"],
        captureType: json["captureType"],
        countable: json["countable"],
        recarga: Recarga.fromJson(json["recarga"]),
        order: Order.fromJson(json["order"]),
        card: Cards.fromJson(json["card"]),
        cardHolder: CardHolder.fromJson(json["cardHolder"]),
        yape: Yape.fromJson(json["yape"]),
      );

  Map<String?, dynamic> toJson() => {
        "channel": channel,
        "captureType": captureType,
        "countable": countable,
        "recarga": recarga?.toJson(),
        "order": order?.toJson(),
        "card": card?.toJson(),
        "cardHolder": cardHolder?.toJson(),
        "yape": yape?.toJson(),
      };
}

class Cards {
  String? cardNumber;
  String? expirationMonth;
  String? expirationYear;
  String? cvv2;

  Cards({
    this.cardNumber,
    this.expirationMonth,
    this.expirationYear,
    this.cvv2,
  });

  factory Cards.fromJson(Map<String?, dynamic> json) => Cards(
        cardNumber: json["cardNumber"],
        expirationMonth: json["expirationMonth"],
        expirationYear: json["expirationYear"],
        cvv2: json["cvv2"],
      );

  Map<String?, dynamic> toJson() => {
        "cardNumber": cardNumber,
        "expirationMonth": expirationMonth,
        "expirationYear": expirationYear,
        "cvv2": cvv2,
      };
}

class CardHolder {
  String? firstName;
  String? lastName;
  String? email;

  CardHolder({
    this.firstName,
    this.lastName,
    this.email,
  });

  factory CardHolder.fromJson(Map<String?, dynamic> json) => CardHolder(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
      );

  Map<String?, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
      };
}

class Order {
  String? purchaseNumber;
  double? amount;
  String? currency;

  Order({
    this.purchaseNumber,
    this.amount,
    this.currency,
  });

  factory Order.fromJson(Map<String?, dynamic> json) => Order(
        purchaseNumber: json["purchaseNumber"],
        amount: json["amount"],
        currency: json["currency"],
      );

  Map<String?, dynamic> toJson() => {
        "purchaseNumber": purchaseNumber,
        "amount": amount,
        "currency": currency,
      };
}

class Recarga {
  int? idRecarga;
  int? idtipoPagoRecarga;
  int? idConductor;
  double? monto;
  String? codigoTransaccion;
  String? imgRecarga;
  String? fechaRegistro;
  bool? valRecarga;
  int? enable;

  Recarga({
    this.idRecarga,
    this.idtipoPagoRecarga,
    this.idConductor,
    this.monto,
    this.codigoTransaccion,
    this.imgRecarga,
    this.fechaRegistro,
    this.valRecarga,
    this.enable,
  });

  factory Recarga.fromJson(Map<String?, dynamic> json) => Recarga(
        idRecarga: json["idRecarga"],
        idtipoPagoRecarga: json["idtipoPagoRecarga"],
        idConductor: json["idConductor"],
        monto: json["monto"],
        codigoTransaccion: json["codigoTransaccion"],
        imgRecarga: json["imgRecarga"],
        fechaRegistro: json["fechaRegistro"],
        valRecarga: json["valRecarga"],
        enable: json["enable"],
      );

  Map<String?, dynamic> toJson() => {
        "idRecarga": idRecarga,
        "idtipoPagoRecarga": idtipoPagoRecarga,
        "idConductor": idConductor,
        "monto": monto,
        "codigoTransaccion": codigoTransaccion,
        "imgRecarga": imgRecarga,
        "fechaRegistro": fechaRegistro,
        "valRecarga": valRecarga,
        "enable": enable,
      };
}

class Yape {
  String? phoneNumber;
  String? otp;

  Yape({
    this.phoneNumber,
    this.otp,
  });

  factory Yape.fromJson(Map<String?, dynamic> json) => Yape(
        phoneNumber: json["phoneNumber"],
        otp: json["otp"],
      );

  Map<String?, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "otp": otp,
      };
}
