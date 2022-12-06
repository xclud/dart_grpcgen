import 'package:grpcgen/src/grpc/generated/google/protobuf/descriptor.pb.dart';
import 'package:recase/recase.dart';

extension MethodDescriptorProtoCodeGen on MethodDescriptorProto {
  String toCode(Map<String, DescriptorProto> messages) {
    final lines = <String>[];

    final n = _camel(name);
    final p = _title(name);

    lines.add('/// $p.');
    lines.add('///');
    lines.add('/// Input: [$inputType], Output: [$outputType]');
    lines.add('void $n() {}');

    return lines.map((e) => '\t$e').join('\r\n');
  }
}

String _camel(String name) {
  return ReCase(name).camelCase;
}

String _title(String name) {
  return ReCase(name).titleCase;
}
