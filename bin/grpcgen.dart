import 'dart:io';
import 'package:args/args.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;

import 'package:grpcgen/src/grpc/grpc.dart' as grpcgen;
import 'package:grpcgen/src/codegen/protoc.dart';
import 'package:grpcgen/src/codegen/src/output_config.dart';

void main(List<String> arguments) async {
  final parser = ArgParser();

  parser.addOption(
    'host',
    abbr: 'h',
    mandatory: true,
    help: 'Url to the web server with gRPC Reflection.',
    valueHelp: 'https://example.com',
  );
  parser.addOption(
    'output',
    abbr: 'o',
    mandatory: false,
    help: 'Output directory to put the generated files.',
    valueHelp: 'lib/grpc/generated',
    defaultsTo: 'lib/grpc/generated/',
  );

  try {
    final results = parser.parse(arguments);
    final host = results['host'] as String;
    final output = (results['output'] as String?) ?? 'lib/grpc/generated/';

    final url = Uri.tryParse(host);

    if (url == null) {
      print(parser.usage);
      print('Invalid host url.');
      exit(-1);
    }
    try {
      await generate(url, output);
      exit(0);
    } catch (exp) {
      print(exp);
      exit(-1);
    }
  } catch (exp) {
    print(parser.usage);
  }
}

Future<void> generate(Uri url, String output) async {
  final client = grpcgen.channel(url);
  final services = await client.listServices();

  final generators = <FileGenerator>{};

  for (final service in services) {
    final fileDescriptors = await client.fileContainingSymbol(service);

    final generator = CodeGenerator(fileDescriptors);
    generators.addAll(generator.generate());
  }

  final config = const DefaultOutputConfiguration();

  for (final gen in generators) {
    final files = gen.generateFiles(config);

    for (var file in files) {
      final filePath = path.join(output, file.file);
      final formatted = DartFormatter().format(file.content);
      final fileHandle = await File(filePath).create(
        recursive: true,
      );

      await fileHandle.writeAsString(formatted);
      print("Generated '${file.file}'.");
    }
  }

  print("Saved to '$output'.");
}
