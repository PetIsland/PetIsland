import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/common/common.dart';
import 'package:flutter_template/main_app/main_app.dart';
import 'package:flutter_template/main_bloc/main_bloc.dart';
import 'package:flutter_template/module/module.dart';
import 'package:flutter_template/splash/splash_screen.dart';
import 'package:petisland_core/petisland_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: TColors.water_melon));
  handleError();
  final MainAppBloc bloc = MainAppBloc();
  initAsync(bloc);
  runZoned(() {
    runApp(buildApp(bloc));
  }, onError: (dynamic ex, dynamic trace) {
    Crashlytics.instance.recordError(ex, trace);
  });
}

void initAsync(MainAppBloc bloc) async {
  bloc.loadDependence();
  final Mode mode = kReleaseMode ? Mode.Production : Mode.Debug;
  final List<Module> modules = kReleaseMode
      ? <Module>[ProdModuleCore(), ProdModule()]
      : <Module>[DevModuleCore(), DevModule()];

  Config.initAsync(mode)
      .then((_) => DI.initAsync(modules))
      .then((_) => bloc.completeLoadDependence())
      .catchError((dynamic ex) => Log.error(ex));
}

void handleError() {
  FlutterError.onError = (FlutterErrorDetails error) {
    FlutterError.dumpErrorToConsole(error);
    Zone.current.handleUncaughtError(error.exception, error.stack);
  };
  if (!kReleaseMode) {
    BlocSupervisor.delegate = TBlocDelegate();
  }
}

Widget buildApp(MainAppBloc bloc) {
  final Widget screen = createMainScreen(bloc);
  return BlocProvider<MainAppBloc>(
    create: (_) => bloc,
    child: screen,
  );
}

Widget createMainScreen(MainAppBloc bloc) {
  return BlocBuilder<MainAppBloc, MainAppState>(
    bloc: bloc,
    builder: (_, MainAppState state) {
      switch (state.runtimeType) {
        case CreatedAppState:
        case DependenceLoadingApp:
          return const SplashScreen();
          break;

        case ThemeAppChanged:
        case ActiveApp:
          return MainAppScreen(bloc);

        default:
          Log.debug('blocBuilder: $bloc');
          return SizedBox();
      }
    },
  );
}
