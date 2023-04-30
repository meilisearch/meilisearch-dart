import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'adapter_io.dart' if (dart.library.html) 'adapter_browser.dart'
    as adapter;

mixin TestAdapterBase on HttpClientAdapter {
  bool fetchCalled = false;
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

TestAdapterBase createTestAdapter() => adapter.TestAdapter();
