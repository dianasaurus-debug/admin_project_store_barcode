class Product {
  late String nama_barang;
  late String harga_jual;
  late String qr_code;
  late String deskripsi;
  late String gambar;
  late String kode_barang;
  late String stok;
  late int category_id;
  late String nama_kategori;
  late int rating;
  late int id;


  Product({this.id = 0, this.nama_barang = '',this.harga_jual = '',this.qr_code = '', this.kode_barang = ''
    ,this.deskripsi = '', this.gambar = '',this.stok = '',this.category_id = 0,this.nama_kategori = '', this.rating = 0});

  Product.fromJson(Map<String, dynamic> json)
      : nama_barang = json['nama_barang'],
        id = json['id'],
        harga_jual = json['harga_jual'],
        deskripsi = json['deskripsi'],
        kode_barang = json['kode_barang'],
        gambar = json['gambar'],
        stok = json['stok'],
        category_id = json['category_id'],
        nama_kategori = json['category'] == null ? null : json['category']['nama_kategori'],
        rating = json['criterias'][1]['nilai'],
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