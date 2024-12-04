import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Géographie',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Vérification des informations d'identification
    if (username == 'admin' && password == 'admin') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nom d\'utilisateur ou mot de passe invalide'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _login(context),
                child: Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue au Quiz de Géographie'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Action pour l'icône de recherche
              print("Recherche appuyée");
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Action pour l'icône des paramètres
              print("Paramètres appuyés");
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu du Quiz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Accueil'),
              onTap: () {
                Navigator.of(context).pop(); // Ferme le drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.quiz),
              title: Text('Commencer le Quiz'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => QuizHomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Paramètres'),
              onTap: () {
                // Action pour ouvrir les paramètres
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => QuizHomePage()),
                );
              },
              child: Text('Démarrer le Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizHomePage extends StatefulWidget {
  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  final List<Map<String, Object>> _questions = [
    {
      'questionText': 'Quelle est la capitale de la France ?',
      'answers': [
        {'text': 'Paris', 'score': 1},
        {'text': 'Lyon', 'score': 0},
        {'text': 'Marseille', 'score': 0},
        {'text': 'Nice', 'score': 0},
      ]
    },
    {
      'questionText': 'Quel est le plus grand continent ?',
      'answers': [
        {'text': 'Asie', 'score': 1},
        {'text': 'Europe', 'score': 0},
        {'text': 'Afrique', 'score': 0},
        {'text': 'Amérique du Sud', 'score': 0},
      ]
    },
    {
      'questionText': 'Quel est le plus long fleuve du monde ?',
      'answers': [
        {'text': 'Amazone', 'score': 1},
        {'text': 'Nil', 'score': 0},
        {'text': 'Yangtsé', 'score': 0},
        {'text': 'Mississippi', 'score': 0},
      ]
    },
  ];

  int _questionIndex = 0;
  int _totalScore = 0;

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex++;
    });

    if (_questionIndex < _questions.length) {
      print('Il y a encore des questions!');
    } else {
      print('Quiz terminé!');
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Géographie'),
      ),
      backgroundColor: Colors.teal,
      body: _questionIndex < _questions.length
          ? Quiz(
              answerQuestion: _answerQuestion,
              questionIndex: _questionIndex,
              questions: _questions,
            )
          : Result(_totalScore, _resetQuiz),
    );
  }
}

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  final Function answerQuestion;

  Quiz({
    required this.questions,
    required this.answerQuestion,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Question(
          questions[questionIndex]['questionText'] as String,
        ),
        ...(questions[questionIndex]['answers'] as List<Map<String, Object>>)
            .map((answer) {
          return Answer(
            () => answerQuestion(answer['score'] as int),
            answer['text'] as String,
          );
        }).toList()
      ],
    );
  }
}

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Text(
        questionText,
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class Answer extends StatelessWidget {
  final VoidCallback selectHandler;
  final String answerText;

  Answer(this.selectHandler, this.answerText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: ElevatedButton(
        onPressed: selectHandler,
        child: Text(answerText),
      ),
    );
  }
}

class Result extends StatelessWidget {
  final int resultScore;
  final VoidCallback resetHandler;

  Result(this.resultScore, this.resetHandler);

  String get resultPhrase {
    String resultText;
    if (resultScore == 3) {
      resultText = 'Excellent!';
    } else if (resultScore == 2) {
      resultText = 'Bien joué!';
    } else if (resultScore == 1) {
      resultText = 'Pas mal!';
    } else {
      resultText = 'Réessayez!';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            resultPhrase,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            'Votre score est: $resultScore',
            style: TextStyle(fontSize: 24),
          ),
          TextButton(
            onPressed: resetHandler,
            child: Text('Recommencer le Quiz!'),
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 243, 40, 33),
            ),
          ),
        ],
      ),
    );
  }
}
