import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_prayer/business_logic/cubit/listen/listen_cubit.dart';
import 'package:my_prayer/business_logic/cubit/listen/listen_state.dart';
import 'package:my_prayer/data/wepservices/audio_files_services.dart';
import 'package:my_prayer/presentation/screen/loading_screen.dart';

import '../../../constnats/quran.dart';
import '../../widgets/icon_button_responsive.dart';
import '../../widgets/text_responsive.dart';

class ListenScreen extends StatelessWidget {
  const ListenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<ListenCubit>(
      create: (context) => ListenCubit(audioFilesServices: AudioFilesServices())
        ..getData()
        ..getAudioFiles()
        ..initAudio(),
      child: BlocBuilder<ListenCubit, ListenState>(builder: (context, state) {
        ListenCubit cubit = ListenCubit.get(context);
        if (state is LoadingAudioFiles) {
          return const LoadingScreen(text: "Loding ...");
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            toolbarHeight: 50,
            centerTitle: true,
            title: TextResponsive(
                    text: cubit.getText("listen") ?? "Listen",
                    maxSize: 20,
                    size: size)
                .headline3(context),
            leading: IconButtonResponsive(
              icons: cubit.isEn
                  ? Icons.arrow_back_ios_rounded
                  : Icons.arrow_back_ios_rounded,
              size: size,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SizedBox(
            width: size.width,
            child: Stack(
              children: [
                Column(
                  children: [
                    Flexible(
                      child: ListView.separated(
                        itemCount: quranInfo.length,
                        separatorBuilder: (_, __) => Container(
                          color: Colors.black,
                          height: 1,
                          width: double.infinity,
                        ),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () => cubit
                              .setAudoi(index), //quranInfo[index]["Number"]),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                color: Theme.of(context).backgroundColor,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  quranInfo[index]["Number"].toString(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 18),
                                ),
                              ),
                              Container(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6),
                                height: 50,
                                width: 50,
                                alignment: Alignment.center,
                                child: Image.asset(
                                    quranInfo[index]["Descent"] == "مدنية"
                                        ? "assets/images/civil.webp"
                                        : "assets/images/kaaba.png"),
                              ),
                              Expanded(
                                  child: Container(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6),
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  cubit.isEn
                                      ? quranInfo[index]["English_Name"]
                                          .toString()
                                      : quranInfo[index]["Name"].toString(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 18),
                                ),
                              )),
                              Container(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6),
                                height: 50,
                                width: 50,
                                padding: const EdgeInsets.only(right: 2),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          cubit.getText("verses") ?? "verses",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          quranInfo[index]["Number_Verses"]
                                              .toString(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (cubit.url.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: size.width,
                      color: Theme.of(context).cardColor.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Slider(
                            value: cubit.position.inSeconds.toDouble(),
                            min: 0,
                            max: cubit.duration.inSeconds.toDouble(),
                            onChanged: (value) => cubit.sliderChanged(value),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextResponsive(
                                text: cubit.position.toString().split(".")[0],
                                maxSize: 14,
                                size: size,
                              ).headline4(context,
                                  color: Theme.of(context).backgroundColor,
                                  bold: true),
                              TextResponsive(
                                text: cubit.duration.toString().split(".")[0],
                                maxSize: 14,
                                size: size,
                              ).headline4(context,
                                  color: Theme.of(context).backgroundColor,
                                  bold: true)
                            ],
                          ),
                          const SizedBox(height: 10),
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Theme.of(context).backgroundColor,
                            child: IconButtonResponsive(
                              icons: cubit.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: size,
                              maxeSize: 35,
                              // isBackGroundColor: true,
                              onPressed: cubit.playOnPressed,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
