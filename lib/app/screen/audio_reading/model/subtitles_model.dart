
import '../view_model/sentence_view_model.dart';
import '../view_model/subtitles_view_model.dart';
import 'sentence_model.dart';

class SubTitlesModel {
  List<SentenceModel> sentences = <SentenceModel>[];

  SubTitlesModel({required this.sentences});

  SubTitlesModel.fromJson(Map<String, dynamic> json) {
    if (json['sentences'] != null) {
      sentences = <SentenceModel>[];
      json['sentences'].forEach((v) {
        sentences.add(SentenceModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['sentences'] = sentences.map((v) => v.toJson()).toList();

    return data;
  }

  SubTitlesViewModel toViewModel() {

    List<SentenceViewModel> list = <SentenceViewModel>[];

    for(SentenceModel model in sentences) {
      list.add(model.toViewModel());
    }

    return SubTitlesViewModel(
      sentences: list
    );
  }

}



