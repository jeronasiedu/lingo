import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingo/pages/quiz_page.dart';
import 'package:lingo/widgets/word_of_the_day.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  String _greeting = "";

  @override
  void initState() {
    super.initState();
    _updateGreeting();
  }

  void _updateGreeting() {
    DateTime now = DateTime.now();
    if (now.hour >= 5 && now.hour < 12) {
      setState(() {
        _greeting = "Good Morning!";
      });
    } else if (now.hour >= 12 && now.hour < 17) {
      setState(() {
        _greeting = "Good Afternoon!";
      });
    } else {
      setState(() {
        _greeting = "Good Evening!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              child: Icon(CupertinoIcons.person),
            ),
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _greeting,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    // color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "Let's learn something cool today",
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 16),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                "Practice English",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Text("You have new words!"),
            ),
            const WordOfTheDay(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                "Practice Quiz",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Text("Enhance your knowledge with word quiz"),
            ),
            Card(
              shadowColor: Colors.black45,
              elevation: 0.4,
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/quiz.png',
                      height: 250,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.maxFinite,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const QuizPage();
                            },
                          ));
                        },
                        icon: const Icon(
                          CupertinoIcons.doc,
                          size: 16,
                        ),
                        label: const Text("Start Quiz"),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
