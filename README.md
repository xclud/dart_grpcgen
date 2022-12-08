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

Install the latest version of the tool globally, exposing the CLI on the command line:

```bash
dart pub global activate grpcgen
```

Usage:

```bash
grpcgen -h https://example.com
```

To install the tool as a dev dependency in your current project:

Add `grpcgen` package in your `dev_dependencies`:

```yaml
dev_dependencies:
# dart run grpcgen -h https://example.com
  grpcgen: any
```

> Note: This package should not be added to `dependencies`.

Usage:

```bash
dart run grpcgen -h https://example.com
```

## Usage

-h, --host=<https://example.com> (mandatory)    Url to the web server with gRPC Reflection.

-o, --output=<lib/grpc/generated>               Output directory to put the generated files (defaults to "lib/grpc/generated/").

-s, --schema=<v1>                               The schema to use, either v1alpha or v1 (defaults to "v1alpha").

-r, --[no-]reflection                           If set, reflection code is also generated.
