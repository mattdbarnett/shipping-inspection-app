
// ===========================================
// Title: Home Hub
//
// Original Author: Matt Barnett
// Contributors: Matt Barnett, Nathan Baitup
// Commented By: Matt Barnett, Nathan Baitup
//
// Created: Mar 29, 2022 1:01am
// Last Modified: Mar 31, 2022 6:07am
// ===========================================

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/drawer/settings/settings_channels.dart';
import 'package:shipping_inspection_app/sectors/history/history_buttons.dart';
import 'package:shipping_inspection_app/sectors/home/home_channel.dart';
import 'package:shipping_inspection_app/sectors/home/home_percent.dart';
import 'package:shipping_inspection_app/sectors/questions/question_brain.dart';
import 'package:shipping_inspection_app/shared/section_header.dart';
import '../../main.dart';
import '../../shared/history_format.dart';
import '../../utils/app_colours.dart';
import '../questions/question_totals.dart';
import '../survey/survey_section.dart';

import '../drawer/drawer_globals.dart' as app_globals;

QuestionBrain questionBrain = QuestionBrain();

final ValueNotifier<bool> homeStateNotifier = ValueNotifier(false);

bool _loading = false;

class HomeHub extends StatefulWidget {
  final String vesselID;
  const HomeHub({Key? key, required this.vesselID}) : super(key: key);

  @override
  _HomeHubState createState() => _HomeHubState();
}

class _HomeHubState extends State<HomeHub> {
  @override
  void initState() {
    super.initState();
    vesselID = widget.vesselID;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ValueListenableBuilder<bool>(
        // Updates homepage state when notified.
        // Notified by calling "app_globals.homeStateUpdate()".
        valueListenable: homeStateNotifier,
        builder: (_, homeState, __) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                  child: SafeArea(
                      child: Center(
                          child: Column(children: <Widget>[
                            Container(
                                height: screenHeight * 0.12,
                                width: screenWidth,
                                padding: const EdgeInsets.all(0.0),
                                decoration: const BoxDecoration(
                                    color: AppColours.appLavender,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                    )),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //Displays dynamically updating current username & vessel ID.
                                      Text(
                                        app_globals.getUsername(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Vessel: " + widget.vesselID,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ]
                                )
                            ),
                            Container(
                              height: screenHeight * 0.12,
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  // Section header class simply denotes below-content.
                                  // Used as a class to maintain style consistency.
                                  // Found in Home Hub and Survey Hub.
                                  sectionHeader("Progress"),
                                ],
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(
                                  bottom: 20,
                                  left: 20,
                                ),
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      // Class "ActiveSurveyWidget" will get input survey section
                                      // and display its progress and metrics.
                                      // When more are added to replicate the survey, the container
                                      // will be scrollable horizontally.
                                      children: const [
                                        ActiveSurveysWidget(
                                          key: Key('IDWALFireAndSafetySectionProgressWidget'),
                                          sectionName: 'Fire and Safety',
                                          sectionID: 'f&s',
                                        ),
                                        ActiveSurveysWidget(
                                          sectionName: 'Lifesaving',
                                          sectionID: 'lifesaving',
                                        ),
                                        ActiveSurveysWidget(
                                          sectionName: 'Engine Room',
                                          sectionID: 'engine',
                                        ),
                                      ],
                                    ))),

                            // Divider to make section separation more obvious to users.
                            const Divider(
                              thickness: 1,
                              height: 1,
                            ),

                            Container(
                              height: screenHeight * 0.12,
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  sectionHeader("Channels"),
                                  // Settings button brings you directly to channels
                                  // settings which, when changed, instantly update
                                  // home-hub content.
                                  TextButton(
                                    key: const Key('IDWALHomeHubChannelSettingsButton'),
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: AppColours.appGrey,
                                      elevation: 2,
                                      shape: const CircleBorder(),
                                    ),
                                    child: const Icon(Icons.settings),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SettingsChannels(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Returns column of all saved channels in rows of
                            // two. The return will vary depending on the whether
                            // saved channels is enabled, how many channels the
                            // user has enabled and if the user has defined the
                            // name of any channels.
                            Column(children: getHomeChannels()),

                            const SizedBox(
                              height: 20,
                            ),
                            // Divider to make section separation more obvious to users.
                            const Divider(
                              thickness: 1,
                              height: 1,
                            ),

                            Container(
                              height: screenHeight * 0.12,
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  sectionHeader("History"),

                                  // History buttons class is instanced here
                                  // and in the history drawer page. Contains
                                  // buttons that allow you to change history
                                  // settings, clear all current history and
                                  // create a new instance of the history page.
                                  historyButtons(context),

                                ],
                              ),
                            ),
                            Container(
                                height: screenHeight * 0.45,
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                margin: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: 20,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColours.appPurple),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),

                                // Returns history records of the current
                                // use-session. Will return just varying text if
                                // there are no current records or if history
                                // logging as been disabled.
                                child: getHistoryBody()

                            )
                          ])))));

        });
  }
}

