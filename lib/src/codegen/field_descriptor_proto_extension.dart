import 'package:grpcgen/src/grpc/generated/google/protobuf/descriptor.pb.dart';
import 'package:recase/recase.dart';

/// DartDoc.
extension FieldDescriptorProtoCodeGen on FieldDescriptorProto {
  /// DartDoc.
  String toCode() {
    final lines = <String>[];

    final n = _camel(name);
    final p = _title(name);

    lines.add('/// $p.');
    lines.add('set $n(\$core.Object? value) {}');
    lines.add('');
    lines.add('/// $p.');
    lines.add('\$core.Object? get $n => null;');

    return lines.map((e) => '\t$e').join('\r\n');
  }
}

String _camel(String name) {
  return ReCase(name).camelCase;
}

String _title(String name) {
  return ReCase(name).titleCase;
}
