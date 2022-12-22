
import 'dart:convert';

//@JsonSerializable()
class ResponseModel {
  List<Products>? products;
  List<SortOptions>? sortOptions;
  List<Facets>? facets;
  Metadata? metadata;
  int? totalCount;

  ResponseModel(
      {this.products,
        this.sortOptions,
        this.facets,
        this.metadata,
        this.totalCount});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    if (json['sort_options'] != null) {
      sortOptions = <SortOptions>[];
      json['sort_options'].forEach((v) {
        sortOptions!.add(new SortOptions.fromJson(v));
      });
    }
    if (json['facets'] != null) {
      facets = <Facets>[];
      json['facets'].forEach((v) {
        facets!.add(new Facets.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.sortOptions != null) {
      data['sort_options'] = this.sortOptions!.map((v) => v.toJson()).toList();
    }
    if (this.facets != null) {
      data['facets'] = this.facets!.map((v) => v.toJson()).toList();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['total_count'] = this.totalCount;
    return data;
  }
}

class Products {
  String? offerId;
  String? displayName;
  String? esin;
  String? brandId;
  Media? media;
  int? totalVariants;
  Discounts? discounts;
  List<PricesRupee>? prices;

  EarliestDeliveryDate? earliestDeliveryDate;
  String? courierType;
  String? serviceCategory;

  Products(
      {this.offerId,
        this.displayName,
        this.esin,
        this.brandId,
        this.media,
        this.totalVariants,
        this.discounts,
        this.prices,

        this.earliestDeliveryDate,
        this.courierType,
        this.serviceCategory});

  Products.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    displayName = json['display_name'];
    esin = json['esin'];
    brandId = json['brand_id'];
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    totalVariants = json['total_variants'];
    discounts = json['discounts'] != null
        ? new Discounts.fromJson(json['discounts'])
        : null;
    if (json['prices'] != null) {
      prices = <PricesRupee>[];
      json['prices'].forEach((v) {
        prices!.add(new PricesRupee.fromJson(v));
      });
    }
    earliestDeliveryDate = json['earliest_delivery_date'] != null
        ? new EarliestDeliveryDate.fromJson(json['earliest_delivery_date'])
        : null;
    courierType = json['courier_type'];
    serviceCategory = json['service_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_id'] = this.offerId;
    data['display_name'] = this.displayName;
    data['esin'] = this.esin;
    data['brand_id'] = this.brandId;
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    data['total_variants'] = this.totalVariants;
    if (this.discounts != null) {
      data['discounts'] = this.discounts!.toJson();
    }
    if (this.prices != null) {
      data['prices'] = this.prices!.map((v) => v.toJson()).toList();
    }
    if (this.earliestDeliveryDate != null) {
      data['earliest_delivery_date'] = this.earliestDeliveryDate!.toJson();
    }
    data['courier_type'] = this.courierType;
    data['service_category'] = this.serviceCategory;
    return data;
  }
}

class Media {
  String? primaryImageUrl;
  String? label;

  Media({this.primaryImageUrl, this.label});

  Media.fromJson(Map<String, dynamic> json) {
    primaryImageUrl = json['primary_image_url'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['primary_image_url'] = this.primaryImageUrl;
    data['label'] = this.label;
    return data;
  }
}

class Discounts {
  int? amountOff;
  int? percentOff;

  Discounts({this.amountOff, this.percentOff});

  Discounts.fromJson(Map<String, dynamic> json) {
    amountOff = json['amount_off'];
    percentOff = json['percent_off'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount_off'] = this.amountOff;
    data['percent_off'] = this.percentOff;
    return data;
  }
}

class PricesRupee {
  String? type;
  Price? price;
  UnitOfMeasurementPrice? unitOfMeasurementPrice;

  PricesRupee({this.type, this.price, this.unitOfMeasurementPrice});

  PricesRupee.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
    unitOfMeasurementPrice = json['unit_of_measurement_price'] != null
        ? new UnitOfMeasurementPrice.fromJson(json['unit_of_measurement_price'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    if (this.unitOfMeasurementPrice != null) {
      data['unit_of_measurement_price'] = this.unitOfMeasurementPrice!.toJson();
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

class UnitOfMeasurementPrice {
  int? centAmount;
  String? unit;
  int? fraction;
  String? currency;

  UnitOfMeasurementPrice(
      {this.centAmount, this.unit, this.fraction, this.currency});

  UnitOfMeasurementPrice.fromJson(Map<String, dynamic> json) {
    centAmount = json['cent_amount'];
    unit = json['unit'];
    fraction = json['fraction'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cent_amount'] = this.centAmount;
    data['unit'] = this.unit;
    data['fraction'] = this.fraction;
    data['currency'] = this.currency;
    return data;
  }
}

class EarliestDeliveryDate {
  String? day;
  String? date;
  String? month;
  String? year;
  String? label;

  EarliestDeliveryDate(
      {this.day, this.date, this.month, this.year, this.label});

  EarliestDeliveryDate.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    date = json['date'];
    month = json['month'];
    year = json['year'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['date'] = this.date;
    data['month'] = this.month;
    data['year'] = this.year;
    data['label'] = this.label;
    return data;
  }
}

class SortOptions {
  String? label;
  String? attributeCode;
  String? value;
  bool? isSelected;

  SortOptions({this.label, this.attributeCode, this.value, this.isSelected});

  SortOptions.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    attributeCode = json['attribute_code'];
    value = json['value'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['attribute_code'] = this.attributeCode;
    data['value'] = this.value;
    data['is_selected'] = this.isSelected;
    return data;
  }
}

class Facets {
  String? attributeCode;
  List<Options>? options;
  String? label;
  int? count;

  Facets({this.attributeCode, this.options, this.label, this.count});

  Facets.fromJson(Map<String, dynamic> json) {
    attributeCode = json['attribute_code'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    label = json['label'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attribute_code'] = this.attributeCode;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data['label'] = this.label;
    data['count'] = this.count;
    return data;
  }
}

class Options {
  String? label;
  String? value;
  int? count;
  bool? isSelected;

  Options({this.label, this.value, this.count, this.isSelected});

  Options.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    count = json['count'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    data['count'] = this.count;
    data['is_selected'] = this.isSelected;
    return data;
  }
}

class Metadata {
  PageInfo? pageInfo;

  Metadata({this.pageInfo});

  Metadata.fromJson(Map<String, dynamic> json) {
    pageInfo = json['page_info'] != null
        ? new PageInfo.fromJson(json['page_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pageInfo != null) {
      data['page_info'] = this.pageInfo!.toJson();
    }
    return data;
  }
}

class PageInfo {
  int? pageSize;
  int? currentPage;
  int? totalPages;

  PageInfo({this.pageSize, this.currentPage, this.totalPages});

  PageInfo.fromJson(Map<String, dynamic> json) {
    pageSize = json['page_size'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_size'] = this.pageSize;
    data['current_page'] = this.currentPage;
    data['total_pages'] = this.totalPages;
    return data;
  }
}
