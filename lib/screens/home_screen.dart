import 'package:flutter/material.dart';
import 'package:news_app/api/dio.dart';
import 'package:news_app/models/model.dart';
import 'package:news_app/widgets/home/home_news_list.dart';
import 'package:news_app/widgets/home/home_slider.dart';
import 'package:news_app/widgets/home/home_sort.dart';
import 'package:news_app/widgets/home/home_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DioClient dioClient = DioClient();

  int selectedIndex = 0;
  late Future<List<Article>> futureNews;

  final List<String> sortArticle = [
    "All",
    "Publishers first",
    "Recent first",
    "Sport",
    "Science",
  ];

  @override
  void initState() {
    super.initState();
    futureNews = dioClient.getNews('All');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              centerTitle: true,
              title: Text(
                'Newsify',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            /// Breaking News title
            const SliverToBoxAdapter(
              child: SectionTitle(title: 'Breaking News'),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            /// Breaking News slider
            SliverToBoxAdapter(
              child: BreakingNewsSlider(futureNews: futureNews),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            /// Sort Chips
            SliverToBoxAdapter(
              child: SortChips(
                items: sortArticle,
                selectedIndex: selectedIndex,
                onSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                    futureNews = dioClient.getNews(sortArticle[index]);
                  });
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// News For You title
            const SliverToBoxAdapter(
              child: SectionTitle(title: 'News For You'),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            /// News List (SliverList صح)
           FutureBuilder<List<Article>>(
  future: futureNews,
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return HomeNewsList(articles: snapshot.data!);
  },
),

          ],
        ),
      ),
    );
  }
}
