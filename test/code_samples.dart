import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/books.dart';
import 'utils/client.dart';

void main() {
  // this file hosts some code samples referenced in
  // .code-samples.meilisearch.yaml
  // it's subject to tests, lint rules, deprecation notices, etc...
  group('code samples', () {
    test('excerpts', () async {
      // #docregion search_parameter_guide_show_ranking_score_1
      await client
          .index('movies')
          .search('dragon', SearchQuery(showRankingScore: true));
      // #enddocregion

      // #docregion search_get_1
      await client.index('movies').search('american ninja');
      // #enddocregion
    });
  }, skip: true);
}
