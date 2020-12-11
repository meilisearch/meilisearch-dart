<p align="center">
  <img src="https://raw.githubusercontent.com/TheMisir/meilisearch-dart/master/assets/logo.svg" alt="MeiliSearch" width="200" height="200" />
</p>

<h1 align="center">MeiliSearch Dart (WIP ⚠️)</h1>

<h4 align="center">
  <a href="https://github.com/meilisearch/MeiliSearch">MeiliSearch</a> |
  <a href="https://docs.meilisearch.com">Documentation</a> |
  <a href="https://roadmap.meilisearch.com/tabs/1-under-consideration">Roadmap</a> |
  <a href="https://www.meilisearch.com">Website</a> |
  <a href="https://blog.meilisearch.com">Blog</a> |
  <a href="https://twitter.com/meilisearch">Twitter</a> |
  <a href="https://docs.meilisearch.com/faq">FAQ</a>
</h4>

<p align="center">
  <a href="https://pub.dev/packages/meilisearch"><img src="https://img.shields.io/pub/v/meilisearch" alt="Pub Version"></a>
  <a href="https://github.com/themisir/meilisearch-dart/actions"><img src="https://github.com/themisir/meilisearch-dart/workflows/Tests/badge.svg?branch=master" alt="GitHub Workflow Status"></a>
  <a href="https://github.com/themisir/meilisearch-dart/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-informational" alt="License"></a>
  <a href="https://slack.meilisearch.com"><img src="https://img.shields.io/badge/slack-MeiliSearch-blue.svg?logo=slack" alt="Slack"></a>
</p>

<p align="center">⚡ The MeiliSearch API client written for Dart</p>

**MeiliSearch Dart** is the MeiliSearch API client for Dart developers. Which you can also use for your Flutter apps as well. **MeiliSearch** is a powerful, fast, open-source, easy to use and deploy search engine. Both searching and indexing are highly customizable. Features such as typo-tolerance, filters, facets, and synonyms are provided out-of-the-box.

## 📖 Documentation

See our [Documentation](https://docs.meilisearch.com/guides/introduction/quick_start_guide.html) or our [API References](https://docs.meilisearch.com/references/).

## 🔧 Installation

You can install **meilisearch** package by adding a few lines into `pubspec.yaml` file.

```yaml
dependencies:
  meilisearch: ">=0.0.1 <2.0.0"
```

Then open your terminal and update dart packages.

```bash
$ pub get
```

### Run MeiliSearch

There are many easy ways to [download and run a MeiliSearch instance](https://docs.meilisearch.com/guides/advanced_guides/installation.html#download-and-launch).

For example, if you use Docker:

```bash
$ docker pull getmeili/meilisearch:latest # Fetch the latest version of MeiliSearch image from Docker Hub
$ docker run -it --rm -p 7700:7700 getmeili/meilisearch:latest ./meilisearch --master-key=masterKey
```

NB: you can also download MeiliSearch from **Homebrew** or **APT**.

## 🚀 Getting Started

#### Add Documents

```dart
import 'package:meilisearch/meilisearch.dart';

void main() async {
  var client = MeiliSearchClient('http://127.0.0.1:7700', 'masterKey');

  // An index where books are stored.
  var index = await client.createIndex('books', primaryKey: 'book_id');

  var documents = [
    { 'book_id': 123,  'title': 'Pride and Prejudice' },
    { 'book_id': 456,  'title': 'Le Petit Prince' },
    { 'book_id': 1,    'title': 'Alice In Wonderland' },
    { 'book_id': 1344, 'title': 'The Hobbit' },
    { 'book_id': 4,    'title': 'Harry Potter and the Half-Blood Prince' },
    { 'book_id': 42,   'title': 'The Hitchhiker\'s Guide to the Galaxy' }
  ];

  // Add documents into index we just created.
  var update = await index.addDocuments(documents);
}
```

#### Basic Search

```dart
// MeiliSearch is typo-tolerant:
var result = await index.search('harry pottre');

print(result.hits);
```

Output:

```
[
  {
    "book_id": 4,
    "title": "Harry Potter and the Half-Blood Prince"
  }
]
```

#### Custom Search

All the supported options are described in the search parameters section of the documentation.

```dart
var result = index.search(
  'prince',
  attributesToHighlight: ['title'],
  filters: 'book_id > 10',
);
```
