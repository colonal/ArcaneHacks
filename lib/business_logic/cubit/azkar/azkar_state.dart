part of 'azkar_cubit.dart';

@immutable
abstract class AzkarState {}

class AzkarInitial extends AzkarState {}

class GetAzkarState extends AzkarState {}

class AzkarLodingState extends AzkarState {}

class AddFavoriteState extends AzkarState {}

class ChangeCountState extends AzkarState {}
