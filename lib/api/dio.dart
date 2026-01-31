import 'package:dio/dio.dart';
import 'package:news_app/models/model.dart';

class DioClient {
  final Dio dio = Dio();

  String mapSort(String sort) {
    switch (sort) {
      case "Publishers first":
        return "popularity";
      case "Recent first":
        return "publishedAt";
      default:
        return "relevancy";
    }
  }

  Future<List<Article>> getNews(String sort) async {
    try {
      final response = await dio.get(
        "https://newsapi.org/v2/everything",
        queryParameters: {
          'q': 'tesla',
          'sortBy': mapSort(sort),
          'apiKey': '2bc4512466154ddc868256c5d9f3acb5',
        },
      );

      if (response.statusCode == 200) {
        final data = NewsResponse.fromJson(response.data);
        return data.articles;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
