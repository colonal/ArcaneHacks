import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_prayer/helpers/cache_helper.dart';

import '../../constnats/language.dart';
import '../../data/models/ayah.dart';

part 'ayah_state.dart';

class AyahCubit extends Cubit<AyahState> {
  AyahCubit() : super(AyahInitial());

  bool isEn = false;

  static AyahCubit get(context) => BlocProvider.of(context);

  List<Ayah> ayahs = [];
  List<dynamic> versesFavorite = [];
  List<int> indexFavorite = [];

  bool isFavorite = false;
  int indexPage = 0;

  int indexAyah = -1;
  int indexSurah = -1;

  Future<void> readJson() async {
    emit(AyahLodingState());
    getLanguage();
    final String responsr =
        await rootBundle.loadString("assets/quran/ayah.json");
    final data = await json.decode(responsr);
    for (var item in data) {
      ayahs.add(Ayah.fromJson(item));
    }
    getBookmark();
    getFavorite();
    emit(GetAyahState());
  }

  void getBookmark() {
    indexSurah = CacheHelper.getData(key: "indexSurah");
    indexAyah = CacheHelper.getData(key: "indexAyah");
  }

  void getLanguage() {
    isEn = CacheHelper.getData(key: "Language") ?? false;
  }

  void getFavorite() {
    var favoriteList = CacheHelper.getData(key: 'versesFavorite') ?? [];
    List newFavoriteList = [];
    for (String i in favoriteList) {
      newFavoriteList
          .add([int.parse(i.split(":")[0]), int.parse(i.split(":")[1])]);

      versesFavorite.add([
        ayahs[int.parse(i.split(":")[0])].verses[int.parse(i.split(":")[1])],
        int.parse(i.split(":")[0])
      ]);
      ayahs[int.parse(i.split(":")[0])]
          .verses[int.parse(i.split(":")[1])]
          .favorite = true;
    }
  }

  void setIndexPage(int index) {
    indexPage = index;
    emit(IndexPageState());
  }

  void changeSaveAyah(int surah, int ayah) async {
    indexSurah = surah;
    indexAyah = ayah;
    emit(ChangeSaveAyahState());
    await CacheHelper.saveData(key: "indexSurah", value: surah);
    await CacheHelper.saveData(key: "indexAyah", value: ayah);
  }

  void addVersesFavorite(Verses verses, int indexAyahVerses) async {
    int indexSurahVerses = verses.id - 1;
    if (verses.favorite!) {
      versesFavorite.add([verses, indexAyahVerses]);
      List<String> favoriteList =
          CacheHelper.getDataList(key: 'versesFavorite');
      favoriteList = favoriteList.toList();
      favoriteList.add("$indexAyahVerses:$indexSurahVerses");

      await CacheHelper.saveData(key: "versesFavorite", value: favoriteList);
    } else {
      versesFavorite.removeWhere(((element) => element[0].id == verses.id));

      var favoriteList = CacheHelper.getDataList(key: 'versesFavorite');
      favoriteList
          .removeWhere((item) => item == "$indexAyahVerses:$indexSurahVerses");
      await CacheHelper.saveData(key: "versesFavorite", value: favoriteList);
    }
    emit(AddVersesFavoriteState());
  }

  void changeIsFavorite() {
    isFavorite = !isFavorite;
    emit(ChangeIsFavoriteState());
  }

  String? getText(String text) {
    if (isEn == true) return textsEn[text];
    return textsAr[text];
  }
}