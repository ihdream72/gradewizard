
import '../view_model/chunk_view_model.dart';
import '../view_model/word_view_model.dart';

class ChunkModel {
  String text = '';
  double startTime = 0;
  double endTime = 0;
  int index = 0;

  ChunkModel({required this.text, required this.startTime, required this.endTime, required this.index});

  ChunkModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];

    if(json['startTime'] is int) {
      startTime = json['startTime'].toDouble();
    } else if(json['startTime'] is double) {
      startTime = json['startTime'];
    }

    if(json['endTime'] is int) {
      endTime = json['endTime'].toDouble();
    } else if(json['endTime'] is double) {
      endTime = json['endTime'];
    }

    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['index'] = index;
    return data;
  }

  ChunkViewModel toViewModel() {

    List<WordViewModel> words = <WordViewModel>[];

    List<String> list = text.split(' ');

    for(String str in list) {
      words.add(WordViewModel(text: str));
    }

    return ChunkViewModel(
      index: index,
      startTime: (startTime * 1000).toInt(),
      endTime: (endTime * 1000).toInt(),
      text: text,
      words: words,
    );
  }
}