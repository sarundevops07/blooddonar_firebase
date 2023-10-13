import 'package:blooddonar_firebase/domain/failures/main_failures.dart';
import 'package:blooddonar_firebase/domain/model/donar.dart';
import 'package:dartz/dartz.dart';

abstract class IHomeScreenRepository {
  Future<Either<MainFailures, List<DonarModel>>> readOrGetAllDonar();
  Future<Either<MainFailures, List<DonarModel>>> createDonar(
      {required DonarModel value});
  Future<Either<MainFailures, List<DonarModel>>> updateDonar(
      {required DonarModel updatedValue});
  Future<Either<MainFailures, List<DonarModel>>> deleteDonar();
}
