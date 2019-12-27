// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Name Generator',
      home: RandomWords()
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Business Name Generator'),
        ),
        body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
      });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      // Within the `FirstRoute` widget
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondRoute(),
            settings: RouteSettings(
                arguments: pair.asPascalCase,
            ),
          ),
        );
      }
    );
  }

}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}


class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context).settings.arguments;
    final url = 'https://www.namecheap.com/domains/registration/results.aspx?domain=${title.toString()}';

    return Scaffold(
      appBar: AppBar(
        title: Text(title.toString()),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child:  WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted
          ),
        ),
      ),
    );
  }
}