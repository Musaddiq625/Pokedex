import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class Details extends StatefulWidget {
  final List pokemonTypes;
  final int pokemonNo;
  final bool isGridView;
  final Map<String, dynamic> pokemonJson;
  Details(this.pokemonNo, this.pokemonTypes, this.isGridView, this.pokemonJson);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool pokemonsLoaded = false,
      hasPrevEvolution = false,
      hasNextEvolution = false;
  int noOfPrevEvolutions = 0, noOfNextEvolutions = 0;
  int prevPokemon0 = 0;

  @override
  void initState() {
    super.initState();
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
    int total = widget.pokemonJson['pokemon'][widget.pokemonNo]['HP'] +
        widget.pokemonJson['pokemon'][widget.pokemonNo]['Atk'] +
        widget.pokemonJson['pokemon'][widget.pokemonNo]['Def'] +
        widget.pokemonJson['pokemon'][widget.pokemonNo]['SpA'] +
        widget.pokemonJson['pokemon'][widget.pokemonNo]['SpD'] +
        widget.pokemonJson['pokemon'][widget.pokemonNo]['Speed'];
    print(widget.pokemonNo);

    String returnTypeColor(String pokemonType) {
      for (int i = 0; i < pokemonColors.length; i++) {
        if (pokemonType == pokemonColors[i].keys.toList()[0])
          return pokemonColors[i].values.toList()[0];
      }
      return 'ffA8A878';
    }

    myContainer(String title, String detail) {
      return Container(
        height: MediaQuery.of(context).size.width / 3.5,
        width: MediaQuery.of(context).size.width / 2.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.blue),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              title,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              textScaleFactor: 1.5,
            ),
            Text(
              detail,
              style: TextStyle(fontWeight: FontWeight.w600),
              textScaleFactor: 1.1,
            )
          ],
        )),
      );
    }

    progressBar(String stat, int statValue) {
      Color _progressColor;
      if (statValue > 0 && statValue <= 50)
        _progressColor = Colors.yellow;
      else if (statValue > 50 && statValue <= 80)
        _progressColor = Colors.orange;
      else if (statValue > 80 && statValue <= 500)
        _progressColor = Colors.green;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Row(
          children: <Widget>[
            Expanded(flex: 1, child: Text(stat)),
            Expanded(
              flex: 4,
              child: FAProgressBar(
                currentValue: statValue,
                maxValue: total ~/ 3,
                displayText: '',
                animatedDuration: Duration(seconds: 2),
                borderRadius: 50,
                size: 20,
                backgroundColor: Colors.transparent,
                progressColor: _progressColor,
              ),
            )
          ],
        ),
      );
    }

    returnPokemonType() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: 50,
          child: ListView.builder(
            itemCount: widget.pokemonTypes.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 3.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(int.parse(
                        '0x' + returnTypeColor(widget.pokemonTypes[index])))),
                child: Center(
                    child: Text(
                  widget.pokemonTypes[index],
                  style: TextStyle(fontWeight: FontWeight.w800),
                  textScaleFactor: 1.2,
                )),
              ),
            ),
          ),
        ),
      );
    }

    returnPokemonWeaknessType(int pokemonNo) {
      return Expanded(
        flex: 1,
        child: Container(
          child: AbsorbPointer(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount:
                  widget.pokemonJson['pokemon'][pokemonNo]['weaknesses'].length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
              ),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width / 3.7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(int.parse('0x' +
                          returnTypeColor(widget.pokemonJson['pokemon']
                              [pokemonNo]['weaknesses'][index])))),
                  child: Center(
                      child: Text(
                    widget.pokemonJson['pokemon'][pokemonNo]['weaknesses']
                        [index],
                    style: TextStyle(fontWeight: FontWeight.w800),
                    textScaleFactor: 1.2,
                  )),
                ),
              ),
            ),
          ),
        ),
      );
    }

    returnPokemonName() {
      return Text(
        widget.pokemonJson['pokemon'][widget.pokemonNo]['name'],
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      );
    }

    returnPokemonImage() {
      return Hero(
          tag: widget.isGridView
              ? 'pokemonImageGrid${widget.pokemonNo}'
              : 'pokemonImage${widget.pokemonNo}',
          transitionOnUserGestures: true,
          child: Image.asset(
            'assets/pokemon_images/${widget.pokemonNo + 1}.png',
            scale: 1.5,
          ));
    }

    returnHeading(String title) {
      return Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
        textScaleFactor: 2,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white70,
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Card(
                  elevation: 3,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      returnPokemonName(),
                      SizedBox(height: 5),
                      returnPokemonImage(),
                      returnPokemonType(),
                    ],
                  )),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Card(
                  child: Container(
                      height: 620,
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  myContainer(
                                      'Weight',
                                      widget.pokemonJson['pokemon']
                                          [widget.pokemonNo]['weight']),
                                  myContainer(
                                      'Height',
                                      widget.pokemonJson['pokemon']
                                          [widget.pokemonNo]['height']),
                                ],
                              ),
                            ),
                          ),
                          returnHeading('STATS'),
                          SizedBox(height: 10),
                          progressBar(
                              "HP",
                              widget.pokemonJson['pokemon'][widget.pokemonNo]
                                  ['HP']),
                          progressBar(
                            "Atk",
                            widget.pokemonJson['pokemon'][widget.pokemonNo]
                                ['Atk'],
                          ),
                          progressBar(
                            "Sp.Atk",
                            widget.pokemonJson['pokemon'][widget.pokemonNo]
                                ['SpA'],
                          ),
                          progressBar(
                            "Def",
                            widget.pokemonJson['pokemon'][widget.pokemonNo]
                                ['Def'],
                          ),
                          progressBar(
                            "Sp.Def",
                            widget.pokemonJson['pokemon'][widget.pokemonNo]
                                ['SpD'],
                          ),
                          progressBar(
                            "Speed",
                            widget.pokemonJson['pokemon'][widget.pokemonNo]
                                ['Speed'],
                          ),
                          SizedBox(height: 15),
                          returnHeading('WEAKNESS'),
                          returnPokemonWeaknessType(widget.pokemonNo),
                          SizedBox(height: 10),
                        ],
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
