import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/azkar_cubit.dart';
import 'package:my_prayer/data/models/azkar.dart';
import 'package:my_prayer/presentation/widgets/icon_button_responsive.dart';
import 'package:my_prayer/presentation/widgets/my_divider.dart';
import 'package:my_prayer/presentation/widgets/text_responsive.dart';

class ItemAzkarScreen extends StatelessWidget {
  final List<Azkar> azkars;
  final AzkarCubit cubit;
  final bool isFavorite;
  const ItemAzkarScreen(
      {required this.cubit,
      required this.azkars,
      this.isFavorite = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 40,
          centerTitle: true,
          title: TextResponsive(
                  text: isFavorite
                      ? cubit.getText("Favorite") ?? "Favorite"
                      : azkars[0].category,
                  maxSize: 20,
                  size: size)
              .headline3(context),
          leading: IconButtonResponsive(
            icons: Icons.arrow_back_ios_new_outlined,
            size: size,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocProvider.value(
          value: cubit,
          child: BlocConsumer<AzkarCubit, AzkarState>(
              listener: (_, __) {},
              builder: (context, state) {
                return SafeArea(
                  child: Directionality(
                    textDirection:
                        cubit.isEn ? TextDirection.ltr : TextDirection.rtl,
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView.separated(
                          itemCount: azkars.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return Card(
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      azkars[index].description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                      maxLines: 10,
                                    ),
                                    if (azkars[index].description.isNotEmpty)
                                      SizedBox(
                                        height: 40,
                                        child: buildDivider1(),
                                      ),
                                    const SizedBox(height: 10),
                                    Text(
                                      azkars[index].zekr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(
                                            fontSize: 20,
                                          ),
                                      maxLines: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColorDark
                                                  .withOpacity(0.2)),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                cubit
                                                    .changeCount(azkars[index]);
                                              },
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      cubit.getText(
                                                              "Repetition") ??
                                                          "Repetition",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3!
                                                          .copyWith(
                                                              fontSize: 20),
                                                      maxLines: 10,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark
                                                                .withOpacity(
                                                                    0.2)),
                                                      ),
                                                      child: Text(
                                                        azkars[index]
                                                            .count
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline3!
                                                            .copyWith(
                                                                fontSize: 20),
                                                        maxLines: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          buildDivider1(isVertical: true),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                azkars[index].favorite =
                                                    !azkars[index].favorite;
                                                cubit
                                                    .addFavorite(azkars[index]);
                                              },
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      cubit.getText(
                                                              "Favorite") ??
                                                          "Favorite",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3!
                                                          .copyWith(
                                                              fontSize: 20),
                                                      maxLines: 10,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    IconButtonResponsive(
                                                      icons: azkars[index]
                                                              .favorite
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      size: size,
                                                      onPressed: null,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}