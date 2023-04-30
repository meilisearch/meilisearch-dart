import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/browser.dart';

import 'adapter.dart';

class TestAdapter extends BrowserHttpClientAdapter with TestAdapterBase {
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
