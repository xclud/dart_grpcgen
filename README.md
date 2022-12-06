[![pub package](https://img.shields.io/pub/v/grpcgen)](https://pub.dartlang.org/packages/grpcgen)
[![likes](https://img.shields.io/pub/likes/grpcgen)](https://pub.dartlang.org/packages/grpcgen/score)
[![points](https://img.shields.io/pub/points/grpcgen)](https://pub.dartlang.org/packages/grpcgen/score)
[![popularity](https://img.shields.io/pub/popularity/grpcgen)](https://pub.dartlang.org/packages/grpcgen/score)
[![license](https://img.shields.io/github/license/xclud/dart_grpcgen)](https://pub.dartlang.org/packages/grpcgen)
[![stars](https://img.shields.io/github/stars/xclud/dart_grpcgen)](https://github.com/xclud/dart_grpcgen/stargazers)
[![forks](https://img.shields.io/github/forks/xclud/dart_grpcgen)](https://github.com/xclud/dart_grpcgen/network/members)
[![sdk version](https://badgen.net/pub/sdk-version/grpcgen)](https://pub.dartlang.org/packages/grpcgen)

Code generator for gRPC Client from gRPC Reflection.

> Note: Requires Dart 2.17 or above.

## Get Started

Add `grpcgen` package in your `dev_dependencies`:

```yaml
dev_dependencies:
  grpcgen: any
```

> Note: This package should not be added to `dependencies`.

In order to generate gRPC Client code from server reflection run this command:

```bash
dart run grpcgen https://example-domain.com
```

The generated files can be found in `lib/grpc/generated/` path.
