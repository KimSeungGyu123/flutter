import 'dart:io';
// 1. Score 클래스 + StudentScore 클래스(상속)
class Score {
  int score;

  Score(this.score);

  void show() {
    print('점수: $score');
  }
}

class StudentScore extends Score {
  String name;
  

  StudentScore(this.name, int score) : super(score);

  @override
  void show() {
    print('이름: $name, 점수: $score');
  }
}

// 2. 파일에서 학생 데이터 읽어오기
List<StudentScore> loadStudentData(String filePath) {
  List<StudentScore> students = [];

  try {
    final file = File(filePath);
    final lines = file.readAsLinesSync();

    for (var line in lines) {
      final parts = line.split(',');
      if (parts.length != 2) throw FormatException('잘못된 데이터 형식: $line');

      String name = parts[0];
      int score = int.parse(parts[1]);

      students.add(StudentScore(name, score));
    }
  } catch (e) {
    print("학생 데이터를 불러오는 데 실패했습니다: $e");
    exit(1);
  }

  return students;
}

// 3. 사용자 입력 받아 학생 점수 확인
StudentScore? selectStudent(List<StudentScore> students) {
  while (true) {
    stdout.write("어떤 학생의 통계를 확인하시겠습니까? ");

    String input = stdin.readLineSync() ?? "";

    // 학생 찾기
    final student =
        students.where((s) => s.name == input.trim()).toList();

    if (student.isNotEmpty) {
      return student.first;
    } else {
      print("잘못된 학생 이름을 입력하셨습니다. 다시 입력해주세요.");
    }
  }
}

// 4. 결과를 파일로 저장
void saveResults(String filePath, String content) {
  try {
    final file = File(filePath);
    file.writeAsStringSync(content);
    print("저장이 완료되었습니다.");
  } catch (e) {
    print("저장에 실패했습니다: $e");
  }
}


void main() {
 
  const inputFile = "students.txt";
  const outputFile = "result.txt";

  // 1) 파일로부터 학생 데이터 가져오기
  List<StudentScore> students = loadStudentData(inputFile);

  // 2) 사용자 입력으로 학생 선택
  StudentScore selected = selectStudent(students)!;

  // 3) 정보 출력
  selected.show();

  // 4) 파일에 저장
  saveResults(outputFile, "이름: ${selected.name}, 점수: ${selected.score}");
}
