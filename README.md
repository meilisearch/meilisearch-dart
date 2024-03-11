<p align="center">
  <img src="https://raw.githubusercontent.com/meilisearch/integration-guides/main/assets/logos/meilisearch_dart.svg" alt="Meilisearch" width="200" height="200" />
</p>

<h1 align="center">Meilisearch Dart</h1>

<h4 align="center">
  <a href="https://github.com/meilisearch/meilisearch">Meilisearch</a> |
<a href="https://www.meilisearch.com/cloud?utm_campaign=oss&utm_source=github&utm_medium=meilisearch-dart">Meilisearch Cloud</a> |
  <a href="https://www.meilisearch.com/docs">Documentation</a> |
  <a href="https://discord.meilisearch.com">Discord</a> |
  <a href="https://roadmap.meilisearch.com/tabs/1-under-consideration">Roadmap</a> |
  <a href="https://www.meilisearch.com">Website</a> |
  <a href="https://www.meilisearch.com/docs/faq">FAQ</a>
</h4>

<p align="center">
  <a href="https://pub.dev/packages/meilisearch"><img src="https://img.shields.io/pub/v/meilisearch" alt="Pub Version"></a>
  <a href="https://github.com/meilisearch/meilisearch-dart/actions"><img src="https://github.com/meilisearch/meilisearch-dart/workflows/Tests/badge.svg" alt="GitHub Workflow Status"></a>
  <a href="https://github.com/meilisearch/meilisearch-dart/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-informational" alt="License"></a>
  <a href="https://ms-bors.herokuapp.com/repositories/66"><img src="https://bors.tech/images/badge_small.svg" alt="Bors enabled"></a>
  <a href="https://codecov.io/gh/meilisearch/meilisearch-dart"><img src="https://codecov.io/gh/meilisearch/meilisearch-dart/branch/main/graph/badge.svg" alt="Code Coverage"></a>
</p>

<p align="center">⚡ The Meilisearch API client written in Dart</p>

**Meilisearch Dart** is the Meilisearch API client for Dart and Flutter developers.

