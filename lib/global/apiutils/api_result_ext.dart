import 'package:portfolio/global/apiutils/api_response.dart';

extension ApiResultExt<T> on Result<T> {
  T unwrap() => fold((data) => data, (error) => throw Exception(error));
}

extension FutureResultExt<T> on Future<Result<T>> {
  Future<T> unwrap() async => (await this).unwrap();
}
