import 'package:flutter/material.dart';

import '../../constants/style/style1.dart';
import '../../models/question_model.dart';
import '../../utils/lableText.dart';

class TrainingSurveyPollResponse extends StatelessWidget {
  final List<QuestionData>? questions;

  TrainingSurveyPollResponse({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.grey.shade300,
          centerTitle: true,
          title: Text(LabelText.pollresponse, style: Styles.black145),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              FocusScope.of(context).unfocus();
          
             // isDisposed = true;

               Navigator.of(context).pop();
            },
          ),
      ),
      body: ListView.builder(
        itemCount: questions!.length,
        itemBuilder: (context, index) {
          final question = questions![index];
          final totalResponses = question.totalResponse ?? 1; // Ensure no division by zero

          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.question!,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Correct Answer: ${question.correctAnswer}',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Total Responses: ${question.totalResponse}',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Options:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: question.options.map((option) {
                      final isCorrectOption = option.option == question.correctAnswer;
                      final count = option.totalOption ?? 0;
                      final percentage = count / totalResponses;

                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              option.option!,
                              style: TextStyle(
                                color: isCorrectOption ? Colors.green : Colors.red,
                                fontWeight: isCorrectOption ? FontWeight.bold : null,
                              ),
                            ),
                            Text(
                              'Count: $count',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Stack(
                          children: [
                            LinearProgressIndicator(
                              value: percentage,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isCorrectOption ? Colors.green : Colors.red,
                              ),
                              backgroundColor: Colors.grey[300],
                              minHeight: 20, // Adjust the thickness as needed
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
