// ignore_for_file: file_names, non_constant_identifier_names

class Historymodel {
  final String? id;
  final String? merk;
  final String? tipe;
  final String? trx_status;
  final String? tanggal;

  Historymodel(
      {required this.id,
      required this.merk,
      required this.tipe,
      required this.trx_status,
      required this.tanggal});

  factory Historymodel.fromJson(Map<String, dynamic> json) {
    return Historymodel(
      id: json['id'],
      merk: json['merk'],
      tipe: json['tipe'],
      trx_status: json['trx_status'],
      tanggal: json['tanggal'],
    );
  }
}
