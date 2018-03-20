import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

// => is shorthand for one-line functions
void main() => runApp(new MyApp());

/*
    Flutter / Dart docs:

    - https://docs.flutter.io/flutter/material/material-library.html
    - https://pub.dartlang.org/flutter/
*/

// In Flutter, almost everything is a widget, including alignment, padding and layout
// A StatelessWidget is immutable, meaning that their properties can't change
class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        // https://docs.flutter.io/flutter/material/MaterialApp-class.html
        return new MaterialApp(
            /*
            // The 'Scaffold' widget from the Material library provides a default app bar, title, and a body.
            // A widgets main job is to provide a  'build()` method.
            home: new Scaffold(
                appBar: new AppBar(
                    title: new Text('Welcomeeeee to Flutterbug'),
                ),
                body: new Center(
                    // child: new Text("Hello, World!"),
                    child: new RandomWords(),
                ),
            ),
            */
            title: 'Welcome to Flutter - Startup Name Generator',

            // https://docs.flutter.io/flutter/material/ThemeData-class.html
            // https://docs.flutter.io/flutter/material/Colors-class.html
            /*theme: new ThemeData(
                primaryColor: Colors.green,
                dividerColor: Colors.orange,
            ),*/
            // theme: new ThemeData.dark(),
            theme: new ThemeData.light(),
            home: new RandomWords(),
        );
    }
}

// https://docs.flutter.io/flutter/widgets/StatefulWidget-class.html
class RandomWords extends StatefulWidget {
    @override
    createState() => new RandomWordState();
}

// https://docs.flutter.io/flutter/widgets/State-class.html
/*
    State is information that
        (1) can be read synchronously when the widget is built
        (2) might change during the lifetime of the widget
    It is the responsibility of the widget implementer to ensure that the State is promptly notified when such state changes, using State.setState.
*/
class RandomWordState extends State<RandomWords> {
    final _suggestions = <WordPair>[];  // Docs: https://www.dartdocs.org/documentation/english_words/3.1.0/english_words/WordPair-class.html
    final _saved = new Set<WordPair>();

    // https://docs.flutter.io/flutter/painting/TextStyle-class.html
    final _biggerFont = const TextStyle(fontSize: 18.0);

    void _pushSaved() {
        // https://docs.flutter.io/flutter/widgets/Navigator-class.html
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (context) {
                    final tiles = _saved.map(
                        (pair) {
                            // https://docs.flutter.io/flutter/material/ListTile-class.html
                            return new ListTile(title: new Text(pair.asPascalCase, style: _biggerFont));
                        },
                    );

                    final divided = ListTile.divideTiles(context: context, tiles: tiles).toList();

                    return new Scaffold(
                        appBar: new AppBar(title: new Text("Saved Suggestions")),
                        body: new ListView(children: divided),
                    );
                },
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        // final wordPair = new WordPair.random();
        // return new Text(wordPair.asPascalCase);

        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Startup Name Generator"),
                actions: <Widget>[
                    // https://docs.flutter.io/flutter/widgets/Icon-class.html
                    // https://docs.flutter.io/flutter/material/IconButton-class.html
                    // https://docs.flutter.io/flutter/material/Icons-class.html
                    new IconButton(color: Colors.red, icon: new Icon(Icons.access_alarm), onPressed: _pushSaved),
                ],
            ),
            body: _buildSuggestions(),
        );
    }

    Widget _buildSuggestions() {
        return new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
                if (i.isOdd) return new Divider();

                final index = i ~/ 2;
                if (index >= _suggestions.length) {
                    _suggestions.addAll(generateWordPairs().take(10));
                }

                return _buildRow(_suggestions[index]);
            },
        );
    }

    Widget _buildRow(WordPair pair) {
        final alreadySaved = _saved.contains(pair);
        return new ListTile(
            title: new Text(pair.asPascalCase, style: _biggerFont),
            trailing: new Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
            ),
            onTap: (){
                setState(() {
                    if (alreadySaved) {
                        _saved.remove(pair);
                    } else {
                        _saved.add(pair);
                    }
                });
            },
        );
    }
}
