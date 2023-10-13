import 'package:bloc/bloc.dart';
import 'package:blooddonar_firebase/domain/failures/main_failures.dart';
import 'package:blooddonar_firebase/domain/model/donar.dart';
import 'package:blooddonar_firebase/domain/repo/i_homescreen_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'blood_donar_event.dart';
part 'blood_donar_state.dart';
part 'blood_donar_bloc.freezed.dart';

class BloodDonarBloc extends Bloc<BloodDonarEvent, BloodDonarState> {
  final IHomeScreenRepository iHomeScreenRepository;
  BloodDonarBloc(this.iHomeScreenRepository)
      : super(BloodDonarState.initial()) {
    //* READ DONAR OR GET ALL DONAR

    on<ReadOrGetAllDonar>((event, emit) async {
// INITIAL STATE

      emit(state.copyWith(isLoading: true));

// GET DATA FROM FIRE STORE

      final result = await iHomeScreenRepository.readOrGetAllDonar();

// DISPLAY TO UI

      final listOfDonar = result.fold(
          (MainFailures failures) =>
              const BloodDonarState(isLoading: false, isError: true, donar: []),
          (List<DonarModel> success) => BloodDonarState(
              isLoading: false, isError: false, donar: success));
      emit(listOfDonar);
    });

    //* CREATE DONAR

    on<CreateDonar>((event, emit) async {
      // INITIAL STATE

      emit(state.copyWith(isLoading: true));

      // ADD DONAR TO FIRESTORE

      final result =
          await iHomeScreenRepository.createDonar(value: event.value);

      //DISPLAY TO UI

      final listOfDonar = result.fold(
          (MainFailures failures) =>
              const BloodDonarState(isLoading: false, isError: true, donar: []),
          (List<DonarModel> success) => BloodDonarState(
              isLoading: false, isError: false, donar: success));
      emit(listOfDonar);
    });

    //* UPDATE DONAR

    on<UpdateDonar>((event, emit) async {
      // INITIAL STATE

      emit(state.copyWith(isLoading: true));

      // UPDATE DONAR TO FIRESTORE

      await iHomeScreenRepository.updateDonar(updatedValue: event.value);
    });

    //* DELETE DONAR

    on<BloodDonarEvent>((event, emit) {});
  }
}
