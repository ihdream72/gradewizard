
# This is for gradewizard.

## 개발 환경 (GetX, MVVM, Rx) 
- 상태 관리 : GetX (ver 4.6.5)
- Navigation & Routing : GetX (ver 4.6.5)
- Design Pattern : GetX의 기본 구조에 따른 MVVM 사용
- Rx Programming : GetX Rx 이용
- Coding Style : Flutter lint (ver 1.0.4) - analysis_options.yaml
- Flutter Version : Channel stable, 3.7.9


## 구현 기능

- Audio 관련 
  - Play / Pause / Seek / Volume / Speed
  
- 자막 기능
  - 현재 재생 Chunk Tracking
  - 사용자 스크롤 후 2초 뒤  현재 재생 으로 복귀 
  - 문장 자동/수동 이동 (이전/다음)
  - 문장 직접 이동 (Horizontal Scroll 된 문장 으로 이동)
  
- UI 기능
  - 테마 적용 (dark / light)
  - 상단 Header Widget ( 현재 문장, 전체 진행 상황 )
  - tooltip 기능 (선태된 단어에 대한 tooltip)
  - tooltip 에서 상세 보기 기능 (다음 어학 사전에 Webview 연결)


## Source Tree

- './app/core' => 앱 전반적 으로 사용 하는 소스들
- './app/core/base' => GetView / GetXController 를 확장한 Abstract Class
- './app/core/utils' => logger (개발용 logger), uiSizeConfig (Design 비율을 맞추기 위한 size wrapper) 
- './app/core/values' => Color, Style, Value 값들의 define 값
- './app/core/widget' => 공용 으로 사용 하는 UI Widgets

- './app/di' => GetX의 binding 을 이용한 Dependency Injection
- './app/routes' => Navigation & Routing & Routing Observer 을 위한 소스들  

- './app/screen' => App 의 Routing 되는 View(화면)별 소스 코드 
- './app/screen/home' => 최초 진입 화면
- './app/screen/audio_reading' => 과제 테스트 관련된 화면 구현 (Audio 자막 관리)
- './app/screen/webview' => audio_reading 에서 지정한 단어의 영어 사전(dic.daum.net) 연결을 위한 WebView

- './app/app_controller.dart' : App 의 Life-Cycle 을 관리 하는 Controller 
- './main.dart' : dart Entry Point 

## 사용된 주요 Plugin

[기능 구현]
- GetX (4.6.5) : 상태 관리
- just_audio (0.9.32) : Audio 재생
- just_the_tooltip (0.0.12) : Tooltip 기능
- webview_flutter (3.0.4) : WebView 기능

[개발용]
- flutter_lints (1.0.4) : coding style
- logger (1.1.0) : log 

flutter build apk --release