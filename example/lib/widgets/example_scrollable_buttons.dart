import 'package:app/cubits/home_page_cubit.dart';
import 'package:app/design/colors.dart';
import 'package:app/design/tokens.dart';
import 'package:app/design/typography.dart';
import 'package:app/widgets/our_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExampleScrollableButtons extends StatelessWidget {
  const ExampleScrollableButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomePageCubit>();

    final colors = OurColors.of(context);
    final typography = OurTypography.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: xl, left: xs, right: xs),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "You've reached the bottom.",
            textAlign: TextAlign.center,
            style: typography.body.copyWith(color: colors.hint),
          ),
          Heights.xs,
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: xl,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: colors.accentPrimary,
                  ),
                  child: OurButton.expanded(
                    onTap: cubit.addSubscribedItem,
                    child: Text(
                      "+ Add More",
                      style: TextStyle(
                        color: colors.onAccentPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              Widths.xs,
              Container(
                alignment: Alignment.center,
                width: xl,
                height: xl,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.onBackground, width: Dimensions.lines),
                ),
                child: OurButton.expanded(
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 500));
                    cubit.addSubscribedItem(count: 4);
                  },
                  child: const Text(
                    "+4",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
