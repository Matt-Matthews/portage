import 'package:bloc/bloc.dart';
import '../pages/myaccountspage.dart';
import '../pages/deliverypage.dart';

import '../pages/homepage.dart';
import '../pages/faq.dart';
import '../pages/settings.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
  FAQClickedEvent,
  SettingsClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield HomePage();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield MyAccountsPage();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield MyOrdersPage();
        break;
      case NavigationEvents.FAQClickedEvent:
        yield FAQ();
        break;
      case NavigationEvents.SettingsClickedEvent:
        yield Settings();
        break;
    }
  }
}
