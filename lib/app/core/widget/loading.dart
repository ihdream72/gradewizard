
import 'package:flutter/material.dart';
import '../values/text_styles.dart';

enum LoadingType { loading, saving }

class Loading extends StatelessWidget {

  final LoadingType? type;

  const Loading({Key? key, this.type}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    // Map<LoadingType, String> lottieFile = {
    //   LoadingType.loading: 'assets/lottie/loading_icon.json',
    //   LoadingType.saving: 'assets/lottie/saving_icon.json',
    // };
    Map<LoadingType, String> loadingText = {
      LoadingType.loading: '읽어 오는중...',
      LoadingType.saving: '저장 하는중...',
    };

    return Container(
      color: const Color(0x66000000),
      child: Center(
        // child: Lottie.asset(
        //   lottieFile[type ?? LoadingType.saving]!,
        //   width: 120.s,
        //   height: 160.s,
        //   frameRate: FrameRate.max,
        // ),
        child: Text(loadingText[type ?? LoadingType.loading]!,
          style: Styles.suitXXLBold,
        ),
      ),
    );
  }
}
