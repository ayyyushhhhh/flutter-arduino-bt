import 'dart:async';

class BluetoothBloc {
  final StreamController<String> _btValStream =
      StreamController<String>.broadcast();

  Stream<String> get btStream => _btValStream.stream;

  void updateValue(String val) {
    _btValStream.add(val);
  }

  void dispose() {
    _btValStream.close();
  }
}
