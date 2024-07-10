import 'package:app/cubits/home_page_cubit.dart';
import 'package:app/design/colors.dart';
import 'package:app/design/tokens.dart';
import 'package:app/utils/our_page_widget.dart';
import 'package:app/widgets/example_scrollable.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomePage extends OurPageWidget<HomePageCubit> {
  const HomePage({super.key});

  static const contentPadding = Horizontals.sm;

  @override
  HomePageCubit buildCubit(BuildContext context) => HomePageCubit();

  @override
  Widget buildWidget(BuildContext context) {
    final cubit = context.read<HomePageCubit>();
    final (paginated, subscribed) = cubit.observe((s) => (s.paginated, s.subscribed));

    final colors = OurColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: ExampleScrollable(
        paginated: paginated,
        subscribed: subscribed,
      ),
    );
  }
}
