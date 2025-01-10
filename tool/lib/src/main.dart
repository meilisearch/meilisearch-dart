import 'dart:io';

import 'package:args/command_runner.dart';
import 'output_utils.dart';
import 'result.dart';
import 'update_samples_command.dart';

Future<void> main(List<String> args) async {
  final runner = CommandRunner<PackageResult>(
    'meili',
    'Tool for managing Meilisearch Dart SDK.',
  );

  runner.addCommand(UpdateSamplesCommand());

  try {
    final result = await runner.run(args);
    if (result == null) {
      // help command or similar was run
      exit(0);
    }

    switch (result.state) {
      case RunState.success:
        printSuccess('Command completed successfully');
        exit(0);
      case RunState.failure:
        printError('Command failed');
        if (result.details.isNotEmpty) {
          printError('Details: ${result.details}');
        }
        exit(1);
    }
  } catch (e, stack) {
    printError('Unexpected error: $e\n$stack');
    exit(1);
  }
}
