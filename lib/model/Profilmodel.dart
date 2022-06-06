// ignore_for_file: file_names, non_constant_identifier_names

class Profilmodel {
  final String id;
  final String full_name;
  final String alamat;
  final String phone;
  final String email;
  final String photo;

  Profilmodel({
    required this.id,
    required this.full_name,
    required this.alamat,
    required this.phone,
    required this.email,
    required this.photo,
  });

  factory Profilmodel.fromJson(Map<String, dynamic> json) {
    return Profilmodel(
      id: json['id'],
      full_name: json['full_name'],
      alamat: json['alamat'],
      phone: json['phone'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}