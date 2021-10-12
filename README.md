<p align="center">
  <img src="https://raw.githubusercontent.com/meilisearch/integration-guides/main/assets/logos/meilisearch_dart.svg" alt="MeiliSearch" width="200" height="200" />
</p>

<h1 align="center">MeiliSearch Dart</h1>

<h4 align="center">
  <a href="https://github.com/meilisearch/MeiliSearch">MeiliSearch</a> |
  <a href="https://docs.meilisearch.com">Documentation</a> |
  <a href="https://slack.meilisearch.com">Slack</a> |
  <a href="https://roadmap.meilisearch.com/tabs/1-under-consideration">Roadmap</a> |
  <a href="https://www.meilisearch.com">Website</a> |
  <a href="https://docs.meilisearch.com/faq">FAQ</a>
</h4>

<p align="center">
  <a href="https://pub.dev/packages/meilisearch"><img src="https://img.shields.io/pub/v/meilisearch" alt="Pub Version"></a>
  <a href="https://github.com/meilisearch/meilisearch-dart/actions"><img src="https://github.com/meilisearch/meilisearch-dart/workflows/Tests/badge.svg" alt="GitHub Workflow Status"></a>
  <a href="https://github.com/meilisearch/meilisearch-dart/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-informational" alt="License"></a>
  <a href="https://app.bors.tech/repositories/30842"><img src="https://bors.tech/images/badge_small.svg" alt="Bors enabled"></a>
</p>

<p align="center">⚡ The MeiliSearch API client written in Dart</p>

**MeiliSearch Dart** is the MeiliSearch API client for Dart and Flutter developers.

**MeiliSearch** is an open-source search engine. [Discover what MeiliSearch is!](https://github.com/meilisearch/MeiliSearch)

## Table of Contents <!-- omit in toc -->

- [📖 Documentation](#-documentation)
- [🔧 Installation](#-installation)
- [🚀 Getting Started](#-getting-started)
- [🤖 Compatibility with MeiliSearch](#-compatibility-with-meilisearch)
- [💡 Learn More](#-learn-more)
- [⚙️ Development Workflow and Contributing](#️-development-workflow-and-contributing)

## 📖 Documentation

See our [Documentation](https://docs.meilisearch.com/learn/tutorials/getting_started.html) or our [API References](https://docs.meilisearch.com/reference/api/).

## 🔧 Installation

You can install the **meilisearch** package by adding a few lines into `pubspec.yaml` file.

```yaml
dependencies:
  meilisearch: ^0.3.1
```

Then open your terminal and update dart packages.

```bash
pub get
```

### Run MeiliSearch <!-- omit in toc -->

There are many easy ways to [download and run a MeiliSearch instance](https://docs.meilisearch.com/reference/features/installation.html#download-and-launch).

For example, if you use Docker:

```bash
docker pull getmeili/meilisearch:latest # Fetch the latest version of MeiliSearch image from Docker Hub
docker run -it --rm -p 7700:7700 getmeili/meilisearch:latest ./meilisearch --master-key=masterKey
```

NB: you can also download MeiliSearch from **Homebrew** or **APT**.

## 🚀 Getting Started

#### Add Documents <!-- omit in toc -->

```dart
import 'package:meilisearch/meilisearch.dart';

void main() async {
  var client = MeiliSearchClient('http://127.0.0.1:7700', 'masterKey');

  // An index is where the documents are stored.
  var index = client.index('movies');

  const documents = [
    { id: 1, title: 'Carol', genres: ['Romance', 'Drama'] },
    { id: 2, title: 'Wonder Woman', genres: ['Action', 'Adventure'] },
    { id: 3, title: 'Life of Pi', genres: ['Adventure', 'Drama'] },
    { id: 4, title: 'Mad Max: Fury Road', genres: ['Adventure', 'Science Fiction'] },
    { id: 5, title: 'Moana', genres: ['Fantasy', 'Action']},
    { id: 6, title: 'Philadelphia', genres: ['Drama'] },
  ]

  // If the index 'movies' does not exist, MeiliSearch creates it when you first add the documents.
  var update = await index.addDocuments(documents); // => { "updateId": 0 }
}
```

With the `updateId`, you can check the status (`enqueued`, `processing`, `processed` or `failed`) of your documents addition using the [update endpoint](https://docs.meilisearch.com/reference/api/updates.html#get-an-update-status).

#### Basic Search <!-- omit in toc -->

```dart
// MeiliSearch is typo-tolerant:
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

## 🤖 Compatibility with MeiliSearch

This package only guarantees the compatibility with the [version v0.23.0 of MeiliSearch](https://github.com/meilisearch/MeiliSearch/releases/tag/v0.23.0).

## 💡 Learn More

The following sections may interest you:

- **Manipulate documents**: see the [API references](https://docs.meilisearch.com/reference/api/documents.html) or read more about [documents](https://docs.meilisearch.com/learn/core_concepts/documents.html).
- **Search**: see the [API references](https://docs.meilisearch.com/reference/api/search.html) or follow our guide on [search parameters](https://docs.meilisearch.com/reference/features/search_parameters.html).
- **Manage the indexes**: see the [API references](https://docs.meilisearch.com/reference/api/indexes.html) or read more about [indexes](https://docs.meilisearch.com/learn/core_concepts/indexes.html).
- **Configure the index settings**: see the [API references](https://docs.meilisearch.com/reference/api/settings.html) or follow our guide on [settings parameters](https://docs.meilisearch.com/reference/features/settings.html).

## ⚙️ Development Workflow and Contributing

Any new contribution is more than welcome in this project!

If you want to know more about the development workflow or want to contribute, please visit our [contributing guidelines](./CONTRIBUTING.md) for detailed instructions!

<hr>

**MeiliSearch** provides and maintains many **SDKs and Integration tools** like this one. We want to provide everyone with an **amazing search experience for any kind of project**. If you want to contribute, make suggestions, or just know what's going on right now, visit us in the [integration-guides](https://github.com/meilisearch/integration-guides) repository.
