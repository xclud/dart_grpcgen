import 'dart:io';

import 'package:grpcgen/src/grpc/generated/google/protobuf/descriptor.pb.dart';
import 'package:grpcgen/grpcgen.dart' as grpcgen;

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
        exclusive: false,
      );

      await ff.writeAsString(f.toCode());
    }
  }

  exit(0);
}
