import 'package:flutter/material.dart';

void main() {
  runApp(CrosswordApp());
}

class CrosswordApp extends StatelessWidget {
  const CrosswordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crossword Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CrosswordHomePage(),
    );
  }
}

class CrosswordHomePage extends StatefulWidget {
  const CrosswordHomePage({super.key});

  @override
  _CrosswordHomePageState createState() => _CrosswordHomePageState();
}

class _CrosswordHomePageState extends State<CrosswordHomePage> {
  List<List<String>> crosswordGrid = List.generate(
    10,
    (_) => List.generate(10, (_) => ''),
  );
  List<List<bool>> selectedGrid = List.generate(
    10,
    (_) => List.generate(10, (_) => false),
  );
  List<List<bool>> correctGrid = List.generate(
    10,
    (_) => List.generate(10, (_) => false),
  );
  List<String> correctWords = ['HELLO', 'WORLD', 'FLUTTER', 'DART', 'PUZZLE'];

  @override
  void initState() {
    super.initState();
    _fillCrosswordGrid();
  }

  void _fillCrosswordGrid() {
    // Example letters to fill the grid
    List<String> letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

    // Fill the grid with random letters
    for (int i = 0; i < crosswordGrid.length; i++) {
      for (int j = 0; j < crosswordGrid[i].length; j++) {
        crosswordGrid[i][j] = (letters..shuffle()).first;
      }
    }
  }

  void _resizeGrid(int newSize) {
    if (newSize < 6) return; // Minimum size limit
    setState(() {
      crosswordGrid = List.generate(
        newSize,
        (_) => List.generate(newSize, (_) => ''),
      );
      selectedGrid = List.generate(
        newSize,
        (_) => List.generate(newSize, (_) => false),
      );
      correctGrid = List.generate(
        newSize,
        (_) => List.generate(newSize, (_) => false),
      );
      _fillCrosswordGrid();
    });
  }

  void _onSquareTap(int i, int j) {
    setState(() {
      selectedGrid[i][j] = !selectedGrid[i][j];
      _checkForCorrectWord();
    });
  }

  void _checkForCorrectWord() {
    // Reset correctGrid
    for (int i = 0; i < correctGrid.length; i++) {
      for (int j = 0; j < correctGrid[i].length; j++) {
        correctGrid[i][j] = false;
      }
    }

    for (String word in correctWords) {
      // Check horizontally
      for (int i = 0; i < crosswordGrid.length; i++) {
        for (int j = 0; j <= crosswordGrid[i].length - word.length; j++) {
          bool match = true;
          for (int k = 0; k < word.length; k++) {
            if (crosswordGrid[i][j + k] != word[k] || !selectedGrid[i][j + k]) {
              match = false;
              break;
            }
          }
          if (match) {
            for (int k = 0; k < word.length; k++) {
              correctGrid[i][j + k] = true;
            }
          }
        }
      }
      // Check vertically
      for (int i = 0; i <= crosswordGrid.length - word.length; i++) {
        for (int j = 0; j < crosswordGrid[i].length; j++) {
          bool match = true;
          for (int k = 0; k < word.length; k++) {
            if (crosswordGrid[i + k][j] != word[k] || !selectedGrid[i + k][j]) {
              match = false;
              break;
            }
          }
          if (match) {
            for (int k = 0; k < word.length; k++) {
              correctGrid[i + k][j] = true;
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crossword Puzzle'),
      ),
      body: Center(
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dy > 0) {
              _resizeGrid(crosswordGrid.length + 1);
            } else if (details.delta.dy < 0 && crosswordGrid.length > 6) {
              _resizeGrid(crosswordGrid.length - 1);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < crosswordGrid.length; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int j = 0; j < crosswordGrid[i].length; j++)
                      GestureDetector(
                        onTap: () => _onSquareTap(i, j),
                        child: Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                            color: correctGrid[i][j]
                                ? Colors.red
                                : selectedGrid[i][j]
                                    ? Colors.blue
                                    : Colors.transparent,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Text(crosswordGrid[i][j]),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
