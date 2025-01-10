import 'dart:io';
import 'command_base.dart';
import 'result.dart';

const _failOnChangeFlag = 'fail-on-change';
const _checkRemoteRepoFlag = 'check-remote-repo';
const _generateMissingExcerpts = 'generate-missing-excerpts';

final RegExp _startRegionRegex = RegExp(r'//\s*#docregion\s+(\w+)');
final RegExp _endRegionRegex = RegExp(r'//\s*#enddocregion\s+(\w+)');

/// Command to update code samples in the documentation.
class UpdateSamplesCommand extends PackageCommand {
  UpdateSamplesCommand()
      : super(
          name: 'update-samples',
          description: 'Updates code samples in the documentation.',
        ) {
    argParser
      ..addFlag(
        _failOnChangeFlag,
        help: 'Fail if any changes are needed.',
        defaultsTo: false,
      )
      ..addFlag(
        _checkRemoteRepoFlag,
        help: 'Check remote repository for changes.',
        defaultsTo: false,
      )
      ..addFlag(
        _generateMissingExcerpts,
        help: 'Generate missing code excerpts.',
        defaultsTo: false,
      );
  }

  @override
  Future<PackageResult> run() async {
    final failOnChange = argResults?[_failOnChangeFlag] as bool? ?? false;
    final generateMissing = argResults?[_generateMissingExcerpts] as bool? ?? false;

    final workingDir = Directory.current;

    try {
      final changes = await _processFiles(workingDir, generateMissing);

      if (changes.isEmpty) {
        return PackageResult.success();
      }

      if (failOnChange) {
        return PackageResult.failure('Changes needed in the following files:\n${changes.join('\n')}');
      }

      return PackageResult.success();
    } catch (e) {
      return PackageResult.failure(e.toString());
    }
  }

  Future<List<String>> _processFiles(Directory dir, bool generateMissing) async {
    final changes = <String>[];
    final files = await dir.list(recursive: true).where((entity) =>
      entity is File && entity.path.endsWith('.dart')).toList();

    for (final file in files) {
      if (await _processFile(file as File, generateMissing)) {
        changes.add(file.path);
      }
    }

    return changes;
  }

  Future<bool> _processFile(File file, bool generateMissing) async {
    final content = await file.readAsString();
    final lines = content.split('\n');
    bool changed = false;

    // Process docregions
    final regions = <String, List<String>>{};
    String? currentRegion;
    final regionLines = <String>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final startMatch = _startRegionRegex.firstMatch(line);

      if (startMatch != null) {
        currentRegion = startMatch.group(1);
        regionLines.clear();
        continue;
      }

      final endMatch = _endRegionRegex.firstMatch(line);
      if (endMatch != null && currentRegion != null) {
        regions[currentRegion] = List.from(regionLines);
        currentRegion = null;
        continue;
      }

      if (currentRegion != null) {
        regionLines.add(line);
      }
    }

    return changed;
  }
}
