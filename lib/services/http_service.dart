import 'package:dio/dio.dart';

class HTTPService {
  HTTPService();
  final _dio = Dio();

  Future<Response?> getPokemons(String path) async {
    try {
      Response res = await _dio.get(path);
      return res;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
