// Source: https://github.com/flutter/packages/blob/d0411e450a8d94fcb221e8d8eacd3b1f8ca0e2fc/script/tool/lib/src/update_excerpts_command.dart
// but modified to accept yaml files.

import 'dart:async';

import 'package:file/file.dart';
import 'package:meili_tool/src/command_base.dart';
import 'package:meili_tool/src/result.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

class _SourceFile {
  final File file;
  final List<String> contents;
  Map<String, String>? result;

  _SourceFile({
    required this.file,
    required this.contents,
  });
}

class UpdateSamplesCommand extends MeiliCommandBase {
  static const String _failOnChangeFlag = 'fail-on-change';

  UpdateSamplesCommand(
    super.packageDirectory, {
    super.platform,
  }) {
    argParser.addFlag(
      _failOnChangeFlag,
      help: 'Fail if the command does anything. '
          '(Used in CI to ensure excerpts are up to date.)',
    );
  }

  @override
  String get description =>
      'Updates .code-samples.meilisearch.yaml, based on code from code files';

  @override
  String get name => 'update-samples';

  static const docregion = '#docregion';
  static const enddocregion = '#enddocregion';
  final startRegionRegex = RegExp(RegExp.escape(docregion) + r'\s+(?<key>\w+)');

  @override
  Future<PackageResult> run() async {
    try {
      final failOnChange = getBoolArg(_failOnChangeFlag);
      //read the samples yaml file
      final changedKeys = <String, String>{};
      final File samplesFile =
          packageDirectory.childFile('.code-samples.meilisearch.yaml');
      final samplesContentRaw = await samplesFile.readAsString();
      final samplesYaml = loadYaml(samplesContentRaw);
      if (samplesYaml is! YamlMap) {
        print(samplesYaml.runtimeType);
        return PackageResult.fail(['samples yaml must be an YamlMap']);
      }
      final newSamplesYaml = YamlEditor(samplesContentRaw);
      final sourceFiles = await _discoverSourceFiles();
      for (var sourceFile in sourceFiles) {
        final newValues = _runInFile(sourceFile);
        sourceFile.result = newValues;
        for (var element in newValues.entries) {
          final existingValue = samplesYaml[element.key];
          if (existingValue != null) {
            if (existingValue == element.value) {
              continue;
            } else {
              changedKeys[element.key] = element.value;
            }
          } else {
            changedKeys[element.key] = element.value;
          }
        }
        if (failOnChange && changedKeys.isNotEmpty) {
          return PackageResult.fail([
            'found changed keys: ${changedKeys.keys.toList()}',
          ]);
        }
        if (!failOnChange) {
          for (var changedEntry in changedKeys.entries) {
            newSamplesYaml.update([changedEntry.key], changedEntry.value);
          }
        }
      }
      if (!failOnChange) {
        await samplesFile.writeAsString(newSamplesYaml.toString());
      }
      return PackageResult.success();
    } on PackageResult catch (e) {
      return e;
    }
  }

  Map<String, String> _runInFile(_SourceFile file) {
    int lineNumber = 0;
    String? currentKey;
    final keys = <String>[];
    final res = <String, String>{};
    final currentKeyLines = <MapEntry<int, String>>[];
    for (var line in file.contents) {
      lineNumber++;
      if (currentKey == null) {
        final capture = startRegionRegex.firstMatch(line);
        if (capture == null) {
          continue;
        }
        final key = capture.namedGroup('key');
        if (key == null) {
          throw PackageResult.fail(['found a #docregion with no key']);
        }
        if (keys.contains(key)) {
          throw PackageResult.fail(['found duplicate keys $key']);
        }
        keys.add(key);
        currentKey = key;
      } else {
        if (line.contains(enddocregion)) {
          final sb = StringBuffer();
          currentKeyLines.map((e) => e.value).forEach(sb.writeln);
          //add to results.
          res[currentKey] = sb.toString();
        } else {
          currentKeyLines.add(MapEntry(lineNumber, line));
        }
      }
    }
    return res;
  }

  Future<List<_SourceFile>> _discoverSourceFiles() async {
    final libDir = packageDirectory.childDirectory('lib');
    final testsDir = packageDirectory.childDirectory('test');
    //look in dart files and generate a new yaml file based on the referenced code.
    final allDartFiles = [
      ...libDir.listSync(recursive: true),
      ...testsDir.listSync(recursive: true),
    ].where((element) => element.basename.toLowerCase().endsWith('.dart'));

    final sourceFiles = <_SourceFile>[];
    for (var dartFile in allDartFiles) {
      if (dartFile is! File) {
        continue;
      }
      final fileContents = await dartFile.readAsLines();
      if (!fileContents.any((line) => line.contains(docregion))) {
        continue;
      }
      sourceFiles.add(
        _SourceFile(
          file: dartFile,
          contents: fileContents,
        ),
      );
    }
    return sourceFiles;
  }
}
