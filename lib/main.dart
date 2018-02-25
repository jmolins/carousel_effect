import 'package:flutter/material.dart';

const double _kViewportFraction = 0.7;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _backgroundPageController = new PageController();
  final PageController _pageController =
      new PageController(viewportFraction: _kViewportFraction);
  ValueNotifier<double> selectedIndex = new ValueNotifier<double>(0.0);

  bool _handlePageNotification(ScrollNotification notification,
      PageController leader, PageController follower) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      selectedIndex.value = leader.page;
      if (follower.page != leader.page) {
        follower.position
            .jumpToWithoutSettling(leader.position.pixels / _kViewportFraction); // ignore: deprecated_member_use
      }
      setState(() {});
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new PageView(
            controller: _backgroundPageController,
            children: _buildBackgroundPages(),
          ),
          new NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              return _handlePageNotification(
                  notification, _pageController, _backgroundPageController);
            },
            child: new PageView(
              controller: _pageController,
              children: _buildPages(),
            ),
          ),
        ],
      ),
    );
  }

  Iterable<Widget> _buildBackgroundPages() {
    final List<Widget> backgroundPages = <Widget>[];
    for (int index = 0; index < 10; index++) {
      backgroundPages.add(new Container(
        color: const Color(0xB07986CB),
        child: new Opacity(
          opacity: 0.3,
          child: new Image.asset(
            'assets/images/img${index + 1}.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ));
    }
    return backgroundPages;
  }

  Iterable<Widget> _buildPages() {
    final List<Widget> pages = <Widget>[];
    for (int index = 0; index < 10; index++) {
      var alignment = Alignment.center.add(new Alignment(
          (selectedIndex.value - index) * _kViewportFraction, 0.0));
      var resizeFactor =
          (1 - (((selectedIndex.value - index).abs() * 0.3).clamp(0.0, 1.0)));
      var imageAsset = 'assets/images/img${index + 1}.jpg';
      var image = new Image.asset(imageAsset, fit: BoxFit.cover);
      pages.add(new Container(
        alignment: alignment,
        child: new Container(
          decoration: new BoxDecoration(
            //color: Colors.red[400],
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: const Color(0xEE000000),
                offset: new Offset(0.0, 6.0),
                blurRadius: 10.0,
              ),
            ],
          ),
          width: 230.0 * resizeFactor,
          height: 410.0 * resizeFactor,
          child: new GestureDetector(
            onTap: () {
              Navigator
                  .of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new Hero(
                  tag: imageAsset,
                  child: image,
                );
              }));
            },
            child: new Hero(
              tag: imageAsset,
              child: image,
            ),
          ),
        ),
      ));
    }
    return pages;
  }
}
