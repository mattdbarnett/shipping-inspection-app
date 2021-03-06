// ===========================================
// Title: AR Introduction
//
// Original Author: Nathan Baitup
// Contributors: Nathan Baitup
//
// Commented By: Nathan Baitup
//
// Created: Feb 13, 2022 16:40
// Last Modified: Mar 31, 2022 12:48
// ===========================================

import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

import '../../utils/app_colours.dart';
import '../drawer/drawer_globals.dart' as app_globals;
import '../questions/question_brain.dart';
import 'new_ar_hub.dart';

// The question brain to load all the questions.
QuestionBrain questionBrain = QuestionBrain();

class ARIntroduction extends StatefulWidget {
  final String vesselID;
  final String questionID;

  const ARIntroduction(
      {Key? key, required this.vesselID, required this.questionID})
      : super(key: key);

  @override
  _ARIntroductionState createState() => _ARIntroductionState();
}

class _ARIntroductionState extends State<ARIntroduction> {
  // The button that allows a user to skip the on-boarding process.
  late Material _materialButton;
  bool hasSeenTutorial = false;

  List<String> _questionsToAnswer = [];
  String _pageTitle = '';

  @override
  void initState() {
    super.initState();
    _initPageSetup();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColours.appPurple,
          secondary: AppColours.appPurpleLighter,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Idwal Vessel Inspection'),
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(color: AppColours.appPurple),
          centerTitle: true,
          leading: Transform.scale(
            scale: 0.7,
            child: FloatingActionButton(
              heroTag: 'on_back',
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: Onboarding(
          pages: _pagesList,
          background: AppColours.appPurple,
          onPageChange: (int pageIndex) => _buildButton(pageIndex),
          footer: Footer(
            footerMainAxisAlignment: MainAxisAlignment.spaceBetween,
            footerCrossAxisAlignment: CrossAxisAlignment.center,
            child: Container(
              child: _materialButton,
            ),
            indicator: Indicator(
              indicatorDesign: IndicatorDesign.polygon(
                polygonDesign: PolygonDesign(
                  polygon: DesignType.polygon_circle,
                ),
              ),
            ),
            indicatorPosition: IndicatorPosition.right,
            footerPadding: const EdgeInsets.only(
                left: 45.0, right: 150.0, top: 45.0, bottom: 45.0),
          ),
        ),
      ),
    );
  }

  // Initializes the page to navigate to the AR scene by getting the survey questions
  // and survey section title.
  void _initPageSetup() {
    _questionsToAnswer = questionBrain.getQuestions(widget.questionID);
    _pageTitle = questionBrain.getPageTitle(widget.questionID);
    _materialButton = _skipButton;
  }

  // REFERENCE accessed 23/03/2022 https://pub.dev/packages/onboarding
  // Used to create the next and finish buttons.
  void _buildButton(int pageIndex) {
    if (pageIndex == 4) {
      setState(() {
        _materialButton = _finishButton;
      });
    } else {
      setState(() {
        _materialButton = _skipButton;
      });
    }
  }

  // Creates the skip button to navigate directly to the AR screen.
  Material get _skipButton {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: defaultSkipButtonColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () async => _openARSection(),
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Skip to AR',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  // Creates the finish button to navigate to the AR screen after reading through
  // the instructions.
  Material get _finishButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: defaultProceedButtonColor,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () async => _openARSection(),
        child: const Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            'Finish',
            style: defaultProceedButtonTextStyle,
          ),
        ),
      ),
    );
  }
  // END REFERENCE

  // REFERENCE accessed 23/03/2022 https://pub.dev/packages/onboarding
  // Used template to create on-boarding widget with instructions on how to use the AR scene.
  final _pagesList = [
    // Gives instructions on how the questions function.
    PageModel(
      widget: Container(
        color: AppColours.appPurpleLighter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 40.0,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Questions:',
                  style: pageTitleStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 5.0,
                ),
                child: Image.asset('images/ar_onboarding/show_questions_1.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 20.0,
                ),
                child: Image.asset('images/ar_onboarding/show_questions_2.png'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 50.0,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'At the top of the screen, you will see the section your are inspecting and the relevant questions within the section. To cycle through each question, tap on the question text.',
                  style: pageInfoStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    // Gives instructions on the animated figure.
    PageModel(
      widget: Container(
        color: AppColours.appPurpleLighter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 40.0,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Move to view in scene indicator:',
                  style: pageTitleStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 5.0,
                ),
                child: Image.asset(
                    'images/ar_onboarding/show_loading_animator.png'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 15.0,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'When loading into the AR view, you will see a floating hand holding a phone. This animation is to move the device to allow the camera to locate an area to display an AR image.',
                  style: pageInfoStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    // Gives instructions on the AR navigation controls.
    PageModel(
      widget: Container(
        color: AppColours.appPurpleLighter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 40.0,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'AR Controls:',
                  style: pageTitleStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 5.0,
                ),
                child: Image.asset(
                    'images/ar_onboarding/show_option_controls.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 20.0,
                ),
                child: Image.asset(
                    'images/ar_onboarding/show_controls_with_screenshot.png'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 15.0,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'At the bottom of the screen are the controls within the AR scene. \n\nPressing on the camera button captures an image of the camera and AR model on screen and displays it in a preview at the bottom right hand side of the screen. \n\nThe tick saves any images taken within the AR view into the survey section. \n\nThe cross resets the AR scene back to an empty scene.',
                  style: pageInfoStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    // Gives information on the plane detection.
    PageModel(
      widget: Container(
        color: AppColours.appPurpleLighter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 40.0,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'AR Scene Detector:',
                  style: pageTitleStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 5.0,
                ),
                child: Image.asset(
                    'images/ar_onboarding/show_plane_detection.png'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 15.0,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Once the camera has found a place to add an AR scene, the floating hand animation disappears and a texture of where a model can be placed is displayed on the screen. \n\nTo add a model to the screen, simply tap the area you would like the model to appear.',
                  style: pageInfoStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    // Gives information on adding and viewing a 3D model.
    PageModel(
      widget: Container(
        color: AppColours.appPurpleLighter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 40.0,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Adding and Viewing an Model:',
                  style: pageTitleStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 5.0,
                ),
                child: Image.asset('images/ar_onboarding/show_model_1.png'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 15.0,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Once a model has been added, you will see it on the screen. This model is interactable by being both movable and rotatable. \n\nTo view the model in more detail, simply move your device closer and around the model.',
                  style: pageInfoStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];
  // END REFERENCE

  // Opens the AR section parsing through the data parsed in by the survey section.
  void _openARSection() async {
    app_globals.addRecord("opened", app_globals.getUsername(), DateTime.now(),
        '$_pageTitle AR session through button press');
    List<String> arContentPush = [_pageTitle] + _questionsToAnswer;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewARHub(
          vesselID: widget.vesselID,
          questionID: widget.questionID,
          arContent: arContentPush,
          openThroughQR: false,
          seenTutorial: true,
        ),
      ),
    );
  }
}
