import 'package:flutter/foundation.dart';
import 'package:groto_shop/enums/view_state.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.IDLE;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
