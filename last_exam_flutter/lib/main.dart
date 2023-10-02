import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2: // Add a case for the new HomePage1
        page = HomePage1();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('HomePage1'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

// class HomePage1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         children: [
//           Expanded(
//             flex: 1, // Adjust the flex value as needed
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(128, 0, 128, 1.0),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(10), // Adjust the radius as needed
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment:
//                     CrossAxisAlignment.start, // Align text to the left
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0), // Add padding for text
//                     child: Text(
//                       "Hi Guy!",
//                       style: TextStyle(
//                         fontSize: 24,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0), // Add padding for text
//                     child: Text(
//                       "Where are you going next?",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Container(
//                         margin: EdgeInsets.only(
//                             left: 8, right: 8, bottom: 8), // Add margin
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 10), // Add padding
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(
//                                 10), // Adjust the radius as needed
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.search,
//                               size: 24,
//                               color: Color.fromRGBO(128, 0, 128,
//                                   1.0), // Match the background color
//                             ),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: TextField(
//                                 decoration: InputDecoration(
//                                   hintText: "Search...",
//                                   hintStyle: TextStyle(
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1, // Adjust the flex value as needed
//             child: Container(
//               color: Colors
//                   .white, // Set the background color of the Expanded widget
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding:
//                           EdgeInsets.all(16.0), // Add padding between boxes
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 100,
//                             height: 80, // Increase the height
//                             decoration: BoxDecoration(
//                               color: Colors.blue, // Customize the color
//                               borderRadius: BorderRadius.circular(
//                                   10), // Add border radius
//                             ),
//                             child: Icon(
//                               Icons.airplanemode_active,
//                               size: 20, // Increase the size
//                               color: Colors.white,
//                             ),
//                           ),
//                           SizedBox(height: 16), // Increase the spacing
//                           Text('Flights',
//                               style: TextStyle(
//                                   fontSize: 18)), // Increase the font size
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding:
//                           EdgeInsets.all(16.0), // Add padding between boxes
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 100,
//                             height: 80, // Increase the height
//                             decoration: BoxDecoration(
//                               color: Colors.green, // Customize the color
//                               borderRadius: BorderRadius.circular(
//                                   10), // Add border radius
//                             ),
//                             child: Icon(
//                               Icons.hotel,
//                               size: 20, // Increase the size
//                               color: Colors.white,
//                             ),
//                           ),
//                           SizedBox(height: 16), // Increase the spacing
//                           Text('Hotels',
//                               style: TextStyle(
//                                   fontSize: 18)), // Increase the font size
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding:
//                           EdgeInsets.all(16.0), // Add padding between boxes
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 100,
//                             height: 80, // Increase the height
//                             decoration: BoxDecoration(
//                               color: Colors.orange, // Customize the color
//                               borderRadius: BorderRadius.circular(
//                                   10), // Add border radius
//                             ),
//                             child: Icon(
//                               Icons.people,
//                               size: 20, // Increase the size
//                               color: Colors.white,
//                             ),
//                           ),
//                           SizedBox(height: 16), // Increase the spacing
//                           Text('All',
//                               style: TextStyle(
//                                   fontSize: 18)), // Increase the font size
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2, // Adjust the flex value as needed
//             child: Container(
//               color: Colors
//                   .white, // Set the background color of the Expanded widget
//               child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, // Number of columns in the grid
//                 ),
//                 itemBuilder: (BuildContext context, int index) {
//                   // You can replace the placeholder URL with the actual image URL
//                   final imageUrl =
//                       "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80";

//                   return Stack(
//                     children: [
//                       Container(
//                         width: 150, // Increase the width
//                         height: 150, // Increase the height
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: NetworkImage(imageUrl),
//                             fit: BoxFit.cover,
//                           ),
//                           borderRadius:
//                               BorderRadius.circular(20), // Add border radius
//                         ),
//                       ),
//                       Positioned(
//                         top: 16, // Move text up from the bottom
//                         left: 0,
//                         child: Container(
//                           width: 150, // Match the image width
//                           padding: EdgeInsets.all(8),
//                           color: Colors.transparent,
//                           child: Text(
//                             'Title', // Replace with your text
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18, // Increase the font size
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 8, // Move the star icon and number up
//                         left: 0,
//                         child: Container(
//                           padding: EdgeInsets.all(8),
//                           color: Colors.white.withOpacity(0.4),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.star,
//                                 color: Colors.yellow,
//                                 size: 24, // Increase the icon size
//                               ),
//                               SizedBox(width: 8), // Add extra space
//                               Text(
//                                 '5', // Replace with your rating number
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18, // Increase the font size
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//                 itemCount:
//                     2, // Number of items in the grid (2 rows, 1 in each row)
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class HomePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(128, 0, 128, 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Hi Guy!",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Where are you going next?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              size: 24,
                              color: Color.fromRGBO(128, 0, 128, 1.0),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.airplanemode_active,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Flights',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.hotel,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Hotels',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.people,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'All',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: FutureBuilder(
              future:
                  DefaultAssetBundle.of(context).loadString('assets/data.json'),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  final List<Map<String, dynamic>> data =
                      (json.decode(snapshot.data!) as List)
                          .cast<Map<String, dynamic>>();
                  return Container(
                    color: Colors.white,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, dynamic> destination = data[index];
                        final String imageUrl = destination['image'];
                        final String title = destination['name'];
                        final double rating = destination['rate'];

                        return Stack(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              left: 0,
                              child: Container(
                                width: 150,
                                padding: EdgeInsets.all(8),
                                color: Colors.transparent,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 0,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                color: Colors.white.withOpacity(0.4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: data.length,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error loading data');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
