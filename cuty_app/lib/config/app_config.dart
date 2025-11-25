import 'package:flutter/foundation.dart';
import 'dart:io';

class AppConfig {
  static String _environment = 'production';

  static const String _devPort = '5012';

  // 수동 설정: 시뮬레이터/에뮬레이터 여부를 직접 지정
  // 실제 기기에서 테스트할 때는 이 값을 true로 변경하세요
  static const bool _forceUseRealDevice = false;
  
  // 시뮬레이터/에뮬레이터 감지 (단순화된 버전)
  static bool get _isSimulator {
    if (kIsWeb || _forceUseRealDevice) return false;
    
    // 디버그 모드에서는 기본적으로 시뮬레이터/에뮬레이터로 간주
    // 실제 기기에서 테스트할 때는 위의 _forceUseRealDevice를 true로 설정
    return kDebugMode && !_forceUseRealDevice;
  }

  static String get platformHost {
    const String macRealIP = '172.30.1.3'; // 맥의 실제 IP 주소 - 네트워크에 맞게 수정하세요
    
    String host;
    
    if (Platform.isIOS) {
      if (_isSimulator) {
        // iOS 시뮬레이터: localhost 사용 가능
        host = 'localhost';
        print('🍎 iOS 시뮬레이터 감지: localhost 사용');
      } else {
        // iOS 실제 기기: 맥의 실제 IP 주소 필요
        host = macRealIP;
        print('📱 iOS 실제 기기 감지: $macRealIP 사용');
      }
    } else if (Platform.isAndroid) {
      if (_isSimulator) {
        // Android 에뮬레이터: 10.0.2.2 = 호스트의 localhost
        host = '10.0.2.2';
        print('🤖 Android 에뮬레이터 감지: 10.0.2.2 사용');
      } else {
        // Android 실제 기기: 맥의 실제 IP 주소 필요
        host = macRealIP;
        print('📱 Android 실제 기기 감지: $macRealIP 사용');
      }
    } else {
      // 기본값 (웹 등 기타 플랫폼)
      host = 'localhost';
      print('🌐 기타 플랫폼: localhost 사용');
    }
    
    return host;
  }

  static String get developmentUrl {
    return 'http://' + platformHost + ':' + _devPort + '/api/v1';
  }

  // static const String developmentUrl = 'http://10.0.2.2:5012/api/v1';
  static const String productionUrl =
      'https://zm3czse9yf.execute-api.ap-northeast-2.amazonaws.com/prod/api/v1';

  static set environment(String env) {
    _environment = env;
  }

  static String get baseApiUrl {
    switch (_environment) {
      case 'development':
        print(
          'developmentUrl: '
          '${developmentUrl}',
        );
        return developmentUrl;
      case 'production':
        print('productionUrl: $productionUrl');
        return productionUrl;
      default:
        throw Exception('Unknown environment: $_environment');
    }
  }
}
