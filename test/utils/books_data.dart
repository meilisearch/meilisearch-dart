import 'dart:convert';

const kbookId = 'book_id';
const ktitle = 'title';
const ktag = 'tag';
const kid = 'id';

List<Map<String, Object?>> dynamicBooks(int count) {
  final tags = List.generate(4, (index) => "Tag $index");
  return List.generate(
    count,
    (index) => {
      kbookId: index,
      ktitle: 'Book $index',
      ktag: tags[index % tags.length],
    },
  );
}

List<Map<String, Object?>> dynamicPartialBookUpdate(int count) {
  return List.generate(
    count,
    (index) {
      //shift index by 5 to simulate 5 non-existent book update
      index += 5;
      return {
        kbookId: index,
        ktitle: 'UPDATED Book $index',
      };
    },
  );
}

final partialBookUpdate = [
  {kbookId: 123, ktitle: 'UPDATED Pride and Prejudice'},
  {kbookId: 1344, ktitle: 'UPDATED The Hobbit'},
  //New book should be upserted
  {kbookId: 654, ktitle: 'UPDATED Not Le Petit Prince'},
];

final books = [
  {kbookId: 123, ktitle: 'Pride and Prejudice', ktag: 'Romance'},
  {kbookId: 456, ktitle: 'Le Petit Prince', ktag: 'Tale'},
  {kbookId: 1, ktitle: 'Alice In Wonderland', ktag: 'Tale'},
  {kbookId: 1344, ktitle: 'The Hobbit', ktag: 'Epic fantasy'},
  {
    kbookId: 4,
    ktitle: 'Harry Potter and the Half-Blood Prince',
    ktag: 'Epic fantasy'
  },
  {
    kbookId: 42,
    ktitle: 'The Hitchhiker\'s Guide to the Galaxy',
    ktag: 'Epic fantasy'
  },
  {kbookId: 9999, ktitle: 'The Hobbit', ktag: null},
];

final vectorBooks = [
  {
    "id": 0,
    "title": "Across The Universe",
    "_vectors": [0, 0.8, -0.2],
  },
  {
    "id": 1,
    "title": "All Things Must Pass",
    "_vectors": [1, -0.2, 0],
  },
  {
    "id": 2,
    "title": "And Your Bird Can Sing",
    "_vectors": [-0.2, 4, 6],
  },
  {
    "id": 3,
    "title": "The Matrix",
    "_vectors": [5, -0.5, 0.3],
  },
];

enum CSVHeaderTypes {
  string,
  boolean,
  number,
  unkown,
}

String dataAsCSV(List<Map<String, Object?>> data, {String delimiter = ','}) {
  final csvHeaders = <String, CSVHeaderTypes?>{};
  final csvDataBuffer = StringBuffer();
  for (final element in data) {
    for (final entry in element.entries) {
      if (!csvHeaders.containsKey(entry.key)) {
        final value = entry.value;
        if (value != null) {
          csvHeaders[entry.key] = value is String
              ? CSVHeaderTypes.string
              : value is num
                  ? CSVHeaderTypes.number
                  : value is bool
                      ? CSVHeaderTypes.boolean
                      : CSVHeaderTypes.unkown;
        }
      }
    }
  }
  final csvHeaderEntries = csvHeaders.entries.toList();

  data
      .map(
        (obj) => csvHeaderEntries
            .map((e) => e.key)
            .map((headerKey) => json.encode(obj[headerKey] ?? ""))
            .join(delimiter),
      )
      .forEach(csvDataBuffer.writeln);

  final headerStr = csvHeaders.entries.map((header) {
    final headerType = header.value;
    final typeStr = headerType == CSVHeaderTypes.number
        ? ':number'
        : headerType == CSVHeaderTypes.boolean
            ? ':boolean'
            : null;
    return jsonEncode('${header.key}${typeStr ?? ""}');
  }).join(delimiter);

  return '$headerStr\n${csvDataBuffer.toString()}';
}

String dataAsNDJson(List<Map<String, Object?>> data) {
  return data.map(jsonEncode).join("\n");
}

final nestedBooks = [
  {
    kid: 1,
    ktitle: 'Pride and Prejudice',
    "info": {
      "comment": 'A great book',
      "reviewNb": 500,
    },
  },
  {
    kid: 2,
    ktitle: 'Le Petit Prince',
    "info": {
      "comment": 'A french book',
      "reviewNb": 600,
    },
  },
  {
    kid: 3,
    ktitle: 'Le Rouge et le Noir',
    "info": {
      "comment": 'Another french book',
      "reviewNb": 700,
    },
  },
  {
    kid: 4,
    ktitle: 'Alice In Wonderland',
    "comment": 'A weird book',
    "info": {
      "comment": 'A weird book',
      "reviewNb": 800,
    },
  },
  {
    kid: 5,
    ktitle: 'The Hobbit',
    "info": {
      "comment": 'An awesome book',
      "reviewNb": 900,
    },
  },
  {
    kid: 6,
    ktitle: 'Harry Potter and the Half-Blood Prince',
    "info": {
      "comment": 'The best book',
      "reviewNb": 1000,
    },
  },
  {kid: 7, ktitle: "The Hitchhiker's Guide to the Galaxy"},
];
