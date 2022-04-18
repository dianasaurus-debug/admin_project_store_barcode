class Rekomendasi {
  final String label;
  final int id;


  Rekomendasi(this.label,this.id);

  Rekomendasi.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'label': label,
  };
}