// Returns all saved channels in a widget format that is interact-able and dynamic.
List<Widget> getHomeChannels() {

  // List to store all saved channel content to be displayed on the home-hub.
  List<Widget> homeChannels = [];

  int currentChannel = 0;

  // Check if saved channels are enabled.
  if (app_globals.getSavedChannelsEnabled()) {
    //  If they are, iterate through each saved channel.
    for (int i = 0; i < (app_globals.savedChannelSum / 2); i++) {
      List<Widget> rowContent = [];

      if (app_globals.savedChannelSum - 1 > currentChannel) {
        // If the number of remaining channels is currently even, create
        // a row to display them together.
        rowContent = [
          Container(
            padding: const EdgeInsets.only(
              bottom: 20,
              left: 20,
              right: 5,
            ),
            child: HomeChannel(id: currentChannel),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(
              bottom: 20,
              left: 5,
              right: 20,
            ),
            child: HomeChannel(id: currentChannel + 1),
          ),
          const Spacer(),
        ];
      } else {
        // If the number of remaining channels is just one, display it in the
        // center of the page by itself.
        rowContent = [
          const Spacer(),
          HomeChannel(id: currentChannel),
          const Spacer(),
        ];
      }

      homeChannels.add(Row(children: rowContent));
      currentChannel += 2;
    }
  } else {
    homeChannels = [
      // If saved channels are disabled, show no widgets and just
      // informative text.
      const Text(
        "Saved channels have been disabled.",
        style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
      ),
      const SizedBox(
        height: 15,
      ),
      const Text(
        "Navigate to Settings to re-enable this feature.",
        style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
      ),
    ];
  }
  return homeChannels;
}

// Widget specifically for creating an active surveys box to be displayed in the state.
class ActiveSurveysWidget extends StatefulWidget {
  final String sectionName;
  final String sectionID;

  const ActiveSurveysWidget(
      {Key? key, required this.sectionName, required this.sectionID})
      : super(key: key);

  @override
  _ActiveSurveysWidgetState createState() => _ActiveSurveysWidgetState();
}

class _ActiveSurveysWidgetState extends State<ActiveSurveysWidget> {
  // A list to store the total amount and answered amount of questions.
  List<QuestionTotals> questionTotals = [];
  int numberOfQuestions = 0;
  int answeredQuestions = 0;

  @override
  void initState() {
    super.initState();
    _getResultsFromFirestore(widget.sectionID);
  }

  @override
  Widget build(BuildContext context) {
    double percent = answeredQuestions / numberOfQuestions;

    if (_loading) {
      return const HomePercentLoad();
    } else {
      return ValueListenableBuilder<bool>(
        valueListenable: homeStateNotifier,
        builder: (_, homeState, __) {
          return Row(
            children: <Widget>[
              GestureDetector(
                child: HomePercentActive(
                  sectionName: widget.sectionName,
                  loadingPercent: percent,
                  sectionSubtitle: '$answeredQuestions of $numberOfQuestions',
                ),
                onTap: () {
                  _loadQuestion(widget.sectionID);
                  setState(() {});
                },
              ),
              const SizedBox(width: 10.0),
            ],
          );
        },
      );
    }
  }

  // Takes the user to the required survey section when pressing on an active survey.
  void _loadQuestion(String questionID) {
    app_globals.addRecord(
        "opened", app_globals.getUsername(), DateTime.now(), 'camera');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveySection(
          vesselID: vesselID,
          questionID: questionID,
          issueFlagged: false,
        ),
      ),
    ).then(onGoBack);
  }

  // Loads a list of all the answered questions from firebase to see the total
  // amount of questions answered per section and saves them in a list.
  Future<List<QuestionTotals>> _getResultsFromFirestore(
      String sectionID) async {
    setState(() {
      _loading = true;
    });
    // The list to store all the total amount of questions and answered questions.
    List<QuestionTotals> questionTotals = [];
    int totalAnswered = 0;
    try {
      // Creates a instance reference to the Survey_Responses collection.
      CollectionReference reference =
          FirebaseFirestore.instance.collection('Survey_Responses');
      // Pulls all data where the vesselID and sectionID match.
      QuerySnapshot querySnapshot =
          await reference.where('vesselID', isEqualTo: vesselID).get();
      // Queries the snapshot to retrieve the section ID, the number of questions,
      // in the section and the number of answered questions and saves to
      // questionTotals.
      setState(() {
        for (var document in querySnapshot.docs) {
          questionTotals.add(QuestionTotals(document['sectionID'],
              document['numberOfQuestions'], document['answeredQuestions']));
        }

        // Sets the total amount of questions questions from Firebase.
        for (var i = 0; i < questionTotals.length; i++) {
          if (questionTotals[i].sectionID == sectionID) {
            totalAnswered++;
          }
        }
        // Sets the total number of questions and answered amount.
        numberOfQuestions = questionBrain.getQuestionAmount(sectionID);
        answeredQuestions = totalAnswered;

        // Checks if the number of answered questions is greater than the total
        // number of questions and sets the answered questions to the total
        // number of questions.
        if (answeredQuestions > numberOfQuestions) {
          answeredQuestions = numberOfQuestions;
        }
        _loading = false;
      });
    } catch (error) {
      debugPrint("Error: $error");
      setState(() {
        _loading = false;
      });
    }
    setState(() {
      _loading = false;
    });
    return questionTotals;
  }

  // REFERENCE accessed 29/03/2022 https://www.nstack.in/blog/flutter-refresh-on-navigator-pop-or-go-back/
  // Used to update the state of the progress widget once a survey section has been
  // updated, representing the current amount of responses.
  FutureOr<dynamic> onGoBack(dynamic value) {
    _getResultsFromFirestore(widget.sectionID);
    setState(() {});
  }
  // END REFERENCE
}
