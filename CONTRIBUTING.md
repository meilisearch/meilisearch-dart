# Contributing <!-- omit in TOC -->

First of all, thank you for contributing to Meilisearch! The goal of this document is to provide everything you need to know in order to contribute to Meilisearch and its different integrations.

- [Assumptions](#assumptions)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Git Guidelines](#git-guidelines)
- [Release Process (for the internal team only)](#release-process-for-the-internal-team-only)

## Assumptions

1. **You're familiar with [GitHub](https://github.com) and the [Pull Request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) (PR) workflow.**
2. **You've read the Meilisearch [documentation](https://www.meilisearch.com/docs) and the [README](/README.md).**
3. **You know about the [Meilisearch community](https://discord.com/invite/meilisearch). Please use this for help.**

## How to Contribute

1. Make sure that the contribution you want to make is explained or detailed in a GitHub issue! Find an [existing issue](https://github.com/meilisearch/meilisearch-dart/issues/) or [open a new one](https://github.com/meilisearch/meilisearch-dart/issues/new).
2. Once done, [fork the meilisearch-dart repository](https://help.github.com/en/github/getting-started-with-github/fork-a-repo) in your own GitHub account. Ask a maintainer if you want your issue to be checked before making a PR.
3. [Create a new Git branch](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-and-deleting-branches-within-your-repository).
4. Review the [Development Workflow](#development-workflow) section that describes the steps to maintain the repository.
5. Make the changes on your branch.
6. [Submit the branch as a PR](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork) pointing to the `main` branch of the main meilisearch-dart repository. A maintainer should comment and/or review your Pull Request within a few days. Although depending on the circumstances, it may take longer.<br>
 We do not enforce a naming convention for the PRs, but **please use something descriptive of your changes**, having in mind that the title of your PR will be automatically added to the next [release changelog](https://github.com/meilisearch/meilisearch-dart/releases/).

## Development Workflow

### Requirements <!-- omit in TOC -->

Install the official [Dart SDK](https://dart.dev/get-dart) or the [Flutter SDK](https://flutter.dev/docs/get-started/install) (which includes Dart SDK) using guides on the official website.

Both of them include `pub`.

### Setup <!-- omit in TOC -->

You can set up your local environment natively or using `docker`, check out the [`docker-compose.yml`](/docker-compose.yml).

Example of running all the checks with docker:
```bash
docker-compose run --rm package bash -c "dart pub get && dart pub get -C tool && dart run test --concurrency=4 && dart analyze && dart format . --set-exit-if-changed"
```

To install dependencies:

```bash
dart pub get
dart pub get -C tool
```

This package relies on [build_runner](https://pub.dev/packages/build_runner) to generate serialization information for some models, to re-generate files after making any changes, run:

```bash
dart run build_runner build
```

### Tests and Linter <!-- omit in TOC -->

Each PR should pass the tests and the linter to be accepted.

```bash
# Tests
curl -L https://install.meilisearch.com | sh # download Meilisearch
./meilisearch --master-key=masterKey --no-analytics # run Meilisearch
dart test
# Linter
dart analyze
```

### Updating code samples

Some PRs require updating the code samples (found in `.code-samples.meilisearch.yaml`), this is done automatically using code excerpts, which are actual pieces of code subject to testing and linting.

A lot of them are placed in `test/code_samples.dart`.

Also most of the tests in that file are skipped, since they are mostly duplicated in other test files.

The process to define a new code sample is as follows:
1. Add the piece of code in `test/code_samples.dart`
2. surround it with `#docregion key` and `#enddocregion`, e.g.
    ```
    // #docregion meilisearch_contributing_1
    final client = MeilisearchClient();
    anything();
    // #enddocregion
    ```
3. run this command to update the code samples
    ```bash
    dart run ./tool/bin/meili.dart update-samples
    ```
4. to test if the code samples are updated correctly, run:
    ```bash
    dart run ./tool/bin/meili.dart update-samples --fail-on-change
    ```

### Run integration tests for embedders

Integration tests for embedders are located in `test/search_test.dart`

#### OpenAI Model Integration
The tests utilize OpenAI models for embedding functionalities. Ensure you have a valid OpenAI API key to run these tests.

- Generate an OpenAI API Key
- Provide the API Key in one of two ways:
  - Pass the key via environment variable: `export OPEN_AI_API_KEY=your_openai_api_key` (will not work on dart web)
  - Pass the key via dart define: `dart --define=OPEN_AI_API_KEY=your_openai_api_key test --use-data-isolate-strategy` (Works on both web and native)

## Git Guidelines

### Git Branches <!-- omit in TOC -->

All changes must be made in a branch and submitted as PR.
We do not enforce any branch naming style, but please use something descriptive of your changes.

### Git Commits <!-- omit in TOC -->

As minimal requirements, your commit message should:
- be capitalized
- not finish by a dot or any other punctuation character (!,?)
- start with a verb so that we can read your commit message this way: "This commit will ...", where "..." is the commit message.
  e.g.: "Fix the home page button" or "Add more tests for create_index method"

We don't follow any other convention, but if you want to use one, we recommend [this one](https://chris.beams.io/posts/git-commit/).

### GitHub Pull Requests <!-- omit in TOC -->

Some notes on GitHub PRs:

- [Convert your PR as a draft](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/changing-the-stage-of-a-pull-request) if your changes are a work in progress: no one will review it until you pass your PR as ready for review.<br>
  The draft PR can be very useful if you want to show that you are working on something and make your work visible.
- All PRs must be reviewed and approved by at least one maintainer.
- The PR title should be accurate and descriptive of the changes. The title of the PR will be indeed automatically added to the next [release changelogs](https://github.com/meilisearch/meilisearch-dart/releases/).

## Release Process (for the internal team only)

Meilisearch tools follow the [Semantic Versioning Convention](https://semver.org/).

### Automated Changelogs <!-- omit in TOC -->

This project integrates a tool to create automated changelogs.<br>
_[Read more about this](https://github.com/meilisearch/integration-guides/blob/main/resources/release-drafter.md)._

### How to Publish the Release <!-- omit in TOC -->

⚠️ Before doing anything, make sure you got through the guide about [Releasing an Integration](https://github.com/meilisearch/integration-guides/blob/main/resources/integration-release.md).


Make a PR modifying the version in:

- the file [`lib/src/version.dart:2`](./lib/src/version.dart).

```dart
static const String current = 'X.X.X';
```

- the file [`pubspec.yaml`](./pubspec.yaml).

```yaml
version: X.X.X
```

- the file [`README.md` in the Installation section](./README.md):

```yaml
dependencies:
  meilisearch: ^X.X.X
```

Also in this PR, update the [CHANGELOG.md](./CHANGELOG.md) file with the description of the next release.

Once the changes are merged on `main`, you can publish the current draft release via the [GitHub interface](https://github.com/meilisearch/meilisearch-dart/releases): on this page, click on `Edit` (related to the draft release) > update the description (be sure you apply [these recommendations](https://github.com/meilisearch/integration-guides/blob/main/resources/integration-release.md#writting-the-release-description)) > when you are ready, click on `Publish release`.

A GitHub Action will be triggered and push the package to [pub.dev](https://pub.dev/packages/meilisearch/).

<hr>

Thank you again for reading this through. We can not wait to begin to work with you if you make your way through this contributing guide ❤️
