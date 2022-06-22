class Product {
  late String nama_barang;
  late String harga_jual;
  late String qr_code;
  late String deskripsi;
  late String gambar;
  late String kode_barang;
  late String stok;
  late int category_id;
  late int main_category_id;
  late String nama_kategori;
  late bool is_in_cart;
  late int rating;
  late int id;
  late int total;
  late int jumlah;


  Product({this.id = 0, this.is_in_cart = false, this.nama_barang = '',this.harga_jual = '',this.qr_code = '', this.kode_barang = ''
    ,this.deskripsi = '', this.gambar = '',this.stok = '',this.category_id = 0,this.nama_kategori = '', this.rating = 0, this.total=0, this.jumlah=0});

  Product.fromJson(Map<String, dynamic> json)
      : nama_barang = json['nama_barang'],
        id = json['id'],
        harga_jual = json['harga_jual'],
        deskripsi = json['deskripsi'],
        kode_barang = json['kode_barang'],
        gambar = json['gambar'],
        stok = json['stok'],
        category_id = json['category_id'],
        main_category_id = json['category'] == null ? null : json['category']['main_category']['id'],
        is_in_cart = json['cart'] != null ? true : false,
        total = json['pivot'] != null ? json['pivot']['total'] : null,
        jumlah = json['pivot'] != null ? json['pivot']['jumlah'] : null,
        nama_kategori = json['category'] == null ? null : json['category']['nama_kategori'],
        rating = json['criterias'].length>1 ? json['criterias'][1]['nilai'] : 0,
        qr_code = json['qr_code'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'nama_barang': nama_barang,
    'harga_jual': harga_jual,
    'deskripsi': deskripsi,
    'gambar': gambar,
    'stok': stok,
    'kode_barang': kode_barang,
    'category_id': category_id,
    'qr_code': qr_code,
  };
}