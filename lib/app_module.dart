import 'package:flutter_modular/flutter_modular.dart';

import 'modules/home/home_module.dart';
import 'modules/profile/profile_module.dart';

class AppModule extends Module {
  final String _initialRoute;

  AppModule({required String initialRoute}) : _initialRoute = initialRoute;

  @override
  List<ModularRoute> get routes => [
        RedirectRoute('/', to: '/home'),
        ModuleRoute('/home', module: HomeModule()),
        ModuleRoute('/profile', module: ProfileModule()),
      ];

  String get initialRoute => _initialRoute;
}
