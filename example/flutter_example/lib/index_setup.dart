import 'package:faker/faker.dart';
import 'package:meilisearch/meilisearch.dart';

import 'person.dart';

Future<MeiliSearchIndex> initIndex({required MeiliSearchClient client}) async {
  const indexUid = "people";
  try {
    return await client.getIndex(indexUid);
  } on MeiliSearchApiException catch (e) {
    if (e.code == 'index_not_found') {
      final task =
          await client.createIndex(indexUid, primaryKey: PersonDto.kid);
      //Usually you would need to await for the task to complete, see https://github.com/meilisearch/meilisearch-dart/issues/260
      await Future.delayed(const Duration(milliseconds: 100));
      final res = client.index(indexUid);
      return res;
    } else {
      rethrow;
    }
  }
}

Future<void> seedFakePeople({
  required Faker faker,
  required MeiliSearchIndex? index,
  int count = 100,
}) async {
  if (index == null) return;
  final task = await index.addDocuments(
    Iterable.generate(
      100,
      (index) {
        final id = faker.guid.guid();
        final name = faker.person.name();
        //we duplicate the name to simulate cases where there are multiple highlights
        return PersonDto(id: id, name: "$name $name");
      },
    ).map((e) => e.toMap()).toList(),
    primaryKey: PersonDto.kid,
  );
  //Usually you would need to await for the task to complete, see https://github.com/meilisearch/meilisearch-dart/issues/260
  await Future.delayed(const Duration(milliseconds: 100));
}
