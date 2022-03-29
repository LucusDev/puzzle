import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const PuzzleApp());
}

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Puzzle App",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Puzzle App"),
        ),
        body: const SafeArea(child: Center(child: Board())),
      ),
    );
  }
}

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final _num = <int>[];
  @override
  void initState() {
    super.initState();
    for (var i = 0; i <= 15; i++) {
      _num.add(i);
    }
    _num.shuffle();
  }

  bool areListsEqual(var list1, var list2) {
    // check if both are lists
    if (!(list1 is List && list2 is List)
        // check if both have same length
        ||
        list1.length != list2.length) {
      return false;
    }

    // check if elements are equal
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    return true;
  }

  void reset() {
    _num.shuffle();
  }

  void checkWin() {
    if (areListsEqual(
        _num, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0])) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              ElevatedButton(
                  onPressed: () {
                    reset();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Play Again?"))
            ],
            content: const Text("You Win!"),
          );
        },
      );
      setState(() {});
    }
  }

  void onClick(int index) {
    final isLegit = (index + 4 < _num.length && _num[index + 4] == 0) ||
        (index - 4 >= 0 && _num[index - 4] == 0) ||
        (index + 1 < _num.length && _num[index + 1] == 0) ||
        (index - 1 >= 0 && _num[index - 1] == 0);
    if (isLegit) {
      _num[_num.indexOf(0)] = _num[index];
      _num[index] = 0;
      setState(() {});
    }
    checkWin();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: _num.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
          itemBuilder: (context, index) {
            return _num.elementAt(index) == 0
                ? const SizedBox.shrink()
                : GridButton(
                    index: "${_num.elementAt(index)}",
                    onClick: () {
                      onClick(index);
                    },
                  );
          },
        ),
      ),
    );
  }
}

class GridButton extends StatelessWidget {
  final String index;
  final VoidCallback onClick;
  const GridButton({Key? key, required this.index, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(index),
      onPressed: onClick,
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
    );
  }
}
