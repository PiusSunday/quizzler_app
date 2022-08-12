import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(const QuizzlerApp());
}

class QuizzlerApp extends StatelessWidget {
  const QuizzlerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quizzler",
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizzlerPage(),
          ),
        ),
      ),
    );
  }
}

class QuizzlerPage extends StatefulWidget {
  const QuizzlerPage({Key? key}) : super(key: key);

  @override
  State<QuizzlerPage> createState() => _QuizzlerPageState();
}

class _QuizzlerPageState extends State<QuizzlerPage> {
  QuizBrain quizbrain = QuizBrain();

  // FUNCTION TO CHECK USER SELECTED ANSWER
  void checkAnswer(bool userSelectedAnswer) {
    bool correctAnswer = quizbrain.getAnswer();

    setState(() {
      if (quizbrain.isFinished() == true) {
        // ALERT DIALOG WHEN QUESTIONS ARE FINISHED
        Alert(
          context: context,
          title: "Finished!",
          desc: "You've reached the end of this quiz.",
          buttons: [
            // BUTTON TO RESTART THE QUIZ
            DialogButton(
              onPressed: () => Navigator.pop(context),
              width: 120,
              color: const Color.fromRGBO(0, 179, 134, 1.0),
              radius: BorderRadius.circular(0.0),
              child: const Text(
                "Restart",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ).show();

        // RESET THE QUIZ TO START AGAIN
        quizbrain.resetQuiz();

        // RESET SCORE KEEPRING TRACK OF CORRECT OR WRONG ANSWERS
        scoreKeeper = [];
      } else {
        // IF USER SELECTED ANSWER IS CORRECT AND THE QUIZ IS NOT FINISHED
        if (userSelectedAnswer == correctAnswer) {
          // ADD CORRECT ANSWER TO SCORE KEEPER
          scoreKeeper.add(const Icon(
            Icons.check,
            color: Colors.green,
          ));
        } else {
          // ADD INCORRECT ANSWER TO SCORE KEEPER
          scoreKeeper.add(const Icon(
            Icons.close,
            color: Colors.red,
          ));
        }

        // GO TO NEXT QUESTION
        quizbrain.nextQuestion();
      }
    });
  }

  // TRACK THE SCORE AND DISPLAY IT ON THE SCREEN WITH ICONS
  List<Icon> scoreKeeper = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // DISPLAYS THE QUESTION
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizbrain.getQuestion(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // TRUE BUTTON
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {
                checkAnswer(true);
              },
              child: const Text(
                "True",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        // FALSE BUTTON
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {
                checkAnswer(false);
              },
              child: const Text(
                "False",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: scoreKeeper,
        ),
      ],
    );
  }
}
