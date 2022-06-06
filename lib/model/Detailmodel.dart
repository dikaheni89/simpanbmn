// ignore_for_file: file_names, non_constant_identifier_names

class Detailmodel {
  final String? id;
  final String? merk;
  final String? kode;
  final String? tipe;
  final String? ruangan;
  final String? penanggungjawab;
  final String? kondisi;
  final String? trx_status;
  final String? full_name;
  final String? tanggal;

  Detailmodel(
      {required this.id,
      required this.merk,
      required this.kode,
      required this.tipe,
      required this.ruangan,
      required this.penanggungjawab,
      required this.kondisi,
      required this.full_name,
      required this.trx_status,
      required this.tanggal});

  factory Detailmodel.fromJson(Map<String, dynamic> json) {
    return Detailmodel(
      id: json['id'],
      merk: json['merk'],
      kode: json['kode'],
      tipe: json['tipe'],
      ruangan: json['ruangan'],
      penanggungjawab: json['penanggungjawab'],
      kondisi: json['kondisi'],
      full_name: json['full_name'],
      trx_status: json['trx_status'],
      tanggal: json['tanggal'],
    );
  }
}
