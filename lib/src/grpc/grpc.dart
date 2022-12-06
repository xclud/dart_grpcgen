import 'dart:async';
import 'dart:typed_data';

import 'package:grpcgen/src/grpc/generated/google/protobuf/descriptor.pb.dart';
import 'package:grpcgen/src/grpc/generated/reflection.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

final _channels = <String, ChannelApi>{};

/// DartDoc.
ChannelApi channel(Uri address) {
  _channels.putIfAbsent(address.toString(),
      () => ChannelApi._(address.host, address.hasPort ? address.port : 443));

  return _channels[address.toString()]!;
}

CallOptions? _getCallOptions() {
  // return CallOptions(metadata: {'Authorization': 'Bearer ${appState.token}'});
  return CallOptions();
}

/// DartDoc.
class ChannelApi {
  ChannelApi._(String address, int port)
      : _channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
          host: address,
          port: port,
          transportSecure: true,
        ) {
    _client = ServerReflectionClient(
      _channel,
    );
  }

  final GrpcOrGrpcWebClientChannel _channel;
  late final ServerReflectionClient _client;

  /// List Services.
  Future<List<String>> listServices() async {
    final stream = _client.serverReflectionInfo(
      Stream.value(ServerReflectionRequest(listServices: '')),
      options: _getCallOptions(),
    );

    var single = await stream.single;

    return single.listServicesResponse.service
        .where((e) => !e.name.startsWith('grpc.reflection'))
        .map((e) => e.name)
        .toList();
  }

  /// Get File Containing Symbol.
  Future<List<FileDescriptorProto>> fileContainingSymbol(String symbol) async {
    final stream = _client.serverReflectionInfo(
      Stream.value(ServerReflectionRequest(fileContainingSymbol: symbol)),
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
