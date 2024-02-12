import 'package:get/get.dart';

class KeyboardController extends GetxController {
  // Keyboard variables
  /* KeyboardUtils _keyboardUtils = KeyboardUtils();
  KeyboardUtils get keyboardUtils => this._keyboardUtils;
  int? _idKeyboardListener;

  @override
  void onInit() {
    super.onInit();

    _init();
  }

  @override
  void onClose() {
    super.onClose();

    _keyboardUtils.unsubscribeListener(subscribingId: _idKeyboardListener);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    }
  }

  void _init() {
    _idKeyboardListener = _keyboardUtils.add(
      listener: KeyboardListener(
        willHideKeyboard: () {
          // print( '_keyboardUtils.keyboardHeight: ${_keyboardUtils.keyboardHeight}');
          // inputPadding.value = _keyboardUtils.keyboardHeight;
        },
        willShowKeyboard: (double keyboardHeight) {
          // print('keyboardHeight: $keyboardHeight');
          // inputPadding.value = keyboardHeight;
        },
      ),
    );
  } */
}
