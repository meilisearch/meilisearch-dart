import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'adapter.dart';

class TestAdapter extends IOHttpClientAdapter with TestAdapterBase {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    fetchCalled = true;
    return super.fetch(options, requestStream, cancelFuture);
  }
}
