import 'package:app/design/colors.dart';
import 'package:app/design/typography.dart';
import 'package:app/services/router_service.dart';
import 'package:app/utils/locate.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  /// A constructor that passes [UniqueKey], for tests.
  AppWidget.unique() : super(key: UniqueKey());

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final _routerConfig = locate<RouterService>().config(
    navigatorObservers: () => [AutoRouteObserver()],
  );

  /// If we supported light mode, this is where the value would
  /// switch between light / dark, depending on [Theme.of(context).brightness].
  final colors = OurColors.dark;
  final typography = OurTypography.large;

  /// Providers that be overriden down in the widget tree.
  late final _providers = <SingleChildWidget>[
    Provider<OurColors>.value(value: colors),
    Provider<OurTypography>.value(value: typography),
  ];

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: _providers,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: false,
          themeMode: ThemeMode.dark, // We're only doing a dark theme.
          darkTheme: colors.getSimilarFlutterTheme(), // We're not doing Material3.
          routerConfig: _routerConfig,
        ),
      );
}
