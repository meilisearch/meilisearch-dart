import 'package:dio/dio.dart';

import 'adapter_io.dart' if (dart.library.html) 'adapter_browser.dart'
    as adapter;

mixin TestAdapterBase on HttpClientAdapter {
  bool fetchCalled = false;
}

TestAdapterBase createTestAdapter() => adapter.TestAdapter();
