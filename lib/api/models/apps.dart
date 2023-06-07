
class App {
  final int id;
  final String title;
  final String downloadLink;
  final String logo;
  final String packageName;

  const App({
    required this.id,
    required this.title,
    required this.downloadLink,
    required this.logo,
    required this.packageName,
  });

  @override
  toString() {
    return 'App{id: $id, title: $title, downloadLink: $downloadLink, logo: $logo, packageName: $packageName}';
  }

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      id: json['id'],
      title: json['title'],
      downloadLink: json['downloadLink'],
      logo: json['logo'],
      packageName: json['packageName'],
    );
  }
}