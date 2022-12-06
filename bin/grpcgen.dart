import 'dart:io';
import 'package:dart_style/dart_style.dart';

import 'package:grpcgen/src/codegen/file_descriptor_proto_extension.dart';
import 'package:grpcgen/src/grpc/generated/google/protobuf/descriptor.pb.dart';
import 'package:grpcgen/src/grpc/grpc.dart' as grpcgen;

void main(List<String> arguments) async {
  final url = arguments[0];
  // final dir = arguments[1];

  // print(url);
  // print(dir);

  final client = grpcgen.channel(Uri.parse(url));
  final services = await client.listServices();

  final files = <String, FileDescriptorProto>{};

  for (final service in services) {
    final fi = await client.fileContainingSymbol(service);

    for (final f in fi) {
      files[f.name] = f;
      final name = f.name.replaceAll('.proto', '.dart');

      final ff = await File('lib/grpc/generated/$name').create(
        recursive: true,
      );

      final source = f.toCode();
      final formatted = DartFormatter().format(source);

      await ff.writeAsString(formatted);
    }
  }

  exit(0);
}
