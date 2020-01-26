import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cast_web/cast.dart';
import 'package:js/js.dart';
import 'package:time_ago_provider/time_ago_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

import 'api.dart';


const String placeHolder =
    "https://static.tildacdn.com/tild6437-3735-4635-a539-346232383864/News.jpg";

void main() {
  runApp(
    MaterialApp(
      home: MyHomePage(manager: CastReceiverContext.getInstance()),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.manager}) : super(key: key);

  final CastReceiverContext manager;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String info = "This is a locally hosted cast app";
  Dio dio = Dio(BaseOptions(
    baseUrl: 'https://newsapi.org/v2',
  ));
  ScrollController controller = ScrollController();
  Timer timer;

  getArticles(String phrase, String apiKey) async {
    timer?.cancel();
    controller.jumpTo(0);
    final response = await dio.get(
      '/everything',
      queryParameters: {
        'qInTitle': phrase,
        'apiKey': apiKey
      },
    );
    setState(() {
      articles = NewsResponse.fromJson(response.data)
          .articles
          .where((art) => art.description
              .contains(RegExp('web|Web|app|App|mobile|Mobile|GitHub')))
          .toList()
            ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      timer = Timer.periodic(
          Duration(seconds: 1),
          (timer) => controller.animateTo(controller.offset + 10,
              duration: Duration(milliseconds: 800), curve: Curves.linear));
    });
  }

  List<Articles> articles = [];

  @override
  void initState() {
    widget.manager.addCustomMessageListener(
      'urn:x-cast:com.schwusch.chromecast-example',
      allowInterop((ev) {
        final String phrase = ev.toMap()['o']['data']['phrase'] as String;
        final String key = ev.toMap()['o']['data']['key'] as String;
        getArticles(phrase, key);
      }),
    );

    widget.manager.start(
      CastReceiverOptions()
        ..statusText = "Application is staharting"
        ..maxInactivity = 3600, // for development only
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: (articles?.isEmpty ?? true)
              ? CupertinoActivityIndicator()
              : GridView.builder(
                  controller: controller,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: articles.length,
                  itemBuilder: (BuildContext context, int i) {
                    final article = articles[i];
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (article.urlToImage != null)
                            Stack(
                              children: <Widget>[
                                Center(child: CupertinoActivityIndicator()),
                                Center(
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: article.urlToImage,
                                  ),
                                ),
                              ],
                            )
                          else
                            Container(
                              height: 10,
                            ),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            leading: Text(
                              TimeAgo.getTimeAgo(
                                  article.publishedAt.millisecondsSinceEpoch),
                            ),
                            title: Text(
                              article.title,
                              style: GoogleFonts.playfairDisplaySC(),
                            ),
                            subtitle: article.description != null
                                ? Text(
                                    article.description,
                                    style: GoogleFonts.playfairDisplay(),
                                  )
                                : null,
                            isThreeLine: article.description != null,
                            dense: false,
                          )
                        ],
                      ),
                    );
                  },
                ),
        ),
      );
}

extension on dynamic {
  Map<String, dynamic> toMap() =>
      jsonDecode(context['JSON'].callMethod('stringify', [this]))
          as Map<String, dynamic>;
}
