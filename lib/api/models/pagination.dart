import 'package:swn_play/api/models/apps.dart';

class Pagination {
  final int contentSize;
  final int page;
  final int pageSize;
  final int lastPage;
  final List<AppSummary> content;

  const Pagination({
    required this.contentSize,
    required this.page,
    required this.pageSize,
    required this.lastPage,
    required this.content,
  });

  @override
  toString() {
    return "Pagination{contentSize: $contentSize, page: $page, pageSize: $pageSize, lastPage: $lastPage, content: $content}";
  }

  factory Pagination.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>;
    final content = contentList.map((item) => AppSummary.fromJson(item)).toList();

    return Pagination(
      contentSize: json['contentSize'],
      page: json['page'],
      pageSize: json['pageSize'],
      lastPage: json['lastPage'],
      content: content,
    );
  }
}
