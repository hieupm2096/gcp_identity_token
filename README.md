# Gcp Identity Token

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

# GCP Identity Token

A Dart package for obtaining Google Cloud Platform (GCP) identity tokens using either Application Default Credentials (ADC) or the GCP Metadata server. Designed for GCP backend services to solve the issue of inter-services interaction; for Flutter applications, consider alternative solutions.

## Getting Started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  gcp_identity_token: ^1.0.0
```

Then import it in your Dart code:

```dart
import 'package:gcp_identity_token/gcp_identity_token.dart';
```

## Usage

### Using Application Default Credentials (ADC)

```dart
final client = GcpIdTokenClient(useADC: true);
final token = await client.getIdToken(audience: 'https://your-service.com');
print('ID Token: $token');
```

### Using Metadata Server (for GCE/Cloud Run)

```dart
final client = GcpIdTokenClient(useADC: false); // `useADC` default to false
final token = await client.getIdToken(audience: 'https://your-service.com');
print('ID Token: $token');
```

### Default Configuration

```dart
// Uses Metadata server by default
final client = GcpIdTokenClient();
final token = await client.getIdToken(audience: 'https://your-service.com');
```

### Token Caching and Reuse

```dart
final client = GcpIdTokenClient();

// First call fetches the token
final token1 = await client.getIdToken(audience: 'https://your-service.com');

// Second call returns cached token if not expired
final token2 = await client.getIdToken(audience: 'https://your-service.com');

// Access current cached token
print('Current token: ${client.currentToken}');
```

### Making Authenticated HTTP Requests

```dart
import 'package:http/http.dart' as http;

final client = GcpIdTokenClient();
final token = await client.getIdToken(audience: 'https://your-protected-service.com');

final response = await http.get(
  Uri.parse('https://your-protected-service.com/api/data'),
  headers: {
    'Authorization': 'Bearer $token',
  },
);
```

## Authentication Methods

### Application Default Credentials (ADC)

Use when:
- Running locally with `gcloud auth application-default login`
- Using service account key files
- Running on GCP with attached service accounts

### Metadata Server

Use when:
- Running on Google Compute Engine
- Running on Cloud Run
- Running on Google Kubernetes Engine
- Any GCP service with attached service accounts

## Requirements

- **Dart SDK**: >=2.17.0 <4.0.0
- **GCP Environment**: Must run in a GCP environment or with proper ADC setup
- **Service Account**: Requires a service account with appropriate permissions

## Dependencies

This package depends on:
- `googleapis_auth` - For Application Default Credentials
- `http` - For HTTP requests to metadata server
- `jwt_decode` - For JWT token parsing and validation

## Related Terms

- **Google Cloud Platform (GCP)**: Cloud computing platform by Google
- **Identity Token**: JWT token used for service-to-service authentication
- **Metadata Server**: GCP service providing instance metadata and credentials
- **Service Account**: Non-human account for applications and services
- **JWT (JSON Web Token)**: Compact token format for secure information transmission

## Additional Resources

- [Google Cloud Identity and Access Management](https://cloud.google.com/iam)
- [Application Default Credentials](https://cloud.google.com/docs/authentication/application-default-credentials)
- [Service Account Authentication](https://cloud.google.com/docs/authentication/service-accounts)
- [Cloud Run Authentication](https://cloud.google.com/run/docs/authenticating/service-to-service)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
