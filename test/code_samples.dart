// ignore_for_file: unused_element

import 'dart:io';

import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';

import 'utils/client.dart';

void main() {
  // this file hosts some code samples referenced in
  // .code-samples.meilisearch.yaml
  // it's subject to tests, lint rules, deprecation notices, etc...
  group('code samples', () {
    setUpClient();

    test('excerpts', () async {
      void a1() async {
        // #docregion typo_tolerance_guide_1
        final toUpdate = TypoTolerance(enabled: false);
        await client.index('movies').updateTypoTolerance(toUpdate);
        // #enddocregion
      }

      void a2() async {
        // #docregion typo_tolerance_guide_2
        final toUpdate = TypoTolerance(
          disableOnAttributes: ['title'],
        );
        await client.index('movies').updateTypoTolerance(toUpdate);
        // #enddocregion
      }

      void a3() async {
        // #docregion typo_tolerance_guide_3
        final toUpdate = TypoTolerance(
          disableOnWords: ['shrek'],
        );
        await client.index('movies').updateTypoTolerance(toUpdate);
        // #enddocregion
      }

      void a4() async {
        // #docregion typo_tolerance_guide_4
        final toUpdate = TypoTolerance(
          minWordSizeForTypos: MinWordSizeForTypos(
            oneTypo: 4,
            twoTypos: 10,
          ),
        );
        await client.index('movies').updateTypoTolerance(toUpdate);
        // #enddocregion
      }

      void a8() async {
        // #docregion getting_started_add_meteorites
        final json = await File('meteorites.json').readAsString();

        await client.index('meteorites').addDocumentsJson(json);
        // #enddocregion
      }

      void a10() async {
        // #docregion add_movies_json_1
        // import 'dart:io';
        // import 'dart:convert';
        final json = await File('movies.json').readAsString();
        await client.index('movies').addDocumentsJson(json);
        // #enddocregion
      }

      void a11() async {
        // #docregion security_guide_delete_key_1
        var client = MeiliSearchClient('http://localhost:7700', 'masterKey');
        await client.deleteKey('ac5cd97d-5a4b-4226-a868-2d0eb6d197ab');
        // #enddocregion
      }

      void a12() async {
        // #docregion security_guide_list_keys_1
        var client = MeiliSearchClient('http://localhost:7700', 'masterKey');
        await client.getKeys();
        // #enddocregion
      }

      void a13() async {
        // #docregion security_guide_create_key_1
        var client = MeiliSearchClient('http://localhost:7700', 'masterKey');
        await client.createKey(
          description: 'Search patient records key',
          actions: ['search'],
          indexes: ['patient_medical_records'],
          expiresAt: DateTime(2023, 01, 01),
        );
        // #enddocregion
      }

      void a14() async {
        // #docregion authorization_header_1
        var client = MeiliSearchClient('http://localhost:7700', 'masterKey');
        await client.getKeys();
        // #enddocregion
      }

      void a15() async {
        // #docregion security_guide_search_key_1
        var client = MeiliSearchClient('http://localhost:7700', 'apiKey');
        await client.index('patient_medical_records').search('');
        // #enddocregion
      }

      void a16() async {
        // #docregion security_guide_update_key_1
        var client = MeiliSearchClient('http://localhost:7700', 'masterKey');
        await client.updateKey(
          '74c9c733-3368-4738-bbe5-1d18a5fecb37',
          description: 'Default Search API Key',
        );
        // #enddocregion
      }

      // #docregion date_guide_index_1
      //import 'dart:io';
      //import 'dart:convert';

      final json = await File('games.json').readAsString();

      await client.index('games').addDocumentsJson(json);
      // #enddocregion

      // #docregion date_guide_filterable_attributes_1
      await client
          .index('games')
          .updateFilterableAttributes(['release_timestamp']);
      // #enddocregion

      // #docregion date_guide_filter_1
      await client.index('games').search(
            '',
            SearchQuery(
              filterExpression: Meili.and([
                Meili.gte(
                  'release_timestamp'.toMeiliAttribute(),
                  Meili.value(DateTime(2017, 12, 31, 23, 0)),
                ),
                Meili.lt(
                  'release_timestamp'.toMeiliAttribute(),
                  Meili.value(DateTime(2022, 12, 31, 23, 0)),
                ),
              ]),
            ),
          );
      // #enddocregion

      // #docregion date_guide_sortable_attributes_1
      await client
          .index('games')
          .updateSortableAttributes(['release_timestamp']);
      // #enddocregion

      // #docregion date_guide_sort_1
      await client
          .index('games')
          .search('', SearchQuery(sort: ['release_timestamp:desc']));
      // #enddocregion

      // #docregion get_all_tasks_paginating_1
      await client.getTasks(params: TasksQuery(limit: 2, from: 10));
      // #enddocregion

      // #docregion get_all_tasks_paginating_2
      await client.getTasks(params: TasksQuery(limit: 2, from: 8));
      // #enddocregion

      // #docregion get_pagination_settings_1
      await client.index('movies').getPagination();
      // #enddocregion

      // #docregion update_pagination_settings_1
      await client
          .index('books')
          .updatePagination(Pagination(maxTotalHits: 100));
      // #enddocregion

      // #docregion reset_pagination_settings_1
      await client.index('movies').resetPagination();
      // #enddocregion

      // #docregion get_faceting_settings_1
      await client.index('movies').getFaceting();
      // #enddocregion

      // #docregion update_faceting_settings_1
      await client.index('books').updateFaceting(Faceting(
              maxValuesPerFacet: 2,
              sortFacetValuesBy: {
                '*': FacetingSortTypes.alpha,
                'genres': FacetingSortTypes.count
              }));
      // #enddocregion

      // #docregion reset_faceting_settings_1
      await client.index('movies').resetFaceting();
      // #enddocregion

      // #docregion get_one_index_1
      await client.getIndex('movies');
      // #enddocregion

      // #docregion list_all_indexes_1
      await client.getIndexes(params: IndexesQuery(limit: 3));
      // #enddocregion

      // #docregion create_an_index_1
      await client.createIndex('movies', primaryKey: 'id');
      // #enddocregion

      // #docregion update_an_index_1
      await client.index('movies').update(primaryKey: 'id');
      // #enddocregion

      // #docregion delete_an_index_1
      await client.index('movies').delete();
      // #enddocregion

      // #docregion get_one_document_1
      await client.index('movies').getDocument(25684,
          fields: ['id', 'title', 'poster', 'release_date']);
      // #enddocregion

      // #docregion add_or_replace_documents_1
      await client.index('movies').addDocuments([
        {
          'id': 287947,
          'title': 'Shazam',
          'poster':
              'https://image.tmdb.org/t/p/w1280/xnopI5Xtky18MPhK40cZAGAOVeV.jpg',
          'overview':
              'A boy is given the ability to become an adult superhero in times of need with a single magic word.',
          'release_date': '2019-03-23'
        }
      ]);
      // #enddocregion

      // #docregion add_or_update_documents_1
      await client.index('movies').updateDocuments([
        {
          'id': 287947,
          'title': 'Shazam ⚡️',
          'genres': 'comedy',
        }
      ]);
      // #enddocregion

      // #docregion delete_all_documents_1
      await client.index('movies').deleteAllDocuments();
      // #enddocregion

      // #docregion delete_one_document_1
      await client.index('movies').deleteDocument(25684);
      // #enddocregion

      // #docregion delete_documents_by_batch_1
      await client.index('movies').deleteDocuments(
            DeleteDocumentsQuery(
              ids: [23488, 153738, 437035, 363869],
            ),
          );
      // #enddocregion

      // #docregion search_post_1
      await client.index('movies').search('American ninja');
      // #enddocregion

      // #docregion get_task_1
      await client.getTask(1);
      // #enddocregion

      // #docregion get_all_tasks_1
      await client.getTasks();
      // #enddocregion

      // #docregion get_settings_1
      await client.index('movies').getSettings();
      // #enddocregion

      // #docregion update_settings_1
      await client.index('movies').updateSettings(
            IndexSettings(
              rankingRules: [
                'words',
                'typo',
                'proximity',
                'attribute',
                'sort',
                'exactness',
                'release_date:desc',
                'rank:desc'
              ],
              distinctAttribute: 'movie_id',
              searchableAttributes: ['title', 'overview', 'genres'],
              displayedAttributes: [
                'title',
                'overview',
                'genres',
                'release_date'
              ],
              stopWords: ['the', 'a', 'an'],
              sortableAttributes: ['title', 'release_date'],
              synonyms: {
                'wolverine': ['xmen', 'logan'],
                'logan': ['wolverine'],
              },
            ),
          );
      // #enddocregion

      // #docregion reset_settings_1
      await client.index('movies').resetSettings();
      // #enddocregion

      // #docregion get_synonyms_1
      await client.index('movies').getSynonyms();
      // #enddocregion

      // #docregion update_synonyms_1
      await client.index('movies').updateSynonyms({
        'wolverine': ['xmen', 'logan'],
        'logan': ['wolverine', 'xmen'],
        'wow': ['world of warcraft'],
      });
      // #enddocregion

      // #docregion reset_synonyms_1
      await client.index('movies').resetSynonyms();
      // #enddocregion

      // #docregion get_stop_words_1
      await client.index('movies').getStopWords();
      // #enddocregion

      // #docregion update_stop_words_1
      await client.index('movies').updateStopWords(['of', 'the', 'to']);
      // #enddocregion

      // #docregion reset_stop_words_1
      await client.index('movies').resetStopWords();
      // #enddocregion

      // #docregion get_ranking_rules_1
      await client.index('movies').getRankingRules();
      // #enddocregion

      // #docregion update_ranking_rules_1
      await client.index('movies').updateRankingRules([
        'words',
        'typo',
        'proximity',
        'attribute',
        'sort',
        'exactness',
        'release_date:asc',
        'rank:desc',
      ]);
      // #enddocregion

      // #docregion reset_ranking_rules_1
      await client.index('movies').resetRankingRules();
      // #enddocregion

      // #docregion get_distinct_attribute_1
      await client.index('shoes').getDistinctAttribute();
      // #enddocregion

      // #docregion update_distinct_attribute_1
      await client.index('shoes').updateDistinctAttribute('skuid');
      // #enddocregion

      // #docregion reset_distinct_attribute_1
      await client.index('shoes').resetDistinctAttribute();
      // #enddocregion

      // #docregion get_filterable_attributes_1
      await client.index('movies').getFilterableAttributes();
      // #enddocregion

      // #docregion update_filterable_attributes_1
      await client
          .index('movies')
          .updateFilterableAttributes(['genres', 'director']);
      // #enddocregion

      // #docregion reset_filterable_attributes_1
      await client.index('movies').resetFilterableAttributes();
      // #enddocregion

      // #docregion get_searchable_attributes_1
      await client.index('movies').getSearchableAttributes();
      // #enddocregion

      // #docregion update_searchable_attributes_1
      await client
          .index('movies')
          .updateSearchableAttributes(['title', 'overview', 'genres']);
      // #enddocregion

      // #docregion reset_searchable_attributes_1
      await client.index('movies').resetSearchableAttributes();
      // #enddocregion

      // #docregion get_displayed_attributes_1
      await client.index('movies').getDisplayedAttributes();
      // #enddocregion

      // #docregion update_displayed_attributes_1
      await client.index('movies').updateDisplayedAttributes([
        'title',
        'overview',
        'genres',
        'release_date',
      ]);
      // #enddocregion

      // #docregion reset_displayed_attributes_1
      await client.index('movies').resetDisplayedAttributes();
      // #enddocregion

      // #docregion get_typo_tolerance_1
      await client.index('books').getTypoTolerance();
      // #enddocregion

      // #docregion update_typo_tolerance_1
      final toUpdate = TypoTolerance(
        minWordSizeForTypos: MinWordSizeForTypos(
          oneTypo: 4,
          twoTypos: 10,
        ),
        disableOnAttributes: ['title'],
      );
      await client.index('books').updateTypoTolerance(toUpdate);
      // #enddocregion

      // #docregion reset_typo_tolerance_1
      await client.index('books').resetTypoTolerance();
      // #enddocregion

      // #docregion get_index_stats_1
      await client.index('movies').getStats();
      // #enddocregion

      // #docregion get_indexes_stats_1
      await client.getStats();
      // #enddocregion

      // #docregion get_health_1
      await client.health();
      // #enddocregion

      // #docregion get_version_1
      await client.getVersion();
      // #enddocregion

      // #docregion distinct_attribute_guide_1
      await client.index('jackets').updateDistinctAttribute('product_id');
      // #enddocregion

      // #docregion field_properties_guide_searchable_1
      await client
          .index('movies')
          .updateSearchableAttributes(['title', 'overview', 'genres']);
      // #enddocregion

      // #docregion field_properties_guide_displayed_1
      await client.index('movies').updateDisplayedAttributes([
        'title',
        'overview',
        'genres',
        'release_date',
      ]);
      // #enddocregion

      // #docregion filtering_guide_1
      await client.index('movie_ratings').search(
            'Avengers',
            SearchQuery(
              filterExpression: Meili.gt(
                Meili.attr('release_date'),
                DateTime.utc(1995, 3, 18).toMeiliValue(),
              ),
            ),
          );
      // #enddocregion

      // #docregion filtering_guide_2
      await client.index('movie_ratings').search(
            'Batman',
            SearchQuery(
              filterExpression: Meili.and([
                Meili.attr('release_date')
                    .gt(DateTime.utc(1995, 3, 18).toMeiliValue()),
                Meili.or([
                  'director'.toMeiliAttribute().eq('Tim Burton'.toMeiliValue()),
                  'director'
                      .toMeiliAttribute()
                      .eq('Christopher Nolan'.toMeiliValue()),
                ]),
              ]),
            ),
          );
      // #enddocregion

      // #docregion filtering_guide_3
      await client.index('movie_ratings').search(
            'Planet of the Apes',
            SearchQuery(
              filterExpression: Meili.and([
                Meili.attr('release_date')
                    .gt(DateTime.utc(2020, 1, 1, 13, 15, 50).toMeiliValue()),
                Meili.not(
                  Meili.attr('director').eq("Tim Burton".toMeiliValue()),
                ),
              ]),
            ),
          );
      // #enddocregion

      // #docregion search_parameter_guide_query_1
      await client.index('movies').search('shifu');
      // #enddocregion

      // #docregion search_parameter_guide_offset_1
      await client.index('movies').search('shifu', SearchQuery(offset: 1));
      // #enddocregion

      // #docregion search_parameter_guide_limit_1
      await client.index('movies').search('shifu', SearchQuery(limit: 2));
      // #enddocregion

      // #docregion search_parameter_guide_matching_strategy_1
      await client.index('movies').search(
          'big fat liar', SearchQuery(matchingStrategy: MatchingStrategy.last));
      // #enddocregion

      // #docregion search_parameter_guide_matching_strategy_2
      await client.index('movies').search(
          'big fat liar', SearchQuery(matchingStrategy: MatchingStrategy.all));
      // #enddocregion

      // #docregion search_parameter_guide_retrieve_1
      await client.index('movies').search(
          'shifu', SearchQuery(attributesToRetrieve: ['overview', 'title']));
      // #enddocregion

      // #docregion search_parameter_guide_crop_1
      await client.index('movies').search(
          'shifu', SearchQuery(attributesToCrop: ['overview'], cropLength: 5));
      // #enddocregion

      // #docregion search_parameter_guide_highlight_1
      await client.index('movies').search(
          'winter feast', SearchQuery(attributesToHighlight: ['overview']));
      // #enddocregion

      // #docregion search_parameter_guide_show_matches_position_1
      await client
          .index('movies')
          .search('winter feast', SearchQuery(showMatchesPosition: true));
      // #enddocregion

      // #docregion primary_field_guide_create_index_primary_key
      await client.createIndex('books', primaryKey: 'reference_number');
      // #enddocregion

      // #docregion primary_field_guide_update_document_primary_key
      await client.updateIndex('books', 'title');
      // #enddocregion

      // #docregion primary_field_guide_add_document_primary_key
      await client.index('movies').addDocuments([
        {
          'reference_number': 287947,
          'title': 'Diary of a Wimpy Kid',
          'author': 'Jeff Kinney',
          'genres': ['comedy', 'humor'],
          'price': 5.00
        }
      ], primaryKey: 'reference_number');
      // #enddocregion

      // #docregion getting_started_update_ranking_rules
      await client.index('movies').updateRankingRules([
        'exactness',
        'words',
        'typo',
        'proximity',
        'attribute',
        'sort',
        'release_date:asc',
        'rank:desc',
      ]);
      // #enddocregion

      // #docregion getting_started_update_searchable_attributes
      await client.index('movies').updateSearchableAttributes(['title']);
      // #enddocregion

      // #docregion getting_started_update_stop_words
      await client.index('movies').updateStopWords(['the']);
      // #enddocregion

      // #docregion getting_started_check_task_status
      await client.getTask(0);
      // #enddocregion

      // #docregion getting_started_synonyms
      await client.index('movies').updateSynonyms({
        'winnie': ['piglet'],
        'piglet': ['winnie'],
      });
      // #enddocregion

      // #docregion getting_started_update_displayed_attributes
      await client
          .index('movies')
          .updateDisplayedAttributes(['title', 'overview', 'poster']);
      // #enddocregion

      // #docregion getting_started_configure_settings
      await client.index('meteorites').updateSettings(IndexSettings(
          filterableAttributes: ['mass', '_geo'],
          sortableAttributes: ['mass', '_geo']));
      // #enddocregion

      // #docregion getting_started_geo_radius
      await client.index('meteorites').search(
            '',
            SearchQuery(
              filterExpression: Meili.geoRadius(
                (lat: 46.9480, lng: 7.4474),
                210000,
              ),
            ),
          );
      // #enddocregion

      // #docregion getting_started_geo_point
      await client.index('meteorites').search(
          '', SearchQuery(sort: ['_geoPoint(48.8583701, 2.2922926):asc']));
      // #enddocregion

      // #docregion getting_started_sorting
      await client.index('meteorites').search(
            '',
            SearchQuery(
              sort: ['mass:asc'],
              filterExpression: Meili.attr('mass').lt(200.toMeiliValue()),
            ),
          );
      // #enddocregion

      // #docregion getting_started_filtering
      await client
          .index('meteorites')
          .search('', SearchQuery(filter: 'mass < 200'));
      // #enddocregion

      // #docregion getting_started_faceting
      await client.index('books').updateFaceting(Faceting(
          maxValuesPerFacet: 2,
          sortFacetValuesBy: {'*': FacetingSortTypes.count}));
      // #enddocregion

      void a9() async {
        // #docregion getting_started_typo_tolerance
        final toUpdate = TypoTolerance(
          minWordSizeForTypos: MinWordSizeForTypos(oneTypo: 4),
        );
        await client.index('movies').updateTypoTolerance(toUpdate);
        // #enddocregion
      }

      // #docregion getting_started_pagination
      await client
          .index('books')
          .updatePagination(Pagination(maxTotalHits: 500));
      // #enddocregion

      // #docregion filtering_update_settings_1
      await client.index('movies').updateFilterableAttributes([
        'director',
        'genres',
      ]);
      // #enddocregion

      // #docregion faceted_search_walkthrough_filter_1
      await client.index('movies').search(
          'thriller',
          SearchQuery(filter: [
            ['genres = Horror', 'genres = Mystery'],
            'director = "Jordan Peele"'
          ]));
      // #enddocregion

      // #docregion post_dump_1
      await client.createDump();
      // #enddocregion

      // #docregion phrase_search_1
      await client.index('movies').search('"african american" horror');
      // #enddocregion

      // #docregion sorting_guide_update_sortable_attributes_1
      await client.index('books').updateSortableAttributes(['author', 'price']);
      // #enddocregion

      // #docregion sorting_guide_update_ranking_rules_1
      await client.index('books').updateRankingRules(
          ['words', 'sort', 'typo', 'proximity', 'attribute', 'exactness']);
      // #enddocregion

      // #docregion sorting_guide_sort_parameter_1
      await client
          .index('books')
          .search('science fiction', SearchQuery(sort: ['price:asc']));
      // #enddocregion

      // #docregion sorting_guide_sort_parameter_2
      await client
          .index('books')
          .search('butler', SearchQuery(sort: ['author:desc']));
      // #enddocregion

      // #docregion get_sortable_attributes_1
      await client.index('books').getSortableAttributes();
      // #enddocregion

      // #docregion update_sortable_attributes_1
      await client.index('books').updateSortableAttributes(['price', 'author']);
      // #enddocregion

      // #docregion reset_sortable_attributes_1
      await client.index('books').resetSortableAttributes();
      // #enddocregion

      // #docregion search_parameter_guide_sort_1
      await client
          .index('books')
          .search('science fiction', SearchQuery(sort: ['price:asc']));
      // #enddocregion

      // #docregion geosearch_guide_filter_settings_1
      await client.index('restaurants').updateFilterableAttributes(['_geo']);
      // #enddocregion

      // #docregion geosearch_guide_filter_usage_1
      await client.index('restaurants').search(
            '',
            SearchQuery(
              filterExpression: Meili.geoRadius(
                (lat: 45.472735, lng: 9.184019),
                2000,
              ),
            ),
          );
      // #enddocregion

      // #docregion geosearch_guide_filter_usage_2
      await client.index('restaurants').search(
            '',
            SearchQuery(
              filterExpression: Meili.and([
                Meili.geoRadius(
                  (lat: 45.472735, lng: 9.184019),
                  2000,
                ),
                Meili.attr('type').eq('pizza'.toMeiliValue())
              ]),
            ),
          );
      // #enddocregion

      // #docregion geosearch_guide_sort_settings_1
      await client.index('restaurants').updateSortableAttributes(['_geo']);
      // #enddocregion

      // #docregion geosearch_guide_sort_usage_1
      await client.index('restaurants').search(
          '', SearchQuery(sort: ['_geoPoint(48.8561446, 2.2978204):asc']));
      // #enddocregion

      // #docregion geosearch_guide_sort_usage_2
      await client.index('restaurants').search(
          '',
          SearchQuery(
              sort: ['_geoPoint(48.8561446, 2.2978204):asc', 'rating:desc']));
      // #enddocregion

      // #docregion get_one_key_1
      await client.getKey('6062abda-a5aa-4414-ac91-ecd7944c0f8d');
      // #enddocregion

      // #docregion get_all_keys_1
      await client.getKeys(params: KeysQuery(limit: 3));
      // #enddocregion

      // #docregion create_a_key_1
      await client.createKey(
          description: 'Add documents: Products API key',
          actions: ['documents.add'],
          indexes: ['products'],
          expiresAt: DateTime(2042, 04, 02));
      // #enddocregion

      // #docregion update_a_key_1
      await client.updateKey(
        '6062abda-a5aa-4414-ac91-ecd7944c0f8d',
        description: 'Manage documents: Products/Reviews API key',
        name: 'Products/Reviews API key',
      );
      // #enddocregion

      // #docregion delete_a_key_1
      await client.deleteKey('6062abda-a5aa-4414-ac91-ecd7944c0f8d');
      // #enddocregion

      // #docregion search_parameter_guide_crop_marker_1
      await client.index('movies').search(
            'shifu',
            SearchQuery(
              attributesToCrop: ['overview'],
              cropMarker: '[…]',
            ),
          );
      // #enddocregion

      // #docregion search_parameter_guide_highlight_tag_1
      await client.index('movies').search(
            'winter feast',
            SearchQuery(
              attributesToHighlight: ['overview'],
              highlightPreTag: '<span class="highlight">',
              highlightPostTag: '</span>',
            ),
          );
      // #enddocregion

      // #docregion geosearch_guide_filter_usage_3
      await client.index('restaurants').search(
          '',
          SearchQuery(
              filter:
                  '_geoBoundingBox([45.494181, 9.214024], [45.449484, 9.179175])'));
    });
    // #enddocregion
    // skip this test, since it's only used for generating code samples
  }, skip: true);

// unformatted examples
/*
    // #docregion getting_started_search_md
    ```dart
    await client.index('movies').search('botman');
    ```

    [About this SDK](https://github.com/meilisearch/meilisearch-dart/)
    // #enddocregion

    // #docregion getting_started_add_documents_md
    ```bash
    dart pub add meilisearch
    ```

    ```dart
    import 'package:meilisearch/meilisearch.dart';
    import 'dart:io';
    import 'dart:convert';

    var client = MeiliSearchClient('http://localhost:7700', 'aSampleMasterKey');

    final json = await File('movies.json').readAsString();

    await client.index('movies').addDocumentsJson(json);
    ```

    [About this SDK](https://github.com/meilisearch/meilisearch-dart/)
    // #enddocregion
*/
}
