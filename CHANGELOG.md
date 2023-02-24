


- `TasksQuery#canceledBy` field is now a `List<int>` and not an `int?` anymore.
- Add `indexUid` to `Task`



- Expose these classes:
  - `PaginatedSearchResult`
  - `DocumentsQuery`
  - `TasksQuery`
  - `CancelTasksQuery`
  - `DeleteTasksQuery`
  - `KeysTasksQuery`
  - `IndexesTasksQuery`
  - `MatchingStrategy` enum
  - `MeiliSearchApiException` and `CommunicationException`
  - `Task` and `TaskError`
  - `SwapIndex`




- Remove `dart:mirrors` dependency. Enable `flutter` and `web` platforms again.




⚠️ Don't use this version if you're using with Flutter or Web. It is not supported due to a mistake in the implementation of the `Queryable` class.
Please use the next available version.

- `SearchResult` now is returned from `search` requests when is a non-exhaustive pagination request. A instance of `PaginatedSearchResult` is returned when the request was made with finite pagination.
- Add `Future<Task> swapIndexes(List<SwapIndex> swaps)` method to swap indexes.
- Add `Future<Task> cancelTasks({CancelTasksQuery? params})` to cancel tasks based on the input query params.
  - `CancelTasksQuery` has these fields:
    - `int? next;`
    - `DateTime? beforeEnqueuedAt;`
    - `DateTime? afterEnqueuedAt;`
    - `DateTime? beforeStartedAt;`
    - `DateTime? afterStartedAt;`
    - `DateTime? beforeFinishedAt;`
    - `DateTime? afterFinishedAt;`
    - `List<int> uids;`
    - `List<String> statuses;`
    - `List<String> types;`
    - `List<String> indexUids;`
- Add `Future<Task> deleteTasks({DeleteTasksQuery? params})` delete old processed tasks based on the input query params.
  - `DeleteTasksQuery` has these fields:
    - `int? next;`
    - `DateTime? beforeEnqueuedAt;`
    - `DateTime? afterEnqueuedAt;`
    - `DateTime? beforeStartedAt;`
    - `DateTime? afterStartedAt;`
    - `DateTime? beforeFinishedAt;`
    - `DateTime? afterFinishedAt;`
    - `List<int> canceledBy;`
    - `List<int> uids;`
    - `List<String> statuses;`
    - `List<String> types;`
    - `List<String> indexUids;`



- `TasksQuery` has new fields, and some of them were renamed:
  - those fields were added:
    - `int? canceledBy;`
    - `DateTime? beforeEnqueuedAt;`
    - `DateTime? afterEnqueuedAt;`
    - `DateTime? beforeStartedAt;`
    - `DateTime? afterStartedAt;`
    - `DateTime? beforeFinishedAt;`
    - `DateTime? afterFinishedAt;`
    - `List<int> uids;`
  - those were renamed:
    - `List<String> statuses;` from `List<String> status;`
    - `List<String> types;` from `List<String> type;`
    - `List<String> indexUids;` from `List<String> indexUid;`



- Add support to `matchingStrategy` in the search `MeiliSearchIndex#search`.


This version makes this package compatible with Meilisearch v0.28.0 and newer

- `MeiliSearchClient#getDumpStatus` method was removed.
- `MeiliSearchClient#getIndexes` method now return a object type `Result<MeiliSearchIndex>`.
- `TaskInfo`, `TaskImpl`, `ClientTaskImpl` are now just `Task`.
  - The method `getStatus` was removed in the new class.
- `MeiliSearchClient#generateTenantToken` now require a `String uid` which is the `uid` of the `Key` instance used to sign the token.
- `MeiliSearchClient#createDump` now responds with `Task`.
- `MeiliSearchClient#getKeys` method now return a object type `Future<Result<Key>>`.
- `MeiliSearchClient#updateKey` now can just update a `description` and/or `name`.
- `MeiliSearchClient#getTasks` method now return a object type `Future<TasksResults>`.
- `MeiliSearchIndex#getTasks` method now return a object type `Future<TasksResults>`.
- `MeiliSearchIndex#search` `facetsDistribution` is now `facets`
- `MeiliSearchIndex#search` `matches` is now `showMatchesPosition`
- `MeiliSearchIndex#getDocuments` method now return a object type `Future<Result>`.
- `MeiliSearchIndex#getDocuments` method now accepts a object as a parameter and `offset`, `limit`, `attributesToRetrieve` were not longer accepted.
- `nbHits`, `exhaustiveNbHits`, `facetsDistribution`, `exhaustiveFacetsCount` were removed from `SearchResult`.
- Remove unused generic `T` in `MeiliSearchClient#search` method


