[![pub package](https://img.shields.io/pub/v/grpcgen)](https://pub.dartlang.org/packages/grpcgen)
[![likes](https://img.shields.io/pub/likes/grpcgen)](https://pub.dartlang.org/packages/grpcgen/score)
[![points](https://img.shields.io/pub/points/grpcgen)](https://pub.dartlang.org/packages/grpcgen/score)
[![popularity](https://img.shields.io/pub/popularity/grpcgen)](https://pub.dartlang.org/packages/grpcgen/score)
[![license](https://img.shields.io/github/license/xclud/dart_grpcgen)](https://pub.dartlang.org/packages/grpcgen)
[![stars](https://img.shields.io/github/stars/xclud/dart_grpcgen)](https://github.com/xclud/dart_grpcgen/stargazers)
[![forks](https://img.shields.io/github/forks/xclud/dart_grpcgen)](https://github.com/xclud/dart_grpcgen/network/members)
[![sdk version](https://badgen.net/pub/sdk-version/grpcgen)](https://pub.dartlang.org/packages/grpcgen)

Command-line application for code generation for gRPC clients from gRPC Reflection.

> Note: Requires Dart 2.17 or above.

## Get Started

### Install as a global tool

To install grpcgen as a global tool, run:

```bash
dart pub global activate grpcgen
```

### Install as a project dependency

Add `grpcgen` package in your `dev_dependencies`:

```yaml
dev_dependencies:
  grpcgen: any
```

> Note: This package should not be added to `dependencies`.

In order to generate gRPC Client code from server reflection, run:

```bash
dart run grpcgen https://example-domain.com
```

## Output

If everything goes well in the previews section, the outputs will be generated.
The generated files can be found in `lib/grpc/generated/`.
