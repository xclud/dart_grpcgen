// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

typedef OnError = void Function(String details);

/// Options expected by the protoc code generation compiler.
class GenerationOptions {
  const GenerationOptions({
    this.useGrpc = false,
    this.generateMetadata = false,
  });

  final bool useGrpc;
  final bool generateMetadata;
}

/// A parser for a name-value pair option. Options parsed in
/// [genericOptionsParser] delegate to instances of this class to
/// parse the value of a specific option.
abstract class SingleOptionParser {
  /// Parse the [name]=[value] value pair and report any errors to [onError]. If
  /// the option is a flag, [value] will be null. Note, [name] is commonly
  /// unused. It is provided because [SingleOptionParser] can be registered for
  /// multiple option names in [genericOptionsParser].
  void parse(String name, String? value, OnError onError);
}

class GrpcOptionParser implements SingleOptionParser {
  bool grpcEnabled = false;

  @override
  void parse(String name, String? value, OnError onError) {
    if (value != null) {
      onError('Invalid grpc option. No value expected.');
      return;
    }
    grpcEnabled = true;
  }
}

class GenerateMetadataParser implements SingleOptionParser {
  bool generateKytheInfo = false;

  @override
  void parse(String name, String? value, OnError onError) {
    if (value != null) {
      onError('Invalid metadata option. No value expected.');
      return;
    }
    generateKytheInfo = true;
  }
}
