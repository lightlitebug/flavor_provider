import 'package:meta/meta.dart';

class AppConfig {
  final String baseUrl;
  final String dataUrl;
  final String buildFlavor;

  AppConfig({
    @required this.baseUrl,
    @required this.dataUrl,
    @required this.buildFlavor,
  });
}
