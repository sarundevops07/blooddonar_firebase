part of 'blood_donar_bloc.dart';

@freezed
class BloodDonarState with _$BloodDonarState {
  const factory BloodDonarState(
      {required bool isLoading,
      required bool isError,
      required List<DonarModel> donar}) = _Initial;
  factory BloodDonarState.initial() =>
      const BloodDonarState(isLoading: false, isError: false, donar: []);
}
