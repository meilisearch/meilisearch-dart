<p align="center">
  <img src="https://raw.githubusercontent.com/meilisearch/integration-guides/main/assets/logos/meilisearch_dart.svg" alt="Meilisearch" width="200" height="200" />
</p>

<h1 align="center">Meilisearch Dart</h1>

<h4 align="center">
  <a href="https://github.com/meilisearch/meilisearch">Meilisearch</a> |
  <a href="https://docs.meilisearch.com">Documentation</a> |
  <a href="https://discord.meilisearch.com">Discord</a> |
  <a href="https://roadmap.meilisearch.com/tabs/1-under-consideration">Roadmap</a> |
  <a href="https://www.meilisearch.com">Website</a> |
  <a href="https://docs.meilisearch.com/faq">FAQ</a>
</h4>

<p align="center">
  <a href="https://pub.dev/packages/meilisearch"><img src="https://img.shields.io/pub/v/meilisearch" alt="Pub Version"></a>
  <a href="https://github.com/meilisearch/meilisearch-dart/actions"><img src="https://github.com/meilisearch/meilisearch-dart/workflows/Tests/badge.svg" alt="GitHub Workflow Status"></a>
  <a href="https://github.com/meilisearch/meilisearch-dart/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-informational" alt="License"></a>
  <a href="https://ms-bors.herokuapp.com/repositories/66"><img src="https://bors.tech/images/badge_small.svg" alt="Bors enabled"></a>
</p>

<p align="center">⚡ The Meilisearch API client written in Dart</p>

**Meilisearch Dart** is the Meilisearch API client for Dart and Flutter developers.

**Meilisearch** is an open-source search engine. [Learn more about Meilisearch.](https://github.com/meilisearch/meilisearch)

## Table of Contents <!-- omit in toc -->

- [📖 Documentation](#-documentation)
- [🔧 Installation](#-installation)
- [🚀 Getting started](#-getting-started)
- [🤖 Compatibility with Meilisearch](#-compatibility-with-meilisearch)
- [💡 Learn more](#-learn-more)
- [⚙️ Contributing](#️-contributing)

## 📖 Documentation

This readme contains all the documentation you need to start using this Meilisearch SDK.

For general information on how to use Meilisearch—such as our API reference, tutorials, guides, and in-depth articles—refer to our [main documentation website](https://docs.meilisearch.com/).


## 🔧 Installation

You can install the **meilisearch** package by adding a few lines into `pubspec.yaml` file.

```yaml
dependencies:
  meilisearch: ^0.11.1
```

Then open your terminal and update dart packages.

```bash
pub get
```

### Run Meilisearch <!-- omit in toc -->

There are many easy ways to [download and run a Meilisearch instance](https://docs.meilisearch.com/reference/features/installation.html#download-and-launch).

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

With the `uid`, you can check the status (`enqueued`, `processing`, `succeeded` or `failed`) of your documents addition using the [task](https://docs.meilisearch.com/reference/api/tasks.html#get-task).

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

All the supported options are described in the [search parameters](https://docs.meilisearch.com/reference/features/search_parameters.html) section of the documentation.

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
Depending on the size of your dataset, this might take time. You can track the process using the [task status](https://docs.meilisearch.com/reference/api/tasks.html#get-an-update-status).

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

## 🤖 Compatibility with Meilisearch

This package guarantees compatibility with [version v1.x of Meilisearch](https://github.com/meilisearch/meilisearch/releases/tag/latest), but some features may not be present. Please check the [issues](https://github.com/meilisearch/meilisearch-dart/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22+label%3Aenhancement) for more info.

:warning: This package also can work with the [version v0.29.0 of Meilisearch](https://github.com/meilisearch/meilisearch/releases/tag/v1.0.0), but you may notice some missing features. Check [the issues page](https://github.com/meilisearch/meilisearch-dart/issues) for more information.

## 💡 Learn more

The following sections in our main documentation website may interest you:

- **Manipulate documents**: see the [API references](https://docs.meilisearch.com/reference/api/documents.html) or read more about [documents](https://docs.meilisearch.com/learn/core_concepts/documents.html).
- **Search**: see the [API references](https://docs.meilisearch.com/reference/api/search.html) or follow our guide on [search parameters](https://docs.meilisearch.com/reference/features/search_parameters.html).
- **Manage the indexes**: see the [API references](https://docs.meilisearch.com/reference/api/indexes.html) or read more about [indexes](https://docs.meilisearch.com/learn/core_concepts/indexes.html).
- **Configure the index settings**: see the [API references](https://docs.meilisearch.com/reference/api/settings.html) or follow our guide on [settings parameters](https://docs.meilisearch.com/reference/features/settings.html).

## ⚙️ Contributing

Any new contribution is more than welcome in this project!

If you want to know more about the development workflow or want to contribute, please visit our [contributing guidelines](./CONTRIBUTING.md) for detailed instructions!

<hr>

**Meilisearch** provides and maintains many **SDKs and Integration tools** like this one. We want to provide everyone with an **amazing search experience for any kind of project**. If you want to contribute, make suggestions, or just know what's going on right now, visit us in the [integration-guides](https://github.com/meilisearch/integration-guides) repository.