**Meilisearch** is an open-source search engine. [Learn more about Meilisearch.](https://github.com/meilisearch/meilisearch)

## Table of Contents <!-- omit from toc -->

- [📖 Documentation](#-documentation)
- [⚡ Supercharge your Meilisearch experience](#-supercharge-your-meilisearch-experience)
- [🔧 Installation](#-installation)
- [🚀 Getting started](#-getting-started)
- [Advanced Configuration](#advanced-configuration)
  - [Customizing the dio instance](#customizing-the-dio-instance)
  - [Using MeiliDocumentContainer](#using-meilidocumentcontainer)
- [🤖 Compatibility with Meilisearch](#-compatibility-with-meilisearch)
- [💡 Learn more](#-learn-more)
- [⚙️ Contributing](#️-contributing)

## 📖 Documentation

This readme contains all the documentation you need to start using this Meilisearch SDK.

For general information on how to use Meilisearch—such as our API reference, tutorials, guides, and in-depth articles—refer to our [main documentation website](https://www.meilisearch.com/docs/).


## ⚡ Supercharge your Meilisearch experience

Say goodbye to server deployment and manual updates with [Meilisearch Cloud](https://www.meilisearch.com/cloud?utm_campaign=oss&utm_source=github&utm_medium=meilisearch-dart). Get started with a 14-day free trial! No credit card required.

## 🔧 Installation

You can install the **meilisearch** package by adding a few lines into `pubspec.yaml` file.

```yaml
dependencies:
  meilisearch: ^0.16.0
```

Then open your terminal and update dart packages.

```bash
pub get
```

### Run Meilisearch <!-- omit in toc -->

There are many easy ways to [download and run a Meilisearch instance](https://www.meilisearch.com/docs/learn/getting_started/installation).

For example, using the `curl` command in your [Terminal](https://itconnect.uw.edu/learn/workshops/online-tutorials/web-publishing/what-is-a-terminal/):

```sh
#Install Meilisearch
curl -L https://install.meilisearch.com | sh

# Launch Meilisearch
./meilisearch --master-key=masterKey
```

NB: you can also download Meilisearch from **Homebrew** or **APT** or even run it using **Docker**.

## 🚀 Getting started

#### Add Documents <!-- omit in toc -->

```dart
import 'package:meilisearch/meilisearch.dart';

void main() async {
  var client = MeiliSearchClient('http://127.0.0.1:7700', 'masterKey');

  // An index is where the documents are stored.
  var index = client.index('movies');

  const documents = [
    { 'id': 1, 'title': 'Carol', 'genres': ['Romance', 'Drama'] },
    { 'id': 2, 'title': 'Wonder Woman', 'genres': ['Action', 'Adventure'] },
    { 'id': 3, 'title': 'Life of Pi', 'genres': ['Adventure', 'Drama'] },
    { 'id': 4, 'title': 'Mad Max: Fury Road', 'genres': ['Adventure', 'Science Fiction'] },
    { 'id': 5, 'title': 'Moana', 'genres': ['Fantasy', 'Action']},
    { 'id': 6, 'title': 'Philadelphia', 'genres': ['Drama'] },
  ]

  // If the index 'movies' does not exist, Meilisearch creates it when you first add the documents.
  var task = await index.addDocuments(documents); // => { "uid": 0 }
}
```

With the `uid`, you can check the status (`enqueued`, `canceled`, `processing`, `succeeded` or `failed`) of your documents addition using the [task](https://www.meilisearch.com/docs/learn/advanced/asynchronous_operations#task-status).

#### Basic Search <!-- omit in toc -->

```dart
// Meilisearch is typo-tolerant:
var result = await index.search('carlo');

print(result.hits);
```

JSON Output:

```json
[
  {
    "id": 1,
    "title": "Carol",
    "genres": ["Romance", "Drama"]
  }
]
```

#### Custom Search <!-- omit in toc -->

All the supported options are described in the [search parameters](https://www.meilisearch.com/docs/reference/api/search#search-parameters) section of the documentation.

```dart
var result = await index.search(
  'carol',
  attributesToHighlight: ['title'],
);
```

JSON output:

```json
{
    "hits": [
        {
            "id": 1,
            "title": "Carol",
            "_formatted": {
                "id": 1,
                "title": "<em>Carol</em>"
            }
        }
    ],
    "offset": 0,
    "limit": 20,
    "processingTimeMs": 0,
    "query": "carol"
}
```

#### Custom Search With Filters <!-- omit in toc -->

If you want to enable filtering, you must add your attributes to the `filterableAttributes` index setting.

```dart
await index.updateFilterableAttributes(['id', 'genres']);
```

You only need to perform this operation once.

Note that MeiliSearch will rebuild your index whenever you update `filterableAttributes`.
Depending on the size of your dataset, this might take time. You can track the process using the [task status](https://www.meilisearch.com/docs/learn/advanced/asynchronous_operations#task-status).

Then, you can perform the search:

```dart
await index.search('wonder', filter: ['id > 1 AND genres = Action']);
```

```json
{
  "hits": [
    {
      "id": 2,
      "title": "Wonder Woman",
      "genres": ["Action","Adventure"]
    }
  ],
  "offset": 0,
  "limit": 20,
  "estimatedTotalHits": 1,
  "processingTimeMs": 0,
  "query": "wonder"
}
```

## Advanced Configuration

### Customizing the dio instance

Meilisearch uses [dio](https://pub.dev/packages/dio) internally to send requests, you can provide it with your own interceptors or adapter using the `MeiliSearchClient.withCustomDio` constructor.

### Using MeiliDocumentContainer

The `MeiliDocumentContainer<T>` class contains meilisearch-specific fields (e.g. `rankingScoreDetails`, `_formatted`, `matchesPosition`, etc...).

We define the `mapToContainer()` extension to help you quickly opt-in to this class, example:

```dart
final res = await index 
      .search("hello world") 
      .asSearchResult() //or .asPaginatedResult() if using page parameters
      .mapToContainer(); 
```

## 🤖 Compatibility with Meilisearch

This package guarantees compatibility with [version v1.x of Meilisearch](https://github.com/meilisearch/meilisearch/releases/tag/latest), but some features may not be present. Please check the [issues](https://github.com/meilisearch/meilisearch-dart/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22+label%3Aenhancement) for more info.

⚠️ This package is not compatible with the [`vectoreStore` experimental feature](https://www.meilisearch.com/docs/learn/experimental/vector_search) of Meilisearch v1.6.0 and later. More information on this [issue](https://github.com/meilisearch/meilisearch-dart/issues/369).

## 💡 Learn more

The following sections in our main documentation website may interest you:

- **Manipulate documents**: see the [API references](https://www.meilisearch.com/docs/reference/api/documents) or read more about [documents](https://www.meilisearch.com/docs/learn/core_concepts/documents).
- **Search**: see the [API references](https://www.meilisearch.com/docs/reference/api/search) or follow our guide on [search parameters](https://www.meilisearch.com/docs/reference/api/search#search-parameters).
- **Manage the indexes**: see the [API references](https://www.meilisearch.com/docs/reference/api/indexes) or read more about [indexes](https://www.meilisearch.com/docs/learn/core_concepts/indexes).
- **Configure the index settings**: see the [API references](https://www.meilisearch.com/docs/reference/api/settings) or follow our guide on [settings parameters](https://www.meilisearch.com/docs/learn/configuration/settings).

## ⚙️ Contributing

Any new contribution is more than welcome in this project!

If you want to know more about the development workflow or want to contribute, please visit our [contributing guidelines](./CONTRIBUTING.md) for detailed instructions!

<hr>

**Meilisearch** provides and maintains many **SDKs and Integration tools** like this one. We want to provide everyone with an **amazing search experience for any kind of project**. If you want to contribute, make suggestions, or just know what's going on right now, visit us in the [integration-guides](https://github.com/meilisearch/integration-guides) repository.
