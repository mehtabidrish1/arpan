class TblTeacherGradeModel {
    int id;
    String teacherGrade;

    TblTeacherGradeModel({
        required this.id,
        required this.teacherGrade,
    });

    factory TblTeacherGradeModel.fromJson(Map<String, dynamic> json) => TblTeacherGradeModel(
        id: json["ID"],
        teacherGrade: json["TeacherGrade"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "TeacherGrade": teacherGrade,
    };
}