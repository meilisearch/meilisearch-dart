import 'package:args/command_runner.dart';
import 'result.dart';

/// Base class for package commands.
abstract class PackageCommand extends Command<PackageResult> {
  @override
  final String name;

  @override
  final String description;

  PackageCommand({
    required this.name,
    required this.description,
  });

  @override
  Future<PackageResult> run();
}
