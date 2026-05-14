# AGENTS.md

This repository provides a `docker-compose.yml` that lets you develop and run tests without installing Dart and Meilisearch locally.

## Commands

Run commands with `docker compose run --rm package bash -c "<command>"`:
- Format code `dart format .`
- Run tests `dart run test --concurrency=2`

## Workflow

- After changes, format code and run tests
