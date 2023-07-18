
import '../view_model/chunk_view_model.dart';
import '../view_model/sentence_view_model.dart';
import 'chunk_model.dart';

class SentenceModel {
  int index = 0;
  double startTime = 0;
  double endTime = 0;
  List<ChunkModel> chunks = <ChunkModel>[];

  SentenceModel({required this.index, required this.startTime, required this.endTime, required this.chunks});

  SentenceModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    if (json['chunks'] != null) {
      chunks = <ChunkModel>[];
      json['chunks'].forEach((v) {
        chunks.add(ChunkModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['chunks'] = chunks.map((v) => v.toJson()).toList();
    return data;
  }

  SentenceViewModel toViewModel() {

    List<ChunkViewModel> list = <ChunkViewModel>[];

    for(ChunkModel model in chunks) {
      list.add(model.toViewModel());
    }

    return SentenceViewModel(
      index: index,
      startTime: (startTime * 1000).toInt(),
      endTime: (endTime * 1000).toInt(),
      chunks: list,
    );
  }
}