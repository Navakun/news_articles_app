import 'package:flutter/material.dart';
import 'add_page.dart';
import 'models/article.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Article> articles = [];

  void _addArticle(Article article) {
    setState(() {
      articles.add(article);
    });
  }

  void _removeArticle(int index) {
    setState(() {
      final removedArticle = articles[index];
      articles.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${removedArticle.title} deleted')),
      );
    });
  }

  void _navigateToAddPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPage(onArticleAdded: _addArticle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('News Articles'),
      ),
      body: articles.isEmpty
          ? const Center(child: Text('Welcome to News Articles App!'))
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                debugPrint("📌 ตรวจสอบบทความ: ${article.title}, content: ${article.content}");
                return Dismissible(
                  key: Key(article.id), // ใช้ id แทน title เพื่อป้องกัน Key ซ้ำ
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _removeArticle(index);
                  },
                  child: ListTile(
                    title: Text(article.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "By ${article.author} - ${article.category} - ${article.date.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          article.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    trailing: Text('Views: ${article.views}'),
                    onTap: () {
                      setState(() {
                        article.incrementViews();
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPage,
        tooltip: 'Add Article',
        child: const Icon(Icons.add),
      ),
    );
  }
}