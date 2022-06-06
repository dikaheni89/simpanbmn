// ignore_for_file: file_names

class Tugasmodel {
  final String? id;
  final String? merk;
  final String? tipe;
  final String? idinvent;
  final String? tanggal;

  Tugasmodel(
      {required this.id,
      required this.merk,
      required this.tipe,
      required this.idinvent,
      required this.tanggal});

  factory Tugasmodel.fromJson(Map<String, dynamic> json) {
    return Tugasmodel(
      id: json['id'],
      merk: json['merk'],
      tipe: json['tipe'],
      idinvent: json['idinvent'],
      tanggal: json['tanggal'],
    );
  }
}
