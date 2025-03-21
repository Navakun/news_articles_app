import 'package:flutter/material.dart';
import 'add_page.dart';
import 'models/article.dart';

void main() {
  runApp(const NewsArticlesApp());
}

class NewsArticlesApp extends StatelessWidget {
  const NewsArticlesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Articles App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

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
      articles.removeAt(index);
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
                return Dismissible(
                  key: Key(article.title),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _removeArticle(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${article.title} deleted')),
                    );
                  },
                  child: ListTile(
                    title: Text(article.title),
                    subtitle: Text(
                        'By ${article.author} - Category: ${article.category} - Date: ${article.date.toString().split(' ')[0]}'),
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