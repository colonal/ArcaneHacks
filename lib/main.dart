import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic/cubit/my_bloc_observer/my_bloc_observer.dart';
import 'presentation/screen/onboarding_screen.dart';
import 'presentation/widgets/build_material_app.dart';

import 'custom_scroll_behavior.dart';
import 'helpers/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  bool onboarding = CacheHelper.getData(key: "onboarding") ?? false;
  BlocOverrides.runZoned(
    () => runApp(MyApp(onboarding)),
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp(this.onboarding, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !onboarding
        ? MaterialApp(
            scrollBehavior: MyCustomScrollBehavior(),
            home: const OnboardingScreen(),
            debugShowCheckedModeBanner: false)
        : const BuildMaterialApp();
  }
}
