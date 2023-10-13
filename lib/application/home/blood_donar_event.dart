part of 'blood_donar_bloc.dart';

@freezed
class BloodDonarEvent with _$BloodDonarEvent {
  const factory BloodDonarEvent.readOrGetAllDonar() = ReadOrGetAllDonar;
  const factory BloodDonarEvent.createDonar({required DonarModel value}) =
      CreateDonar;
  const factory BloodDonarEvent.updateDonar({required DonarModel value}) =
      UpdateDonar;
  const factory BloodDonarEvent.deleteDoanar() = DeleteDoanar;
}
