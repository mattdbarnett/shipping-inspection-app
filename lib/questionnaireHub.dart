import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/questionnaire_section.dart';

class QuestionnaireHub extends StatefulWidget {
  const QuestionnaireHub({Key? key}) : super(key: key);

  @override
  _QuestionnaireHubState createState() => _QuestionnaireHubState();
}

class _QuestionnaireHubState extends State<QuestionnaireHub> {
  void loadQuestion(String questionID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionnaireSection(questionID: questionID),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Questionnaire Hub",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Table(
                  children: [
                    const TableRow(
                      children: [
                        Text(
                          "Sections",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "Progress",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "Questionnaire Link",
                          textScaleFactor: 1.5,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Fire & Safety",
                          textScaleFactor: 1.5,
                        ),
                        const Text(
                          "1 of 3",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            loadQuestion('f&s');
                          },
                          child: const Text("Go to this Section?"),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Lifesaving",
                          textScaleFactor: 1.5,
                        ),
                        const Text(
                          "1 of 2",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            loadQuestion('lifesaving');
                          },
                          child: const Text("Go to this Section?"),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          "Engine Room",
                          textScaleFactor: 1.5,
                        ),
                        const Text(
                          "1 of 2",
                          textScaleFactor: 1.5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            loadQuestion('engine');
                          },
                          child: const Text("Go to this Section?"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}