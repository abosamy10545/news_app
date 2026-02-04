import 'package:flutter/material.dart';
import 'package:news_app/models/model.dart';
import 'package:news_app/screens/news_detail_screen.dart';


  class BreakingNewsSlider extends StatelessWidget {
  final Future<List<Article>> futureNews;
  const BreakingNewsSlider({super.key, required this.futureNews});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: FutureBuilder<List<Article>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final articles = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          NewsDetailScreen(article: articles[index]),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 340,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                        articles[index].urlToImage ??
                            'https://via.placeholder.com/400',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
