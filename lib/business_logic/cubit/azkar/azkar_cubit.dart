import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constnats/language.dart';
import '../../../data/models/azkar.dart';
import '../../../helpers/cache_helper.dart';

part 'azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit() : super(AzkarInitial());
  static AzkarCubit get(context) => BlocProvider.of(context);

  Map azkars = {};
  List<Azkar> favorite = [];

  bool isEn = false;

  void getLanguage() {
    isEn = CacheHelper.getData(key: "Language") ?? false;
  }

  Future<void> readJson() async {
    emit(AzkarLodingState());

    final String responsr =
        await rootBundle.loadString("assets/quran/azkar.json");
    final data = await json.decode(responsr);
    int number = 0;
    for (var i in data) {
      if (!azkars.containsKey(i["category"])) {
        azkars[i["category"]] = [
          Azkar.fromJson(i, number++),
        ];
      } else {
        azkars[i["category"]].add(Azkar.fromJson(i, number++));
      }
    }
    getFavorite();
    emit(GetAzkarState());
  }

  void getFavorite() {
    List<String> favoriteList = CacheHelper.getDataList(key: 'azkarFavorite');
    List<Azkar> l = [];
    azkars.forEach((key, value) {
      l.addAll(value);
    });

    for (String i in favoriteList) {
      try {
        favorite.add(l[int.parse(i)]);
        l[int.parse(i)].favorite = true;
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }

  String? getText(String text) {
    if (isEn == true) return textsEn[text];
    return textsAr[text];
  }

  void addFavorite(Azkar azkar) async {
    if (azkar.favorite) {
      List<String> favoriteList = CacheHelper.getDataList(key: 'azkarFavorite');
      favoriteList = favoriteList.toList();
      favoriteList.add(azkar.id.toString());

      await CacheHelper.saveData(key: "azkarFavorite", value: favoriteList);
      favorite.add(azkar);
    } else {
      favorite.removeWhere((element) => element.id == azkar.id);

      var favoriteList = CacheHelper.getDataList(key: 'azkarFavorite');
      favoriteList.removeWhere((item) => item == azkar.id.toString());
      await CacheHelper.saveData(key: "azkarFavorite", value: favoriteList);
    }

    emit(AddFavoriteState());
  }

  void changeCount(Azkar azkar) {
    try {
      int count = int.parse(azkar.count);
      count = count == 0 ? int.parse(azkar.number) : --count;
      azkar.count = count.toString();
      emit(ChangeCountState());
    } catch (_) {}
  }
}
