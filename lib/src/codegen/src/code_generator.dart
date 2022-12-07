import 'package:protobuf/protobuf.dart';

import '../names.dart' show lowerCaseFirstLetter;
import '../protoc.dart' show FileGenerator;
import 'package:grpcgen/src/generated/dart_options.pb.dart';
import 'package:grpcgen/src/generated/descriptor.pb.dart';
import 'linker.dart';
import 'options.dart';
import 'output_config.dart';

abstract class ProtobufContainer {
  // Internal map of proto file URIs to prefix aliases to resolve name conflicts
  static final _importPrefixes = <String, String>{};
  static int _idx = 0;

  String get package;
  String? get classname;
  String get fullName;

  /// The field path contains the field IDs and indices (for repeated fields)
  /// that lead to the proto member corresponding to a piece of generated code.
  /// Repeated fields in the descriptor are further identified by the index of
  /// the message in question.
  /// For more information see
  /// https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/descriptor.proto#L728
  List<int>? get fieldPath;

  /// The fully qualified name with a leading '.'.
  ///
  /// This exists because names from protoc come like this.
  String get dottedName => '.$fullName';

  String get fileImportPrefix => _getFileImportPrefix();

  String get binaryDescriptorName =>
      '${lowerCaseFirstLetter(classname!)}Descriptor';

  String _getFileImportPrefix() {
    var path = fileGen!.protoFileUri.toString();
    if (_importPrefixes.containsKey(path)) {
      return _importPrefixes[path]!;
    }
    final alias = '\$$_idx';
    _importPrefixes[path] = alias;
    _idx++;
    return alias;
  }

  /// The generator of the .pb.dart file defining this entity.
  ///
  /// (Represents the .pb.dart file that we need to import in order to use it.)
  FileGenerator? get fileGen;

  // The generator containing this entity.
  ProtobufContainer? get parent;

  /// The top-level parent of this entity, or itself if it is a top-level
  /// entity.
  ProtobufContainer? get toplevelParent {
    if (parent == null) {
      return null;
    }
    if (parent is FileGenerator) {
      return this;
    }
    return parent?.toplevelParent;
  }
}

class CodeGenerator {
  CodeGenerator(
    this.protoFile, [
    this.options = const GenerationOptions(useGrpc: true),
  ]);
  final List<FileDescriptorProto> protoFile;
  final GenerationOptions options;

  /// Runs the code generator. The optional [optionParsers] can be used to
  /// change how command line options are parsed (see [parseGenerationOptions]
  /// for details), and [config] can be used to override where
  /// generated files are created and how imports between generated files are
  /// constructed (see [OutputConfiguration] for details).
  List<FileGenerator> generate(
      {Map<String, SingleOptionParser>? optionParsers,
      OutputConfiguration config = const DefaultOutputConfiguration()}) {
    var extensions = ExtensionRegistry();
    Dart_options.registerAllExtensions(extensions);

    // Create a syntax tree for each .proto file given to us.
    // (We may import it even if we don't generate the .pb.dart file.)
    var generators = <FileGenerator>[];
    for (var file in protoFile) {
      generators.add(FileGenerator(file, options));
    }

    // Collect field types and importable files.
    link(options, generators);

    return generators;
  }
}
