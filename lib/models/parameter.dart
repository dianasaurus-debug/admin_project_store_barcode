class Parameter {
  final int criteria_harga;
  final int criteria_supplier;
  final int criteria_rating;
  final int category_id;


  Parameter(this.criteria_harga,this.criteria_supplier, this.criteria_rating, this.category_id);

  Parameter.fromJson(Map<String, dynamic> json)
      : criteria_rating = json['criteria_rating'],
        criteria_supplier = json['criteria_supplier'],
        category_id = json['category_id'],
        criteria_harga = json['criteria_harga'];

  Map<String, dynamic> toJson() => {
    'criteria_rating' : criteria_rating,
    'criteria_harga' : criteria_harga,
    'category_id' : category_id,
    'criteria_supplier': criteria_supplier,
  };
}