import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pokedex_new/Details.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final CarouselController carouselController = CarouselController();
  Map<String, dynamic> pokemonJson;
  bool pokemonsLoaded = false, isGridView = false;

  @override
  void initState() {
    parseJsonFromAssets('assets/pokemons.json');
    super.initState();
  }

  Future parseJsonFromAssets(String assetsPath) async {
    await rootBundle.loadString(assetsPath).then((jsonStr) => setState(() {
          pokemonJson = jsonDecode(jsonStr);
          pokemonsLoaded = true;
        }));
  }

  var pokemonColors = [
    {"Normal": "ffA8A878"},
    {"Fighting": "ffC03028"},
    {"Flying": "ffA890F0"},
    {"Poison": "ffA040A0"},
    {"Ground": "ffE0C068"},
    {"Rock": "ffB8A038"},
    {"Bug": "ffA8B820"},
    {"Ghost": "ff705898"},
    {"Fire": "ffF08030"},
    {"Water": "ff6890F0"},
    {"Grass": "ff78C850"},
    {"Electric": "ffF8D030"},
    {"Psychic": "ffF85888"},
    {"Ice": "ff98D8D8"},
    {"Dragon": "ff7038F8"},
    {"Dark": "ff705848"},
    {"Fairy": "ffEE99AC"}
  ];
  @override
  Widget build(BuildContext context) {
    String returnTypeColor(String pokemonType) {
      for (int i = 0; i < pokemonColors.length; i++) {
        if (pokemonType == pokemonColors[i].keys.toList()[0])
          return pokemonColors[i].values.toList()[0];
      }
      return 'ffA8A878';
    }

    nextPageRoute(int index) {
      return PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation,
                  widget) =>
              ScaleTransition(
                alignment: Alignment.center,
                scale: Tween<double>(begin: 0.7, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.linear)),
                child: widget,
              ),
          pageBuilder: (context, animation, secondaryAnimation) => Details(
              index,
              pokemonJson['pokemon'][index]['type'],
              isGridView,
              pokemonJson));
    }

    returnPokemonType(int _pkmnNo) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: 50,
          child: ListView.builder(
            itemCount: pokemonJson['pokemon'][_pkmnNo]['type'].length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 3.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(int.parse('0x' +
                        returnTypeColor(
                            pokemonJson['pokemon'][_pkmnNo]['type'][index])))),
                child: Center(
                    child: Text(
                  pokemonJson['pokemon'][_pkmnNo]['type'][index],
                  style: TextStyle(fontWeight: FontWeight.w800),
                  textScaleFactor: 1.2,
                )),
              ),
            ),
          ),
        ),
      );
    }

    secondChild() {
      return Container(
        height: MediaQuery.of(context).size.height - 90,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: GridView.builder(
          itemCount: pokemonJson['pokemon'].length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          itemBuilder: (context, index) => InkWell(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(
                          int.parse('0x' +
                              returnTypeColor(
                                  pokemonJson['pokemon'][index]['type'][0])),
                        ),
                        pokemonJson['pokemon'][index]['type'].length < 2
                            ? Colors.transparent
                            : Color(
                                int.parse('0x' +
                                    returnTypeColor(pokemonJson['pokemon']
                                        [index]['type'][1])),
                              ),
                      ])),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'ID: ' +
                              pokemonJson['pokemon'][index]['id'].toString(),
                          textScaleFactor: 0.9,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        pokemonJson['pokemon'][index]['name'],
                        textScaleFactor: 1.2,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontFamily: 'Futura'),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Hero(
                        transitionOnUserGestures: true,
                        tag: 'pokemonImageGrid${index + 1}',
                        child: Image.asset(
                          'assets/pokemon_images/${index + 1}.png',
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          scale: 2.6,
                        )),
                  ),
                ],
              ),
            ),
            onTap: () => Navigator.push(context, nextPageRoute(index)),
          ),
        ),
      );
    }

    firstChild() {
      return Container(
        height: MediaQuery.of(context).size.height - 90,
        width: MediaQuery.of(context).size.width,
        child: CarouselSlider.builder(
          itemCount: pokemonJson['pokemon'].length,
          options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            initialPage: 0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            carouselController: carouselController,
            height: MediaQuery.of(context).size.height - 100,
          ),
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(
                          int.parse('0x' +
                              returnTypeColor(
                                  pokemonJson['pokemon'][index]['type'][0])),
                        ),
                        pokemonJson['pokemon'][index]['type'].length < 2
                            ? Colors.transparent
                            : Color(
                                int.parse('0x' +
                                    returnTypeColor(pokemonJson['pokemon']
                                        [index]['type'][1])),
                              ),
                      ])),
              width: MediaQuery.of(context).size.width - 20,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                                width: 1))),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'ID: ' +
                                      pokemonJson['pokemon'][index]['id']
                                          .toString(),
                                  textScaleFactor: 0.9,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            pokemonJson['pokemon'][index]['name'],
                            textScaleFactor: 1.8,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Futura'),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Hero(
                        transitionOnUserGestures: true,
                        tag: 'pokemonImage${index + 1}',
                        child: Image.asset(
                          'assets/pokemon_images/${index + 1}.png',
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          scale: 1.4,
                        )),
                  ),
                  SizedBox(height: 20),
                  returnPokemonType(index),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.blue,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                              child: Text(
                            'Details',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Futura'),
                            textScaleFactor: 1.2,
                          )),
                        ),
                        onTap: () =>
                            Navigator.push(context, nextPageRoute(index)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    showAlertDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text("About App",textAlign: TextAlign.center),

        content: Text("Pokedex v1.0\n\nMade By\nMusaddiq Ahmed Khan",textAlign: TextAlign.center,),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.red, title: Text('Pokedex'), actions: [
        Icon(
          Icons.face,
          color:
              !isGridView ? Color(0xff3B5BA7) : Colors.black.withOpacity(0.6),
        ),
        Switch(
            activeThumbImage: AssetImage('assets/icons/pikachu.png'),
            activeColor: Colors.transparent,
            inactiveTrackColor: Colors.red[900],
            activeTrackColor: Colors.green,
            inactiveThumbImage: AssetImage('assets/icons/pikachu.png'),
            inactiveThumbColor: Colors.transparent,
            value: isGridView,
            onChanged: (_) {
              setState(() => isGridView = _);
            }),
        Icon(Icons.border_all,
            color:
                isGridView ? Color(0xff3B5BA7) : Colors.black.withOpacity(0.6)),
        SizedBox(width: 10)
      ]),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white.withOpacity(0.3),
          child: Column(
            children: <Widget>[
              pokemonsLoaded == false
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: AnimatedCrossFade(
                          duration: Duration(milliseconds: 500),
                          crossFadeState: isGridView
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: firstChild(),
                          secondChild: secondChild()),
                    ),
            ],
          )),
      drawer: Drawer(

        child: Container(
          color: Colors.red.withOpacity(0.9),
          child: ListView(
            
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white10,),
                  child: Image.asset('assets/icons/pokeball_icon_new.png')),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About App'),
                onTap: () {
                  Navigator.pop(context);
                  showAlertDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
