import 'dart:io';
import 'package:dart_style/dart_style.dart';

import 'package:grpcgen/src/codegen/file_descriptor_proto_extension.dart';
import 'package:grpcgen/src/grpc/grpc.dart' as grpcgen;

void main(List<String> arguments) async {
  final url = arguments[0];
  // final dir = arguments[1];

  // print(url);
  // print(dir);

  final client = grpcgen.channel(Uri.parse(url));
  final services = await client.listServices();

  try {
    for (final service in services) {
      final fileDescriptors = await client.fileContainingSymbol(service);

      for (final fileDescriptor in fileDescriptors) {
        final name = fileDescriptor.name.replaceAll('.proto', '.dart');

        final fileHandle = await File('lib/grpc/generated/$name').create(
          recursive: true,
        );

        final source = fileDescriptor.toCode();
        final formatted = DartFormatter().format(source);

        await fileHandle.writeAsString(formatted);
      }
    }
    exit(0);
  } catch (exp) {
    print(exp);
    exit(-1);
  }
}
