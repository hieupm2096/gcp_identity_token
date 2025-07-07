import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

const _metadataServerUrl =
    'http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/identity';

/// {@template gcp_identity_token}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class GcpIdTokenClient {
  /// {@macro gcp_identity_token}
  GcpIdTokenClient({
    this.useADC = false,
  });

  /// Whether to use Application Default Credentials (ADC) or Metadata server.
  final bool useADC;

  final _currentTokens = <String, String>{};

  /// Retrieves the current GCP identity token.
  String? getCurrentToken(String audience) => _currentTokens[audience];

  /// Returns the GCP identity token for the given audience.
  /// If [useADC] is true, it will use Application Default Credentials (ADC).
  /// If [useADC] is false, it will use Metadata server to retrieve token.
  Future<String> getIdToken({required String audience}) async {
    // If we have a token and it's not expired, return it
    if (_currentTokens.containsKey(audience)) {
      final now = DateTime.now();
      final token = _currentTokens[audience]!;
      final expiry = Jwt.getExpiryDate(token)!;
      
      // Add a small buffer (e.g., 1 minute) to avoid using a token that's about to expire
      if (now.isBefore(expiry.subtract(const Duration(minutes: 1)))) {
        return token;
      }
    }

    // Fetch a new token and cache it
    final token = useADC ? await _getIdTokenFromADC() : await _getIdTokenFromMetadataServer(audience);

    _currentTokens[audience] = token;

    return token;
  }

  Future<String> _getIdTokenFromMetadataServer(String audience) async {
    final uri = Uri.parse('$_metadataServerUrl?audience=$audience');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Metadata-Flavor': 'Google',
        },
      );

      if (response.statusCode == 200) {
        // The response body contains the ID token
        return response.body;
      } else {
        // Handle the error based on the status code
        throw Exception('Failed to get ID token: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching ID token: $e');
    }
  }

  Future<String> _getIdTokenFromADC() async {
    final credentials = await clientViaApplicationDefaultCredentials(
      scopes: ['https://www.googleapis.com/auth/cloud-platform'],
    );

    return credentials.credentials.idToken!;
  }
}
