class Models {
  final String id;
  final String created;
  final String root;

  Models({required this.id, required this.created, required this.root});

  factory Models.fromJson(Map<String, dynamic> json) {
    return Models(id: json['id'], created: json['created'].toString(), root: json['root']);
  }

  static List<Models> modelFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((data) {
      return Models.fromJson(data);
    }).toList();
  }
}
