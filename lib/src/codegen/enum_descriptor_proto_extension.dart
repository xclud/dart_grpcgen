import 'package:grpcgen/src/grpc/generated/google/protobuf/descriptor.pb.dart';
import 'package:recase/recase.dart';

extension EnumDescriptorProtoCodeGen on EnumDescriptorProto {
  String toCode() {
    final lines = <String>[];

    lines.add('/// $name');
    lines.add('enum $name {');

    for (int i = 0; i < value.length; i++) {
      final v = value[i];
      final separator = i == value.length - 1 ? ';' : ',';
      final vn = _camel(v.name);

      lines.add('\t/// $vn (${v.number})');
      lines.add('\t$vn(${v.number})$separator');
      lines.add('');
    }

    lines.add('\t/// $name Constructor.');
    lines.add('\tconst $name(this.value);');
    lines.add('');
    lines.add('\t/// The number of gRPC enum item.');
    lines.add('\tfinal \$core.int value;');
    lines.add('}');

    return lines.join('\r\n');
  }
}

String _camel(String name) {
  return ReCase(name).camelCase;
}
