
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/values/text_styles.dart';
import '/app/core/utils/ui_size_config.dart';

import '../controllers/audio_reading_controller.dart';


class ControlButton extends StatelessWidget {
  final AudioReadingController controller;

  const ControlButton(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: controller.colorMap[controller.viewMode]![ColorElement.controlBackground]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          volumeButton(context),
          previousButton(context),
          playButton(context),
          nextButton(context),
          speedButton(context),
        ],
      ),
    );
  }

  /// 볼륨 버튼
  Widget volumeButton(BuildContext context) {

    return IconButton(
      icon: Icon(Icons.volume_up, color: controller.colorMap[controller.viewMode]![ColorElement.icon]!,),
      iconSize: 32.s,
      onPressed: () {
        showSliderDialog(
          context: context,
          title: 'Volume',
          divisions: 10,
          min: 0.0,
          max: 1.0,
          value: controller.player.volume,
          stream: controller.player.volumeStream,
          onChanged: controller.setVolume,
        );
      },
    );
  }

  /// Previous 버튼
  Widget previousButton(BuildContext context) {

    return StreamBuilder<SequenceState?>(
        stream: controller.player.sequenceStateStream,
        builder: (context, snapshot) => IconButton(
          icon: Icon(Icons.skip_previous, color: controller.colorMap[controller.viewMode]![ColorElement.icon]!, size: 32.s,),
          iconSize: 64.s,
          onPressed: controller.playPrevious,
        ),
      );
  }

  /// Play/Pause/RePlay 버튼
  Widget playButton(BuildContext context) {

    return StreamBuilder<PlayerState>(
        stream: controller.player.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.isPlaying(playerState?.playing);
            if(controller.isPlaying.value) {
              controller.clearSelectedWord();
            }
          });

          if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
            return Container(
              margin: EdgeInsets.all(8.s),
              width: 64.s,
              height: 64.s,
            );
          } else if (processingState == ProcessingState.completed) {

            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.isPlaying(false);
            });

            return IconButton(
              icon: Icon(Icons.replay, color: controller.colorMap[controller.viewMode]![ColorElement.icon]!,),
              iconSize: 64.s,
              onPressed: controller.rePlay,
            );
          } else if (playing != true) {
            return IconButton(
              icon: Icon(Icons.play_arrow, color: controller.colorMap[controller.viewMode]![ColorElement.icon]!,),
              iconSize: 64.s,
              onPressed: controller.play,
            );
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
              icon: Icon(Icons.pause, color: controller.colorMap[controller.viewMode]![ColorElement.icon]!,),
              iconSize: 64.s,
              onPressed: controller.pause,
            );
          } else {

            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.isPlaying(false);
            });

            return IconButton(
              icon: Icon(Icons.replay, color: controller.colorMap[controller.viewMode]![ColorElement.icon]!,),
              iconSize: 64.s,
              onPressed: controller.rePlay,
            );
          }
        },
      );
  }

  /// Next 버튼
  Widget nextButton(BuildContext context) {

    return StreamBuilder<SequenceState?>(
      stream: controller.player.sequenceStateStream,
      builder: (context, snapshot) => IconButton(
        icon: Icon(Icons.skip_next, color: controller.colorMap[controller.viewMode]![ColorElement.icon]!,),
        iconSize: 32.s,
        onPressed: controller.playNext,
      ),
    );
  }

  /// 속도 설정 버튼
  Widget speedButton(BuildContext context) {

    return StreamBuilder<double>(
      stream: controller.player.speedStream,
      builder: (context, snapshot) => IconButton(
        icon: Text('${snapshot.data?.toStringAsFixed(1)}x',
            style: Styles.suitXXLMedium.copyWith(color: controller.colorMap[controller.viewMode]![ColorElement.textPlayingEnable]!,)),
        iconSize: 64.s,
        onPressed: () {
          showSliderDialog(
            context: context,
            title: 'Speed',
            divisions: 10,
            min: 0.5,
            max: 1.5,
            value: controller.player.speed,
            stream: controller.player.speedStream,
            onChanged: controller.setSpeed,
          );
        },
      ),
    );
  }

  void showSliderDialog({
    required BuildContext context,
    required String title,
    required int divisions,
    required double min,
    required double max,
    String valueSuffix = '',
    required double value,
    required Stream<double> stream,
    required ValueChanged<double> onChanged,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: StreamBuilder<double>(
          stream: stream,
          builder: (context, snapshot) => SizedBox(
            height: 100.s,
            child: Column(
              children: [
                Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                    style: Styles.suitXXLBold,),
                Slider(
                  divisions: divisions,
                  min: min,
                  max: max,
                  value: snapshot.data ?? value,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}