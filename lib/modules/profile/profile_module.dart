import 'package:flutter_modular/flutter_modular.dart';

import 'profile_bloc.dart';
import 'profile_page.dart';

class ProfileModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => ProfileBloc()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => ProfilePage(user: args.data)),
      ];
}