- `MeiliSearchClient#getIndexes` accepts a object `IndexesQuery` to filter and paginate the results.
- `MeiliSearchClient#getKeys` accepts a object `KeysQuery` to filter and paginate the results.
- `MeiliSearchClient#getKey` accepts both a `Key#uid` or `Key#key` value.
- `MeiliSearchClient#getTasks` accepts a object `TasksQuery` to filter and paginate the results.
- `MeiliSearchIndex#getTasks` accepts a object `TasksQuery` to filter and paginate the results.
- `MeiliSearchClient#createKey` can specify a `uid` (optionally) to create a new `Key`.
- `MeiliSearchIndex#getDocuments` accepts a object `DocumentsQuery` to filter and paginate the results.
- `Key` has now a `name` and `uid` string fields.
- `MeiliSearchIndex#getDocument` accepts a list of fields to reduce the final payload.
- `estimatedTotalHits`, `facetDistribution` were added to `SearchResult`
- Sending a invalid `uid` or `apiKey` will raise `InvalidApiKeyException` in the `generateTenantToken`.


This version makes this package compatible with Meilisearch v0.27.0 and newer

- Ensure nested field support (#157) @brunoocasali
- Add `highlightPreTag`, `highlightPostTag`, `cropMarker`, parameters in the search request (#156) @brunoocasali
- Fix syntax issue in the README (#162) @mafreud


- * Added new method `generateTenantToken()` as a result of the addition of the multi-tenant functionality.
This method creates a JWT tenant token that will allow the user to have multi-tenant indexes and thus restrict access to documents based on the end-user making the search request. (#139) @brunoocasali


- Add `User-Agent` header to have analytics in every http request (#129) @brunoocasali


This version makes this package compatible with Meilisearch v0.25.0 and newer

- Add method to responds with raw information from API `client.getRawIndex` (#124) @brunoocasali
- Run a `pub upgrade` in dependencies (#128) @brunoocasali
- Add support to keys (according to v0.25.0 spec) [more](https://docs.meilisearch.com/reference/api/keys.html#keys) (#121) @brunoocasali
  - Create a new resource class `Key` to represent keys
  - Create methods to support keys:
    - `client.getKeys`
    - `client.getKey`
    - `client.createKey`
    - `client.updateKey`
    - `client.deleteKey`
- Add PATCH method support (#121) @brunoocasali
- Updates regarding code samples:
  - setting guide sortable (#117) @alallema
  - added all the changed methods based on the new version v0.25.0 (#126) @brunoocasali


- Remove `getOrCreate` from `MeiliSearchClient` (#119) @brunoocasali
- Rename `PendingUpdate` to `TaskInfo` (#123) @brunoocasali
- Meilisearch v0.25.0 uses `Authorization` header instead of `X-Meili-API-Key` (#121) @brunoocasali
- Multiple naming changes regarding the v0.25.0 upgrade (#119, #120, #125, #127) @brunoocasali:
  - `client.getUpdateStatus` to `client.getTask`
  - `client.getAllUpdateStatus` to `client.getTasks`
  - `client.getKeys` responds with a `Future<List<Key>>` not `Future<Map<String, String>>`
  - `index.update`, `index.delete`, `client.createIndex`, `client.deleteIndex` and `client.updateIndex` now responds with `Future<TaskInfo>`
  - `index.getAllUpdateStatus` to `index.getTasks`
  - `index.getUpdateStatus` to `index.getTask`


- Rename `errorCode`, `errorType` and `errorLink` into `code`, `type` and `link` in the error handler (#110) @curquiza
- Changes related to the next Meilisearch release (v0.24.0) (#109)


- Add json content type by default as header to make it compatible with Meilisearch v0.23.0 (#89) @curquiza


- Fixed cropLength type (#79) @sanders41
- Fix distinctAttribute in settings (#77) @sanders41
- Changes related to the next Meilisearch release (v0.22.0) (#82)
  - Added sortable attributes (#83) @sanders41
  - Add `sort` parameter (#84) @curquiza


This version makes this package compatible with Meilisearch v0.21.0

- Update PendingUpdateX (#62) @alallema
- Adding option to specify a connectTimeout duration (#59) @sanders41
- Adding getKeys method (#66) @sanders41
- Adding dump methods (#67) @sanders41
- Adding getVersion method (#68) @sanders41
- Adding sub-settings methods (#70) @sanders41
- Adding index.getStats and client.getStats methods (#69) @sanders41
- Adding getAllUpdateStatus and getUpdateStatus methods (#73) @sanders41

- Rename attributes_for_faceting into filterable_attributes (#61) @alallema
- Rename Filters into Filter (#63) @alallema
- Rename attributes for faceting into filterable attributes (#71) @curquiza
- Changes related to the next Meilisearch release (v0.21.0) (#40)


- Changes due to the implicit index creation (#48) @alallema



- Add health method (#38) @alallema

- Null-safety migration (#42) @TheMisir
- Add an error handler (#36) @curquiza


- Upgrade dependencies


- Fix: Rename facetDistribution into facetsDistribution


- Add example project


- Fix image in pub.dev listing


- Initial stable release
- Write unit tests


- Implemented search endpoints
- Implemented settings endpoints
- Implemented document endpoints


- Initial pre-release
