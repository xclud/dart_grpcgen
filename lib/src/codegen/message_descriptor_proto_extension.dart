import 'package:grpcgen/src/codegen/field_descriptor_proto_extension.dart';
import 'package:grpcgen/src/grpc/generated/google/protobuf/descriptor.pb.dart';
import 'package:recase/recase.dart';

/// DartDoc.
extension DescriptorProtoCodeGen on DescriptorProto {
  /// DartDoc.
  String toCode(String package) {
    final lines = <String>[];

    final n = _pascal(name);

    lines.add('/// $n');
    lines.add('class $n extends \$pb.GeneratedMessage {');
    lines.add('\t/// Public Constructor.');
    lines.add('\t$n();');
    lines.add('');
    lines.add('\t/// Private Constructor.');
    lines.add('\t$n._();');
    lines.add('');
    lines.add(_builderInfo(package));
    lines.add('');
    lines.add('\t/// Create.');
    lines.add('\tstatic $n create() => $n._();');
    lines.add('');

    lines.add('\t@\$core.override');
    lines.add('\t$n createEmptyInstance() => create();');
    lines.add('');
    lines.add('\t@\$core.override');
    lines.add('\t$n clone() => $n()..mergeFromMessage(this);');
    lines.add('');
    lines.add('\t@\$core.override');
    lines.add('\t\$pb.BuilderInfo get info_ => _i;');

    lines.add('');

    for (var f in field) {
      lines.add(f.toCode());
      lines.add('');
    }

    lines.removeLast();

    lines.add('}');

    return lines.join('\r\n');
  }

  String _builderInfo(String package) {
    final lines = <String>[];
    final n = _pascal(name);

    lines.add('\t/// Builder Info.');
    lines.add(
        "\tstatic final _i = \$pb.BuilderInfo('$n', package: \$pb.PackageName('$package'), createEmptyInstance: create,);");

    return lines.join('\r\n');
  }
}

String _pascal(String name) {
  return ReCase(name).pascalCase;
}
