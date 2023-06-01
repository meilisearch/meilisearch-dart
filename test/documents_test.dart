import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:meilisearch/src/result.dart';
import 'package:test/test.dart';
import 'utils/books_data.dart';
import 'utils/wait_for.dart';
import 'utils/client.dart';
import 'utils/books.dart';

const _customCSVDelimiter = ';';
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
        test('CSV with custom delimiter', () async {
          await index
              .addDocumentsCsv(
                dataAsCSV(data, delimiter: _customCSVDelimiter),
                primaryKey: kbookId,
                csvDelimiter: _customCSVDelimiter,
              )
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
        test('CSV With custom delimiter', () async {
          await index
              .updateDocumentsCsv(
                dataAsCSV(updateData, delimiter: _customCSVDelimiter),
                primaryKey: kbookId,
                csvDelimiter: _customCSVDelimiter,
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

          await expectLater(
            () => index.getDocument(456),
            throwsA(isA<MeiliSearchApiException>()),
          );
        });
        group('multiple documents', () {
          test('with Bad inputs', () async {
            final badObjects = [
              () => DeleteDocumentsQuery(),
              () => DeleteDocumentsQuery(ids: []),
              () => DeleteDocumentsQuery(ids: [132], filter: 'a = b'),
              () => DeleteDocumentsQuery(
                    ids: [132],
                    filterExpression: 'a'.toMeiliAttribute().eq(
                          'b'.toMeiliValue(),
                        ),
                  ),
              () => DeleteDocumentsQuery(
                    ids: [132],
                    filter: 'a = b',
                    filterExpression: 'a'.toMeiliAttribute().eq(
                          'b'.toMeiliValue(),
                        ),
                  ),
            ];

            for (var bad in badObjects) {
              await expectLater(
                () => index.deleteDocuments(bad()),
                throwsA(
                  isA<AssertionError>().having(
                    (p0) => p0.message,
                    "message",
                    "DeleteDocumentsQuery must contain either [ids] or [filter]/[filterExpression]",
                  ),
                ),
              );
            }
          });

          test('by ids', () async {
            await index
                .deleteDocuments(DeleteDocumentsQuery(ids: [456, 4]))
                .waitFor(client: client);

            await expectLater(
              () => index.getDocument(4),
              throwsA(isA<MeiliSearchApiException>()),
            );

            await expectLater(
              () => index.getDocument(456),
              throwsA(isA<MeiliSearchApiException>()),
            );
          });

          test('by filter', () async {
            const idsToDelete = [456, 4];
            //IMPORTANT, the book_id field must be added to filterable attributes
            await index
                .updateFilterableAttributes([kbookId]).waitFor(client: client);

            await index
                .deleteDocuments(
                  DeleteDocumentsQuery(
                    filterExpression: kbookId
                        .toMeiliAttribute()
                        .$in(idsToDelete.map(Meili.value).toList()),
                  ),
                )
                .waitFor(client: client);

            for (var id in idsToDelete) {
              await expectLater(
                () => index.getDocument(id),
                throwsA(isA<MeiliSearchApiException>()),
              );
            }
          });
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

        test('Fetch documents', () async {
          await index
              .updateFilterableAttributes([ktag]).waitFor(client: client);

          final docs = await index
              .getDocuments(
                params: DocumentsQuery(
                  limit: 5,
                  offset: 1,
                  filterExpression:
                      ktag.toMeiliAttribute().eq('Tale'.toMeiliValue()),
                ),
              )
              .map(BookDto.fromMap);

          expect(docs.total, 2);
          expect(docs.offset, 1);
          expect(docs.limit, 5);
          expect(docs.results.length, 1);
          expect(
            docs.results,
            everyElement(
              isA<BookDto>().having((p0) => p0.tag, "tag", equals('Tale')),
            ),
          );
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
        test('CSV with custom delimiter', () async {
          final tasks = await index.addDocumentsCsvInBatches(
            dataAsCSV(data, delimiter: _customCSVDelimiter),
            batchSize: batchSize,
            primaryKey: kbookId,
            csvDelimiter: _customCSVDelimiter,
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
        test('CSV with custom delimiter', () async {
          final tasks = await index.updateDocumentsCsvInBatches(
            dataAsCSV(updateData, delimiter: _customCSVDelimiter),
            batchSize: batchSize,
            primaryKey: kbookId,
            csvDelimiter: _customCSVDelimiter,
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
