class App {
  final int id;
  final String title;
  final String developer;
  final String description;
  final String descriptionFull;
  final String downloadLink;
  final String logo;
  final String packageName;
  final String latestVersion;
  final int viewedQuantity;
  final int downloadedQuantity;
  final String createdAt;
  final String updatedAt;
  final bool isPublished;

  const App(
      {required this.id,
      required this.title,
      required this.developer,
      required this.description,
      required this.descriptionFull,
      required this.downloadLink,
      required this.logo,
      required this.packageName,
      required this.latestVersion,
      required this.viewedQuantity,
      required this.downloadedQuantity,
      required this.createdAt,
      required this.updatedAt,
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
      logo: json['logo'],
      downloadLink: json['downloadLink'],
      downloadedQuantity: json['downloadedQuantity'],
      viewedQuantity: json['viewedQuantity'],
      description: json['description'],
      descriptionFull: json['descriptionFull'],
      packageName: json['packageName'],
      latestVersion: json['latestVersion'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isPublished: json["isPublished"],
    );
  }
}
