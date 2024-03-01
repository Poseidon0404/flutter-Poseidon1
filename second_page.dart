import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/second': (context) => SecondPage(), // Changed from MinesweeperPage to SecondPage
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/second');
          },
          child: Text('Go to Second Page'),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late List<List<bool>> _revealed;
  late List<List<bool>> _mines;
  final int rows = 8;
  final int cols = 8;
  final int numMines = 10;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    _revealed = List.generate(rows, (i) => List.filled(cols, false));
    _mines = List.generate(rows, (i) => List.filled(cols, false));

    // Place mines randomly
    final rng = Random();
    int minesPlaced = 0;
    while (minesPlaced < numMines) {
      int row = rng.nextInt(rows);
      int col = rng.nextInt(cols);
      if (!_mines[row][col]) {
        _mines[row][col] = true;
        minesPlaced++;
      }
    }
  }

  void _revealTile(int row, int col) {
    setState(() {
      _revealed[row][col] = true;
      if (_mines[row][col]) {
        // Game over
        _showGameOverDialog();
      } else {
        //
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('NA PISLIT NIMO ANG BOMBA YAWAA KA TANGA'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeBoard();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTile(int row, int col) {
    Color color;
    IconData? icon; // Make the icon nullable

    if (_revealed[row][col]) {
      color = Colors.black;
      if (_mines[row][col]) {
        icon = Icons.dangerous;
      } else {
        //
      }
    } else {
      color = Colors.green;
    }

    return GestureDetector(
      onTap: () => _revealTile(row, col),
      child: Container(
        color: color,
        child: icon != null ? Icon(icon) : null,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MineSweeper'),
        backgroundColor: Colors.blueGrey,
      ),
      body: GridView.builder(
        itemCount: rows * cols,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
        ),
        itemBuilder: (BuildContext context, int index) {
          int row = index ~/ cols;
          int col = index % cols;
          return _buildTile(row, col);
        },
      ),
    );
  }
}
