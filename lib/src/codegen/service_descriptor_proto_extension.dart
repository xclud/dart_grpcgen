import 'package:grpcgen/src/codegen/method_descriptor_proto_extension.dart';
import 'package:grpcgen/src/grpc/generated/google/protobuf/descriptor.pb.dart';
import 'package:recase/recase.dart';

extension ServiceDescriptorProtoCodeGen on ServiceDescriptorProto {
  String toCode(Map<String, DescriptorProto> messages) {
    final lines = <String>[];

    final n = _pascal(name);

    lines.add('/// ${n}Client');
    lines.add('class ${n}Client extends \$grpc.Client {');
    lines.add('\t/// Constructor.');
    lines.add(
        '\t${n}Client(\$grpc.ClientChannel channel, {\$grpc.CallOptions? options, \$core.Iterable<\$grpc.ClientInterceptor>? interceptors,}) : super(channel, options: options, interceptors: interceptors,);');
    lines.add('');

    for (int i = 0; i < method.length; i++) {
      final m = method[i];

      lines.add(m.toCode(messages));
      lines.add('');
    }

    lines.removeLast();

    lines.add('}');

    return lines.join('\r\n');
  }
}

String _pascal(String name) {
  return ReCase(name).pascalCase;
}
