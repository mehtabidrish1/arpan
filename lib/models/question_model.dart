class QuestionModel {
   int? pageNumber;
   int? pageSize;
   int? fetchedRecords;
   int? totalRecords;
   int? nextPage;
   bool? nextPageAvailable;
   List<QuestionData> data;
   bool? succeeded;
   dynamic errors;
   dynamic message;

  QuestionModel({
     this.pageNumber,
     this.pageSize,
     this.fetchedRecords,
     this.totalRecords,
     this.nextPage,
     this.nextPageAvailable,
    required this.data,
     this.succeeded,
     this.errors,
     this.message,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      pageNumber: json['PageNumber'],
      pageSize: json['PageSize'],
      fetchedRecords: json['FetchedRecords'],
      totalRecords: json['TotalRecords'],
      nextPage: null,
      nextPageAvailable: json['NextPageAvailabe'],
      data: (json['Data'] as List).map((e) => QuestionData.fromJson(e)).toList(),
      succeeded: json['Succeeded'],
      errors: json['Errors'],
      message: json['Message'],
    );
  }
}

class QuestionData {
   String? questionId;
   String? question;
   int? totalResponse;
   String? correctAnswer;
   List<Option> options;

  QuestionData({
     this.questionId,
     this.question,
     this.totalResponse,
     this.correctAnswer,
    required this.options,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      questionId: json['QuestionID'],
      question: json['Question'],
      totalResponse: json['TotalResponse'],
      correctAnswer: json['CorrectAnswer'],
      options: (json['Options'] as List).map((e) => Option.fromJson(e)).toList(),
    );
  }
}

class Option {
   String? questionId;
   String? option;
   int? totalOption;

  Option({
     this.questionId,
     this.option,
     this.totalOption,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      questionId: json['QuestionID'],
      option: json['Option'],
      totalOption: json['TotalOption'],
    );
  }
}
