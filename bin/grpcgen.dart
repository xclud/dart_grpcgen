import 'dart:io';
import 'package:dart_style/dart_style.dart';

import 'package:grpcgen/src/grpc/grpc.dart' as grpcgen;
import 'package:grpcgen/src/codegen/protoc.dart';
import 'package:grpcgen/src/codegen/src/output_config.dart';

void main(List<String> arguments) async {
  final url = arguments[0];
  // final dir = arguments[1];

  // print(url);
  // print(dir);

  final client = grpcgen.channel(Uri.parse(url));
  final services = await client.listServices();

  try {
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
        final formatted = DartFormatter().format(file.content);
        final fileHandle = await File('lib/grpc/generated/${file.file}').create(
          recursive: true,
        );

        await fileHandle.writeAsString(formatted);
        print("Generated '${file.file}'.");
      }
    }

    exit(0);
  } catch (exp) {
    print(exp);
    exit(-1);
  }
}
