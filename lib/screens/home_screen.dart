import 'package:flutter/material.dart';
import 'package:news_app/api/dio.dart';
import 'package:news_app/models/model.dart';

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
            SliverAppBar(
              centerTitle: true,
              title: const Text(
                'Newsify',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            /// Breaking News title
            const SliverToBoxAdapter(
              child: Text(
                'Breaking News',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            /// Breaking News slider
            SliverToBoxAdapter(
              child: SizedBox(
                height: 150,
                child: FutureBuilder<List<Article>>(
                  future: futureNews,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final articles = snapshot.data!;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        return Container(
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
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            /// Sort Chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 45,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: sortArticle.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          futureNews =
                              dioClient.getNews(sortArticle[index]);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: selectedIndex == index
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                        child: Text(sortArticle[index]),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// News For You title
            const SliverToBoxAdapter(
              child: Text(
                'News For You',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            /// News list
            SliverToBoxAdapter(
              child: FutureBuilder<List<Article>>(
                future: futureNews,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final articles = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 140,
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    articles[index].urlToImage ??
                                        'https://via.placeholder.com/150',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    articles[index].author ?? 'Unknown',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    articles[index].description ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
