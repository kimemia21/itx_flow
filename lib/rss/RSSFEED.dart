import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:itx/global/appbar.dart';
import 'package:webfeed_revised/webfeed_revised.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class RSSFeedView extends StatefulWidget {

  const RSSFeedView({Key? key}) : super(key: key);

  @override
  _RSSFeedViewState createState() => _RSSFeedViewState();
}

class _RSSFeedViewState extends State<RSSFeedView> {
  List<RssItem> _feedItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchFeed();
  }

  Future<void> _fetchFeed() async {
    try {
      final response = await http.get(Uri.parse("https://worldteanews.com/rss.xml"));
      
      if (response.statusCode == 200) {
        final feed = RssFeed.parse(response.body);
        setState(() {
          _feedItems = feed.items ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to fetch RSS feed: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching RSS feed: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null) return;
    
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open link: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Scaffold(
        appBar: ITXAppBar(title: "rss Tea"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchFeed,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchFeed,
      child:  Scaffold(
        appBar: ITXAppBar(title: "rss Tea"),

        body: ListView.builder(
          itemCount: _feedItems.length,
          itemBuilder: (context, index) {
            final item = _feedItems[index];
            final pubDate = item.pubDate != null 
              ? DateFormat('MMM dd, yyyy').format(item.pubDate!)
              : 'No date';
        
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => _launchUrl(item.link),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? 'No title',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No description',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pubDate,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}