# 0.5.2
- * Added new method `generateTenantToken()` as a result of the addition of the multi-tenant functionality.
This method creates a JWT tenant token that will allow the user to have multi-tenant indexes and thus restrict access to documents based on the end-user making the search request. (#139) @brunoocasali

# 0.5.1
- Add `User-Agent` header to have analytics in every http request (#129) @brunoocasali

# 0.5.0
This version makes this package compatible with Meilisearch v0.25.0 and newer
## Changes
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

### Breaking changes
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

# 0.4.0
- Rename `errorCode`, `errorType` and `errorLink` into `code`, `type` and `link` in the error handler (#110) @curquiza
- Changes related to the next Meilisearch release (v0.24.0) (#109)

# 0.3.2
- Add json content type by default as header to make it compatible with Meilisearch v0.23.0 (#89) @curquiza

# 0.3.1
- Fixed cropLength type (#79) @sanders41
- Fix distinctAttribute in settings (#77) @sanders41
- Changes related to the next Meilisearch release (v0.22.0) (#82)
  - Added sortable attributes (#83) @sanders41
  - Add `sort` parameter (#84) @curquiza

# 0.3.0
This version makes this package compatible with Meilisearch v0.21.0
### Changes
- Update PendingUpdateX (#62) @alallema
- Adding option to specify a connectTimeout duration (#59) @sanders41
- Adding getKeys method (#66) @sanders41
- Adding dump methods (#67) @sanders41
- Adding getVersion method (#68) @sanders41
- Adding sub-settings methods (#70) @sanders41
- Adding index.getStats and client.getStats methods (#69) @sanders41
- Adding getAllUpdateStatus and getUpdateStatus methods (#73) @sanders41
### Breaking changes
- Rename attributes_for_faceting into filterable_attributes (#61) @alallema
- Rename Filters into Filter (#63) @alallema
- Rename attributes for faceting into filterable attributes (#71) @curquiza
- Changes related to the next Meilisearch release (v0.21.0) (#40)

# 0.2.1
- Changes due to the implicit index creation (#48) @alallema

# 0.2.0
### Changes
- Add health method (#38) @alallema
### Breaking changes
- Null-safety migration (#42) @TheMisir
- Add an error handler (#36) @curquiza

# 0.1.3
- Upgrade dependencies

# 0.1.2
- Fix: Rename facetDistribution into facetsDistribution

# 0.1.1
- Add example project

# 0.1.0+1
- Fix image in pub.dev listing

# 0.1.0
- Initial stable release
- Write unit tests

# 0.0.3-pre
- Implemented search endpoints
- Implemented settings endpoints
- Implemented document endpoints

# 0.0.1-pre
- Initial pre-release
