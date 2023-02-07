import 'dart:async';
import 'dart:typed_data';

import 'package:grpcgen/src/grpc/generated/descriptor.dart';
import 'package:grpcgen/src/grpc/generated/reflection_v1.dart' as v1;
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

final _channels = <String, ChannelApi>{};

/// DartDoc.
ChannelApi channel(Uri address, String version) {
  final key = '$version::$address';

  return _channels.putIfAbsent(
    key,
    () => ChannelApi._(
      address.host,
      address.hasPort ? address.port : 443,
      version,
    ),
  );
}

CallOptions? _getCallOptions() {
  // return CallOptions(metadata: {'Authorization': 'Bearer ${appState.token}'});
  return CallOptions();
}

/// DartDoc.
class ChannelApi {
  ChannelApi._(String address, int port, this.version)
      : _channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
          host: address,
          port: port,
          transportSecure: true,
        ) {
    _client = v1.ServerReflectionClient(
      _channel,
      version,
    );
  }

  final GrpcOrGrpcWebClientChannel _channel;
  late final v1.ServerReflectionClient _client;
  final String version;

  /// List Services.
  Future<List<String>> listServices(bool includeReflection) async {
    final stream = _client.serverReflectionInfo(
      Stream.value(v1.ServerReflectionRequest()..listServices = ''),
      options: _getCallOptions(),
    );

    var single = await stream.single;

    if (includeReflection) {
      return single.listServicesResponse.service.map((e) => e.name).toList();
    }

    return single.listServicesResponse.service
        .where((e) => !e.name.startsWith('grpc.reflection'))
        .map((e) => e.name)
        .toList();
  }

  /// Get File Containing Symbol.
  Future<List<FileDescriptorProto>> fileContainingSymbol(String symbol) async {
    final stream = _client.serverReflectionInfo(
      Stream.value(v1.ServerReflectionRequest()..fileContainingSymbol = symbol),
      options: _getCallOptions(),
    );

    var single = await stream.single;

    return single.fileDescriptorResponse.fileDescriptorProto
        .map((e) => FileDescriptorProto.fromBuffer(e))
        .toList();
  }

  /// DartDoc.
  ClientCall<Uint8List, Uint8List> unary(
    String path,
    Uint8List data, {
    Map<String, String>? metadata,
  }) {
    final method = ClientMethod<Uint8List, Uint8List>(
        path,
        (Uint8List value) => Uint8List.fromList(value),
        (List<int> value) => Uint8List.fromList(value));

    final call = _channel.createCall(
        method, Stream.value(data), CallOptions(metadata: metadata));

    return call;
  }

  /// DartDoc.
  ClientCall<Uint8List, Uint8List> stream(
      String path, Stream<Uint8List> stream) {
    final method = ClientMethod<Uint8List, Uint8List>(
        path,
        (Uint8List value) => Uint8List.fromList(value),
        (List<int> value) => Uint8List.fromList(value));

    final call =
        _channel.createCall(method, stream, _getCallOptions() ?? CallOptions());

    return call;
  }
}
