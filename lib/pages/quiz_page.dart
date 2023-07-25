import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lingo/extensions/strings.dart';
import 'package:lingo/modules/quiz.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _scrollController = PageController();
  int _currentPage = 0;
  final String url = "https://twinword-word-association-quiz.p.rapidapi.com/type1/";

  late Future<List<Quiz>> _getQuiz;
  int _totalQuestions = 2;

  Future<List<Quiz>> getQuiz() async {
    try {
      final response = await Dio().get(url,
          options: Options(
            headers: {
              "X-RapidAPI-Key": "e8cd84b118mshe5a362a36526edbp145330jsn8340b1bba6ec",
              "X-RapidAPI-Host": "twinword-word-association-quiz.p.rapidapi.com"
            },
          ),
          queryParameters: {"level": "3", "area": "sat"});
      final List<Quiz> quiz = [];
      for (final item in response.data["quizlist"]) {
        List<String> options = (item["option"] as List<dynamic>).map((option) => option as String).toList();
        List<String> quizTexts = (item["quiz"] as List<dynamic>).map((option) => option as String).toList();
        quiz.add(Quiz(
          options: options,
          correct: item["option"][item["correct"] - 1],
          quiz: quizTexts,
        ));
      }
      return quiz;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _getQuiz = getQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quizlet"),
      ),
      body: FutureBuilder(
        future: _getQuiz,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 20),
                  Text("Loading Quiz..."),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("We encountered an error while loading the quiz. 🥹"),
            );
          }

          if (snapshot.hasData) {
            final data = snapshot.data as List<Quiz>;


            return Padding(
              padding: const EdgeInsets.only(top: 100, left: 15, right: 15, bottom: 15),
              child: PageView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    _totalQuestions = data.length;
                  });
                },
                itemBuilder: (context, index) {
                  final quiz = data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose the word associated with the following words.",
                          textAlign: TextAlign.center,
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium,
                        ),
                        const SizedBox(height: 30),
                        Wrap(
                          spacing: 20,
                          children: List.generate(quiz.quiz.length, (index) {
                            final word = quiz.quiz[index];
                            return Chip(
                              shape: const StadiumBorder(),
                              side: BorderSide(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                              ),
                              avatar: CircleAvatar(
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              label: Text(word.capitalize()),
                            );
                          }),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text("OPTIONS", style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium),
                        ),
                        ...List.generate(
                          quiz.options.length,
                              (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: ListTile(
                                onTap: () {
                                  if (quiz.options[index] == quiz.correct) {
                                    ScaffoldMessenger.of(context)
                                      ..clearSnackBars()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text("You're right 😇"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                      ..clearSnackBars()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text("Hmm, try again 🥹"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                  }
                                },
                                shape: StadiumBorder(side: BorderSide(color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary)),
                                title: Text(quiz.options[index].capitalize()),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: Text("No quiz today 🥹"),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FilledButton.tonal(
                onPressed: _currentPage == 0
                    ? null
                    : () {
                  _scrollController.previousPage(
                      duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
                child: const Text("Prev")),
            FilledButton.tonal(
                onPressed: _currentPage == _totalQuestions - 1
                    ? null
                    : () {
                  _scrollController.nextPage(
                      duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
                child: const Text("Next"))
          ],
        ),
      ),
    );
  }
}
