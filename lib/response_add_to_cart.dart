class ResponseAddToCart {
  String? cartId;
  String? orderNumber;
  int? totalUnits;
  int? totalItems;
  List<Alerts>? alerts;

  ResponseAddToCart(
      {this.cartId,
        this.orderNumber,
        this.totalUnits,
        this.totalItems,
        this.alerts});

  ResponseAddToCart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    orderNumber = json['order_number'];
    totalUnits = json['total_units'];
    totalItems = json['total_items'];
    if (json['alerts'] != null) {
      alerts = <Alerts>[];
      json['alerts'].forEach((v) {
        alerts!.add(new Alerts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['order_number'] = this.orderNumber;
    data['total_units'] = this.totalUnits;
    data['total_items'] = this.totalItems;
    if (this.alerts != null) {
      data['alerts'] = this.alerts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Alerts {
  String? offerId;
  String? alertType;
  Quantity? quantity;

  Alerts({this.offerId, this.alertType, this.quantity});

  Alerts.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    alertType = json['alert_type'];
    quantity = json['quantity'] != null
        ? new Quantity.fromJson(json['quantity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_id'] = this.offerId;
    data['alert_type'] = this.alertType;
    if (this.quantity != null) {
      data['quantity'] = this.quantity!.toJson();
    }
    return data;
  }
}

class Quantity {
  int? quantityNumber;
  Null? quantityUom;

  Quantity({this.quantityNumber, this.quantityUom});

  Quantity.fromJson(Map<String, dynamic> json) {
    quantityNumber = json['quantity_number'];
    quantityUom = json['quantity_uom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity_number'] = this.quantityNumber;
    data['quantity_uom'] = this.quantityUom;
    return data;
  }
}