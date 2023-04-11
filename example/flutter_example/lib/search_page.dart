import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/person.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meilisearch/meilisearch.dart';
import 'dart:async';

import 'highlighted_text.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _pageSize = 20;
  //If you are using this on an android emulator, check this: https://developer.android.com/studio/run/emulator-networking
  final client = MeiliSearchClient('http://127.0.0.1:7700', 'masterKey');
  MeiliSearchIndex? index;
  final _textController = TextEditingController();
  final faker = Faker();
  bool isPagination = false;
  int? totalHits;
  final _pagingController = PagingController<int, PersonDto>(firstPageKey: 0);
  Future<MeiliSearchIndex>? _initFuture;
  static const kPreTag = '<b>';
  static const kPostTag = '</b>';
  Future<void> seedFakePeople({int count = 100}) async {
    if (index == null) return;
    final task = await index!.addDocuments(
      Iterable.generate(
        100,
        (index) {
          final id = faker.guid.guid();
          final name = faker.person.name();
          //we duplicate the name to simulate cases where there are multiple highlights
          return PersonDto(id: id, name: "$name $name");
        },
      ).map((e) => e.toMap()).toList(),
      primaryKey: PersonDto.kid,
    );
    //Usually you would need to await for the task to complete, see https://github.com/meilisearch/meilisearch-dart/issues/260
    await Future.delayed(const Duration(milliseconds: 100));
    _pagingController.refresh();
  }

  Future<void> _fetchPage(int offsetOrPageIndex) async {
    if (index == null) return;
    try {
      final searchRes = await index!.search(
        _textController.text,
        //using infinite scroll
        limit: _pageSize,
        offset: offsetOrPageIndex,
        //using pagination
        page: isPagination ? offsetOrPageIndex + 1 : null,
        hitsPerPage: isPagination ? _pageSize : null,
        //highlighting
        attributesToHighlight: [PersonDto.kname],
        highlightPreTag: kPreTag,
        highlightPostTag: kPostTag,
      );
      final hitsRaw = searchRes.hits;
      if (hitsRaw == null) {
        return;
      }
      final hitsMapped = hitsRaw.map(PersonDto.fromMap).toList();
      bool isLastPage;
      int? nextPageKey;
      int? newTotalHits;
      if (searchRes is SearchResult) {
        //if the acquired list is less than the limit
        isLastPage = hitsMapped.length < (searchRes.limit ?? _pageSize);
        nextPageKey = isLastPage ? null : offsetOrPageIndex + hitsMapped.length;
        newTotalHits = searchRes.estimatedTotalHits;
      } else if (searchRes is PaginatedSearchResult) {
        //if the current page is >= totalPages
        isLastPage = offsetOrPageIndex + 1 >= searchRes.totalPages!;
        nextPageKey = isLastPage ? null : offsetOrPageIndex + 1;
        newTotalHits = searchRes.totalHits;
      } else {
        throw UnsupportedError("Impossible case");
      }

      if (nextPageKey == null) {
        _pagingController.appendLastPage(hitsMapped);
      } else {
        _pagingController.appendPage(hitsMapped, nextPageKey);
      }

      setState(() {
        totalHits = newTotalHits;
      });
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void onTextChanged() {
    //You might want to include a debounce here
    _pagingController.refresh();
  }

  Future<MeiliSearchIndex> initIndex() async {
    const indexUid = "people";
    try {
      return await client.getIndex(indexUid);
    } on MeiliSearchApiException catch (e) {
      if (e.code == 'index_not_found') {
        final task =
            await client.createIndex(indexUid, primaryKey: PersonDto.kid);
        //Usually you would need to await for the task to complete, see https://github.com/meilisearch/meilisearch-dart/issues/260
        await Future.delayed(const Duration(milliseconds: 100));
        final res = client.index(indexUid);
        return res;
      } else {
        rethrow;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initFuture = initIndex().then((value) => index = value);
    _pagingController.addPageRequestListener(_fetchPage);
    _textController.addListener(onTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String getTotalHitsText() {
    final sb = StringBuffer('Total Hits: ');
    if (totalHits == null) {
      sb.write("UNKOWN");
    } else {
      sb.write(totalHits.toString());
      if (isPagination) {
        sb.write(" Exactly");
      } else {
        sb.write(" Estimated");
      }
    }
    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MeiliSearchIndex>(
      future: _initFuture,
      builder: (context, snapshot) {
        final index = snapshot.data;
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (index == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return Scaffold(
          endDrawer: Drawer(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: isPagination,
                  title: const Text("Use Pagination"),
                  subtitle: const Text("Slower, but more accurate total hits"),
                  onChanged: (value) {
                    setState(() {
                      isPagination = value;
                    });
                    _pagingController.refresh();
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: const Text("Meilisearch Example"),
            actions: [
              IconButton(
                onPressed: () => seedFakePeople(),
                icon: const Icon(Icons.input),
                tooltip: "Seed 100 Fake People",
              ),
              Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  icon: const Icon(Icons.filter_alt),
                  tooltip: "Open filter drawer",
                ),
              ),
              IconButton(
                onPressed: () => _pagingController.refresh(),
                icon: const Icon(Icons.refresh),
                tooltip: "Refresh",
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Filter",
                    helperText: getTotalHitsText(),
                    suffixIcon: IconButton(
                      onPressed: () => _textController.clear(),
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  controller: _textController,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: PagedListView<int, PersonDto>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) {
                        return ListTile(
                          subtitle: Text((index + 1).toString()),
                          title: HighlightedText(
                            original: item.formattedTitle,
                            preTag: kPreTag,
                            postTag: kPostTag,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
