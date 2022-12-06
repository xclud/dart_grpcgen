import 'package:grpcgen/src/codegen/enum_descriptor_proto_extension.dart';
import 'package:grpcgen/src/codegen/message_descriptor_proto_extension.dart';
import 'package:grpcgen/src/codegen/service_descriptor_proto_extension.dart';
import 'package:grpcgen/src/grpc/generated/google/protobuf/descriptor.pb.dart';

/// DartDoc.
extension FileDescriptorProtoCodeGen on FileDescriptorProto {
  /// DartDoc.
  String toCode() {
    final lines = <String>[];
    final all = <String, DescriptorProto>{};

    for (var message in messageType) {
      all['.${message.name}'] = message;
    }

    lines.add('/// Generated Code - $name');
    if (service.isNotEmpty || messageType.isNotEmpty || enumType.isNotEmpty) {
      lines.add("import 'dart:core' as \$core;");
    }
    if (messageType.isNotEmpty) {
      lines.add("import 'package:protobuf/protobuf.dart' as \$pb;");
    }
    if (service.isNotEmpty) {
      lines.add("import 'package:grpc/grpc.dart' as \$grpc;");
    }

    // for (var dep in dependency) {
    //   final path = dep.replaceAll('.proto', '');
    //   final as = path.replaceAll('/', '_');
    //   lines.add("import '$path.dart' as $as;");
    // }

    lines.add('');

    if (service.isNotEmpty) {
      lines.add('// ------- Services -------');
      lines.add('');

      for (var svc in service) {
        lines.add(svc.toCode(all));
        lines.add('');
      }

      lines.removeLast();
    }

    lines.add('');

    if (messageType.isNotEmpty) {
      lines.add('// ------- Messages -------');
      lines.add('');

      for (var message in messageType) {
        lines.add(message.toCode(package));
        lines.add('');
      }

      lines.removeLast();
    }

    lines.add('');

    if (enumType.isNotEmpty) {
      lines.add('// ------- Enums -------');
      lines.add('');

      for (var enm in enumType) {
        lines.add(enm.toCode());
        lines.add('');
      }

      lines.removeLast();
    }

    lines.add('');
    return lines.join('\r\n');
  }
}
