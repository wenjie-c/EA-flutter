// Si, inspirado de android

class SharedPreferences {
  final Map<String, String> _map = {};
  static SharedPreferences? _instance;
  SharedPreferences._();

  factory SharedPreferences() {
    _instance ??= SharedPreferences._();
    return _instance!;
  }

  void put(String key, String value) {
    _map[key] = value;
  }

  String? read(String key) {
    return _map[key];
  }
}
