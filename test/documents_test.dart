import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:test/test.dart';
import 'utils/books_data.dart';
import 'utils/wait_for.dart';
import 'utils/client.dart';
import 'utils/books.dart';

void main() {
  group('Documents', () {
    setUpClient();
    Future<void> testUpdatedDataGeneral({
      required MeiliSearchIndex index,
      required Set<int> totalIds,
      required List<Map<String, Object?>> originalData,
      required List<Map<String, Object?>> updateProposals,
    }) async {
      final docs = await index.getDocuments(
        params: DocumentsQuery(limit: totalIds.length + 10),
      );
      expect(docs.total, equals(totalIds.length));
      int updated = 0;
      for (var element in docs.results) {
        final matchingOriginal = originalData.firstWhereOrNull(
          (original) => original[kbookId] == element[kbookId],
        );
        final matchingProposal = updateProposals.firstWhereOrNull(
          (newProposal) => newProposal[kbookId] == element[kbookId],
        );
        expect(
          matchingOriginal != null || matchingProposal != null,
          equals(true),
        );
        //check that new title is equivalent to the update proposal
        if (matchingProposal != null) {
          expect(element[ktitle], equals(matchingProposal[ktitle]));
          updated++;
        }
        //check that new tag is equivalent to the original tag
        if (matchingOriginal != null) {
          expect(element[ktag], equals(matchingOriginal[ktag]));
        }
      }
      expect(updated, equals(updateProposals.length));
    }

    late MeiliSearchIndex index;
    setUp(() {
      index = client.index(randomUid());
    });
    tearDown(() async {
      await client.deleteIndex(index.uid);
    });
    group("Normal", () {
      final data = books;
      final totalCount = data.length;

      group("Add", () {
        Future<void> testAddedData() async {
          final docs = await index.getDocuments();
          expect(docs.total, totalCount);
          const itemEq = MapEquality<String, Object?>();
          final listEq = UnorderedIterableEquality(itemEq);
          expect(listEq.equals(docs.results, data), equals(true));
        }

        test('JSON raw', () async {
          await index
              .addDocumentsJson(jsonEncode(data))
              .waitFor(client: client);

          await testAddedData();
        });
        test('JSON raw with primary keys', () async {
          await index
              .addDocumentsJson(jsonEncode(data), primaryKey: kbookId)
              .waitFor(client: client);

          await testAddedData();
        });
        test('JSON parsed', () async {
          await index.addDocuments(data).waitFor(client: client);

          await testAddedData();
        });
        test('JSON parsed with primary key', () async {
          await index
              .addDocuments(books, primaryKey: kbookId)
              .waitFor(client: client);

          await testAddedData();
        });

        test('CSV', () async {
          final csvData = dataAsCSV(data);
          await index.addDocumentsCsv(csvData).waitFor(client: client);

          await testAddedData();
        });
        test('CSV with primary key', () async {
          await index
              .addDocumentsCsv(dataAsCSV(data), primaryKey: kbookId)
              .waitFor(client: client);

          await testAddedData();
        });

        test('NDJson', () async {
          await index
              .addDocumentsNdjson(dataAsNDJson(data))
              .waitFor(client: client);

          await testAddedData();
        });
        test('NDJson with primary key', () async {
          await index
              .addDocumentsNdjson(dataAsNDJson(data), primaryKey: kbookId)
              .waitFor(client: client);

          await testAddedData();
        });
      });

      group('Update', () {
        final originalData = books;
        final updateData = partialBookUpdate;
        final totalIds = originalData
            .map((e) => e[kbookId])
            .followedBy(updateData.map((e) => e[kbookId]))
            .whereType<int>()
            .toSet();

        Future<void> testUpdatedData() => testUpdatedDataGeneral(
              index: index,
              totalIds: totalIds,
              originalData: originalData,
              updateProposals: updateData,
            );

        setUp(() async {
          //seed the data
          index = await createBooksIndex(uid: index.uid);
        });

        test('JSON Raw', () async {
          await index
              .updateDocumentsJson(jsonEncode(updateData))
              .waitFor(client: client);

          await testUpdatedData();
        });
        test('JSON Raw With primary key', () async {
          await index
              .updateDocumentsJson(
                jsonEncode(updateData),
                primaryKey: kbookId,
              )
              .waitFor(client: client);

          await testUpdatedData();
        });

        test('JSON Parsed', () async {
          await index.updateDocuments(updateData).waitFor(client: client);

          await testUpdatedData();
        });
        test('JSON Parsed With primary key', () async {
          await index
              .updateDocuments(
                updateData,
                primaryKey: kbookId,
              )
              .waitFor(client: client);

          await testUpdatedData();
        });

        test('CSV', () async {
          await index
              .updateDocumentsCsv(dataAsCSV(updateData))
              .waitFor(client: client);

          await testUpdatedData();
        });
        test('CSV With primaryKey', () async {
          await index
              .updateDocumentsCsv(
                dataAsCSV(updateData),
                primaryKey: kbookId,
              )
              .waitFor(client: client);

          await testUpdatedData();
        });

        test('NDJson', () async {
          await index
              .updateDocumentsNdjson(dataAsNDJson(updateData))
              .waitFor(client: client);

          await testUpdatedData();
        });
        test('NDJson With primaryKey', () async {
          await index
              .updateDocumentsNdjson(
                dataAsNDJson(updateData),
                primaryKey: kbookId,
              )
              .waitFor(client: client);

          await testUpdatedData();
        });
      });

      group("Delete", () {
        setUp(() async {
          //seed the index
          index = await createBooksIndex(uid: index.uid);
        });
        test('one document', () async {
          await index.deleteDocument(456).waitFor(client: client);

          expect(
              index.getDocument(456), throwsA(isA<MeiliSearchApiException>()));
        });

        test('multiple documents', () async {
          await index.deleteDocuments([456, 4]).waitFor(client: client);

          expect(index.getDocument(4), throwsA(isA<MeiliSearchApiException>()));
          expect(
              index.getDocument(456), throwsA(isA<MeiliSearchApiException>()));
        });

        test('all documents', () async {
          await index.deleteAllDocuments().waitFor(client: client);

          final docs = await index.getDocuments();
          expect(docs.total, 0);
        });
      });
      group("Get", () {
        setUp(() async {
          index = await createBooksIndex();
        });
        test('documents with query params', () async {
          final docs = await index.getDocuments(
            params: DocumentsQuery(offset: 1, fields: [kbookId]),
          );

          expect(docs.total, equals(books.length));
          expect(docs.offset, equals(1));
          expect(docs.limit, greaterThan(0));
          expect(docs.results[0][kbookId], isNotNull);
          expect(docs.results[0][ktitle], isNull);
        });

        test('document with fields', () async {
          final doc = await index.getDocument(1, fields: [kbookId]);

          expect(doc?[kbookId], isNotNull);
          expect(doc?[ktitle], isNull);
        });
      });
    });
    group("Batched", () {
      group("Add", () {
        const batchSize = 10;
        const totalCount = (batchSize * 4) + 1;
        const chunks = 5;
        final List<Map<String, Object?>> data = dynamicBooks(totalCount);

        Future<void> testAddedBatches(List<Task> tasks) async {
          expect(tasks.length, chunks);
          await tasks.waitFor(client: client, timeout: Duration(seconds: 30));
          final docs = await index.getDocuments();
          expect(docs.total, totalCount);
        }

        test('JSON parsed', () async {
          final tasks = await index.addDocumentsInBatches(
            data,
            batchSize: batchSize,
          );

          await testAddedBatches(tasks);
        });
        test('JSON parsed with primary key', () async {
          final tasks = await index.addDocumentsInBatches(
            data,
            batchSize: batchSize,
            primaryKey: kbookId,
          );

          await testAddedBatches(tasks);
        });

        test('CSV', () async {
          final tasks = await index.addDocumentsCsvInBatches(
            dataAsCSV(data),
            batchSize: batchSize,
          );

          await testAddedBatches(tasks);
        });
        test('CSV with primary key', () async {
          final tasks = await index.addDocumentsCsvInBatches(
            dataAsCSV(data),
            batchSize: batchSize,
            primaryKey: kbookId,
          );

          await testAddedBatches(tasks);
        });

        test('NDJSON', () async {
          final tasks = await index.addDocumentsNdjsonInBatches(
            dataAsNDJson(data),
            batchSize: batchSize,
          );

          await testAddedBatches(tasks);
        });
        test('NDJSON with primary key', () async {
          final tasks = await index.addDocumentsNdjsonInBatches(
            dataAsNDJson(data),
            batchSize: batchSize,
            primaryKey: kbookId,
          );

          await testAddedBatches(tasks);
        });
      });

      group("Update", () {
        const batchSize = 10;
        const totalCount = (batchSize * 4) + 1;
        const chunks = 5;
        final originalData = dynamicBooks(totalCount);
        final updateData = dynamicPartialBookUpdate(totalCount);

        final totalIds = originalData
            .map((e) => e[kbookId])
            .followedBy(updateData.map((e) => e[kbookId]))
            .whereType<int>()
            .toSet();

        Future<void> testUpdatedBatches(List<Task> tasks) async {
          expect(tasks.length, chunks);
          await tasks.waitFor(client: client, timeout: Duration(seconds: 30));
          await testUpdatedDataGeneral(
            index: index,
            totalIds: totalIds,
            originalData: originalData,
            updateProposals: updateData,
          );
        }

        setUp(() async {
          index =
              await createDynamicBooksIndex(uid: index.uid, count: totalCount);
        });

        test('JSON parsed', () async {
          final tasks = await index.updateDocumentsInBatches(
            updateData,
            batchSize: batchSize,
          );

          await testUpdatedBatches(tasks);
        });
        test('JSON parsed with primary key', () async {
          final tasks = await index.updateDocumentsInBatches(
            updateData,
            batchSize: batchSize,
            primaryKey: kbookId,
          );

          await testUpdatedBatches(tasks);
        });

        test('CSV', () async {
          final tasks = await index.updateDocumentsCsvInBatches(
            dataAsCSV(updateData),
            batchSize: batchSize,
          );

          await testUpdatedBatches(tasks);
        });
        test('CSV with primary key', () async {
          final tasks = await index.updateDocumentsCsvInBatches(
            dataAsCSV(updateData),
            batchSize: batchSize,
            primaryKey: kbookId,
          );

          await testUpdatedBatches(tasks);
        });

        test('NDJSON', () async {
          final tasks = await index.updateDocumentsNdjsonInBatches(
            dataAsNDJson(updateData),
            batchSize: batchSize,
          );

          await testUpdatedBatches(tasks);
        });
        test('NDJSON with primary key', () async {
          final tasks = await index.updateDocumentsNdjsonInBatches(
            dataAsNDJson(updateData),
            batchSize: batchSize,
            primaryKey: kbookId,
          );

          await testUpdatedBatches(tasks);
        });
      });
    });
  });
}
