class App {
  String createdAt;
  String description;
  String descriptionFull;
  String developer;
  String downloadLink;
  int id;
  AppInfo info;
  bool isPublished;
  String latestVersion;
  String logo;
  String packageName;
  List<String> screenshots;
  String title;
  String type;
  String updatedAt;
  int downloadedQuantity;
  int viewedQuantity;

  App({
    required this.createdAt,
    required this.description,
    required this.descriptionFull,
    required this.developer,
    required this.downloadLink,
    required this.id,
    required this.info,
    required this.isPublished,
    required this.latestVersion,
    required this.logo,
    required this.packageName,
    required this.screenshots,
    required this.title,
    required this.type,
    required this.updatedAt,
    required this.downloadedQuantity,
    required this.viewedQuantity,
  });

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      createdAt: json['createdAt'],
      description: json['description'],
      descriptionFull: json['descriptionFull'],
      developer: json['developer'],
      downloadLink: json['downloadLink'],
      id: json['id'],
      info: AppInfo.fromJson(json['info']),
      isPublished: json['isPublished'],
      latestVersion: json['latestVersion'],
      logo: json['logo'],
      packageName: json['packageName'],
      screenshots: List<String>.from(json['screenshots']),
      title: json['title'],
      type: json['type'],
      updatedAt: json['updatedAt'],
      downloadedQuantity: json['downloadedQuantity'],
      viewedQuantity: json['viewedQuantity'],
    );
  }
}

class AppInfo {
  String ageLimit;
  int appId;
  String customCreatedAt;
  String customUpdatedAt;
  int id;
  String typeFile;

  AppInfo({
    required this.ageLimit,
    required this.appId,
    required this.customCreatedAt,
    required this.customUpdatedAt,
    required this.id,
    required this.typeFile,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      ageLimit: json['ageLimit'],
      appId: json['appId'],
      customCreatedAt: json['customCreatedAt'],
      customUpdatedAt: json['customUpdatedAt'],
      id: json['id'],
      typeFile: json['typeFile'],
    );
  }
}

class AppSummary {
  final int id;
  final String title;
  final String developer;
  final String logo;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppSummary(
      {required this.id,
      required this.title,
      required this.developer,
      required this.logo,
      required this.createdAt,
      required this.updatedAt});

  factory AppSummary.fromJson(Map<String, dynamic> json) {
    return AppSummary(
      id: json['id'],
      title: json['title'],
      developer: json['developer'],
      logo: json['logo'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Package {
  String packageName;
  String version;

  Package({required this.packageName, required this.version});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      packageName: json['packageName'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'version': version,
    };
  }
}
