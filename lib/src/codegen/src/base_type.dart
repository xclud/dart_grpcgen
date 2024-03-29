// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../protoc.dart';

/// Represents the base type of a particular field in a proto definition.
/// (Doesn't include List<> for repeated fields.)
class BaseType {
  factory BaseType(FieldDescriptorProto field, GenerationContext ctx) {
    String constSuffix;

    final nullable = field.proto3Optional;

    switch (field.type) {
      case FieldDescriptorProto_Type.typeBool:
        return BaseType._raw(FieldDescriptorProto_Type.typeBool, 'B',
            '$coreImportPrefix.bool', r'$_setBool', null, nullable);
      case FieldDescriptorProto_Type.typeFloat:
        return BaseType._raw(FieldDescriptorProto_Type.typeFloat, 'F',
            '$coreImportPrefix.double', r'$_setFloat', null, nullable);
      case FieldDescriptorProto_Type.typeDouble:
        return BaseType._raw(FieldDescriptorProto_Type.typeDouble, 'D',
            '$coreImportPrefix.double', r'$_setDouble', null, nullable);
      case FieldDescriptorProto_Type.typeInt32:
        return BaseType._raw(FieldDescriptorProto_Type.typeInt32, '3',
            '$coreImportPrefix.int', r'$_setSignedInt32', null, nullable);
      case FieldDescriptorProto_Type.typeUint32:
        return BaseType._raw(FieldDescriptorProto_Type.typeUint32, 'U3',
            '$coreImportPrefix.int', r'$_setUnsignedInt32', null, nullable);
      case FieldDescriptorProto_Type.typeSint32:
        return BaseType._raw(FieldDescriptorProto_Type.typeSint32, 'S3',
            '$coreImportPrefix.int', r'$_setSignedInt32', null, nullable);
      case FieldDescriptorProto_Type.typeFixed32:
        return BaseType._raw(FieldDescriptorProto_Type.typeFixed32, 'F3',
            '$coreImportPrefix.int', r'$_setUnsignedInt32', null, nullable);
      case FieldDescriptorProto_Type.typeSfixed32:
        return BaseType._raw(
          FieldDescriptorProto_Type.typeSfixed32,
          'SF3',
          '$coreImportPrefix.int',
          r'$_setSignedInt32',
          null,
          nullable,
        );
      case FieldDescriptorProto_Type.typeInt64:
        return BaseType._raw(FieldDescriptorProto_Type.typeInt64, '6',
            '$_fixnumImportPrefix.Int64', r'$_setInt64', null, nullable);
      case FieldDescriptorProto_Type.typeUint64:
        return BaseType._raw(FieldDescriptorProto_Type.typeUint64, 'U6',
            '$_fixnumImportPrefix.Int64', r'$_setInt64', null, nullable);
      case FieldDescriptorProto_Type.typeSint64:
        return BaseType._raw(FieldDescriptorProto_Type.typeSint64, 'S6',
            '$_fixnumImportPrefix.Int64', r'$_setInt64', null, nullable);
      case FieldDescriptorProto_Type.typeFixed64:
        return BaseType._raw(FieldDescriptorProto_Type.typeFixed64, 'F6',
            '$_fixnumImportPrefix.Int64', r'$_setInt64', null, nullable);
      case FieldDescriptorProto_Type.typeSfixed64:
        return BaseType._raw(FieldDescriptorProto_Type.typeSfixed64, 'SF6',
            '$_fixnumImportPrefix.Int64', r'$_setInt64', null, nullable);
      case FieldDescriptorProto_Type.typeString:
        return BaseType._raw(FieldDescriptorProto_Type.typeString, 'S',
            '$coreImportPrefix.String', r'$_setString', null, nullable);
      case FieldDescriptorProto_Type.typeBytes:
        return BaseType._raw(
          FieldDescriptorProto_Type.typeBytes,
          'Y',
          '$coreImportPrefix.List<$coreImportPrefix.int>',
          r'$_setBytes',
          null,
          nullable,
        );

      case FieldDescriptorProto_Type.typeGroup:
        constSuffix = 'G';
        break;
      case FieldDescriptorProto_Type.typeMessage:
        constSuffix = 'M';
        break;
      case FieldDescriptorProto_Type.typeEnum:
        constSuffix = 'E';
        break;

      default:
        throw ArgumentError('unimplemented type: ${field.type.name}');
    }

    var generator = ctx.getFieldType(field.typeName);
    if (generator == null) {
      throw 'FAILURE: Unknown type reference ${field.typeName}';
    }

    return BaseType._raw(field.type, constSuffix, generator.classname!, null,
        generator, nullable);
  }

  const BaseType._raw(
    this.descriptor,
    this.typeConstantSuffix,
    this.unprefixed,
    this.setter,
    this.generator,
    this.nullable,
  );

  final FieldDescriptorProto_Type descriptor;

  final bool nullable;

  /// The name of the Dart type when in the same package.
  final String unprefixed;

  /// The suffix of the constant for this type in PbFieldType.
  /// (For example, 'B' for boolean or '3' for int32.)
  final String typeConstantSuffix;

  // Method name of the setter method for this type.
  final String? setter;

  // The generator corresponding to this type.
  // (Null for primitive types.)
  final ProtobufContainer? generator;

  bool get isGroup => descriptor == FieldDescriptorProto_Type.typeGroup;
  bool get isMessage => descriptor == FieldDescriptorProto_Type.typeMessage;
  bool get isEnum => descriptor == FieldDescriptorProto_Type.typeEnum;
  bool get isString => descriptor == FieldDescriptorProto_Type.typeString;
  bool get isBytes => descriptor == FieldDescriptorProto_Type.typeBytes;
  bool get isPackable => (generator == null && !isString && !isBytes) || isEnum;

  /// The package where this type is declared.
  /// (Always the empty string for primitive types.)
  String get package => generator == null ? '' : generator!.package;

  /// The Dart expression to use for this type when in a different file.
  String get prefixed => generator == null
      ? unprefixed
      : '${generator!.fileImportPrefix}.$unprefixed';

  /// Returns the name to use in generated code for this Dart type.
  ///
  /// Doesn't include the List type for repeated fields.
  /// [FileGenerator.protoFileUri] represents the current proto file where we
  /// are generating code.
  /// The Dart class might be imported from a different proto file.
  String getDartType(FileGenerator fileGen) =>
      (fileGen.protoFileUri == generator?.fileGen?.protoFileUri)
          ? unprefixed
          : prefixed;

  String getNullableDartType(FileGenerator fileGen) =>
      (fileGen.protoFileUri == generator?.fileGen?.protoFileUri)
          ? _makeNullable(unprefixed)
          : _makeNullable(prefixed);

  String getRepeatedDartType(FileGenerator fileGen) =>
      '$coreImportPrefix.List<${getNullableDartType(fileGen)}>';

  String _makeNullable(String type) {
    if (nullable) {
      return '$type?';
    }
    return type;
  }
}
