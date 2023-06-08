class App {
  final int id;
  final String title;
  final String developer;
  final String description;
  final String downloadLink;
  final String logo;
  final String packageName;
  final bool isPublished;

  const App(
      {required this.id,
      required this.title,
      required this.developer,
      required this.description,
      required this.downloadLink,
      required this.logo,
      required this.packageName,
      required this.isPublished});

  @override
  toString() {
    return 'App{id: $id, title: $title, developer: $developer, description: $description, downloadLink: $downloadLink, logo: $logo, packageName: $packageName, isPublished: $isPublished}';
  }

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      id: json['id'],
      title: json['title'],
      developer: json['developer'],
      description: json['description'],
      downloadLink: json['downloadLink'],
      logo: json['logo'],
      packageName: json['packageName'],
      isPublished: json["isPublished"],
     );
  }
}
