import 'dart:convert';

class CartModelResponse {
  String? cartId;
  bool? allowCod;
  String? postCode;
  String? orderNumber;
  int? totalUnits;
  int? totalItems;
  List<CartLines>? cartLines;
  List<Totals>? totals;
  bool? isCouponApplicable;

  CartModelResponse(
      {this.cartId,
        this.allowCod,
        this.postCode,
        this.orderNumber,
        this.totalUnits,
        this.totalItems,
        this.cartLines,
        this.totals,
        this.isCouponApplicable});

  CartModelResponse.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    allowCod = json['allow_cod'];
    postCode = json['post_code'];
    orderNumber = json['order_number'];
    totalUnits = json['total_units'];
    totalItems = json['total_items'];
    if (json['cart_lines'] != null) {
      cartLines = <CartLines>[];
      json['cart_lines'].forEach((v) {
        cartLines!.add(CartLines.fromJson(v));
      });
    }
    if (json['totals'] != null) {
      totals = <Totals>[];
      json['totals'].forEach((v) {
        totals!.add(new Totals.fromJson(v));
      });
    }
    isCouponApplicable = json['is_coupon_applicable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['allow_cod'] = this.allowCod;
    data['post_code'] = this.postCode;
    data['order_number'] = this.orderNumber;
    data['total_units'] = this.totalUnits;
    data['total_items'] = this.totalItems;
    if (this.cartLines != null) {
      data['cart_lines'] = this.cartLines!.map((v) => v.toJson()).toList();
    }
    if (this.totals != null) {
      data['totals'] = this.totals!.map((v) => v.toJson()).toList();
    }
    data['is_coupon_applicable'] = this.isCouponApplicable;
    return data;
  }
}

class CartLines {
  String? cartLineId;
  List<PricesRU>? prices;
  Quantity? quantity;
  List<Null>? cartLineAlerts;
  Items? items;

  CartLines(
      {this.cartLineId,
        this.prices,
        this.quantity,
        this.cartLineAlerts,
        this.items});

  CartLines.fromJson(Map<String, dynamic> json) {
    cartLineId = json['cart_line_id'];
    if (json['prices'] != null) {
      prices = <PricesRU>[];
      json['prices'].forEach((v) {
        prices!.add(new PricesRU.fromJson(v));
      });
    }
    quantity = json['quantity'] != null
        ? new Quantity.fromJson(json['quantity'])
        : null;
    items = json['items'] != null ? new Items.fromJson(json['items']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_line_id'] = this.cartLineId;
    if (this.prices != null) {
      data['prices'] = this.prices!.map((v) => v.toJson()).toList();
    }
    if (this.quantity != null) {
      data['quantity'] = this.quantity!.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items!.toJson();
    }
    return data;
  }
}

class PricesRU {
  String? type;
  Price? price;
  Price? totalPrice;

  PricesRU({this.type, this.price, this.totalPrice});

  PricesRU.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
    totalPrice = json['total_price'] != null
        ? new Price.fromJson(json['total_price'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    if (this.totalPrice != null) {
      data['total_price'] = this.totalPrice!.toJson();
    }
    return data;
  }
}

class Price {
  int? centAmount;
  String? currency;
  int? fraction;

  Price({this.centAmount, this.currency, this.fraction});

  Price.fromJson(Map<String, dynamic> json) {
    centAmount = json['cent_amount'];
    currency = json['currency'];
    fraction = json['fraction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cent_amount'] = this.centAmount;
    data['currency'] = this.currency;
    data['fraction'] = this.fraction;
    return data;
  }
}

class Quantity {
  int? quantityNumber;

  Quantity({this.quantityNumber});

  Quantity.fromJson(Map<String, dynamic> json) {
    quantityNumber = json['quantity_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity_number'] = this.quantityNumber;
    return data;
  }
}

class Items {
  String? primaryImageUrl;
  String? offerId;
  String? displayName;
  String? esin;

  Items({this.primaryImageUrl, this.offerId, this.displayName, this.esin});

  Items.fromJson(Map<String, dynamic> json) {
    primaryImageUrl = json['primary_image_url'];
    offerId = json['offer_id'];
    displayName = json['display_name'];
    esin = json['esin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['primary_image_url'] = this.primaryImageUrl;
    data['offer_id'] = this.offerId;
    data['display_name'] = this.displayName;
    data['esin'] = this.esin;
    return data;
  }
}

class Totals {
  String? type;
  Price? price;

  Totals({this.type, this.price});

  Totals.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    return data;
  }
}