/// Result of checking a product code against the verification service.
enum VerificationStatus { genuine, counterfeit, unknown }

class VerificationResult {
  final String code;
  final VerificationStatus status;
  final String? productName;
  final String? brand;
  final String? message;

  const VerificationResult({
    required this.code,
    required this.status,
    this.productName,
    this.brand,
    this.message,
  });
}

/// Verifies agro-input product codes (seeds, fertilizer, pesticide).
///
/// This wraps the idea of dialling into brand-specific verification
/// backends (e.g. SEEDCODEX-style USSD/SMS lookups) behind one simple
/// interface. In production, [verify] would call each brand's API/USSD
/// gateway; here it is backed by a small local registry plus a checksum
/// rule so the app is fully testable offline and the integration surface
/// (this class) does not need to change when real backends are wired in.
class VerificationService {
  /// A small local registry standing in for real brand backends, keyed by
  /// the exact code a farmer would scan or type in.
  static const Map<String, _KnownProduct> _registry = {
    'SC-1234-5678': _KnownProduct(name: 'Hybrid Maize Seed', brand: 'SEEDCO', genuine: true),
    'SC-0000-0000': _KnownProduct(name: 'Hybrid Maize Seed', brand: 'SEEDCO', genuine: false),
    'NPK-2024-NG01': _KnownProduct(name: 'NPK 20-10-10 Fertilizer', brand: 'NAFCON', genuine: true),
    'AGR-9999-XXXX': _KnownProduct(name: 'Cypermethrin Pesticide', brand: 'AgroChem', genuine: false),
  };

  /// Validates the raw shape of a code before attempting a lookup.
  ///
  /// Real brand codes are alphanumeric, dash-separated and at least 8
  /// characters excluding dashes. This is a cheap client-side sanity check,
  /// not the source of truth for authenticity.
  bool isPlausibleCode(String rawCode) {
    final code = rawCode.trim();
    if (code.isEmpty) return false;
    final stripped = code.replaceAll('-', '');
    if (stripped.length < 6) return false;
    final validChars = RegExp(r'^[A-Za-z0-9-]+$');
    return validChars.hasMatch(code);
  }

  /// Looks up [rawCode] and returns a [VerificationResult].
  ///
  /// Codes found in the registry are reported as genuine/counterfeit
  /// exactly as recorded. Codes with a plausible shape but no registry
  /// match come back as [VerificationStatus.unknown] so the farmer is told
  /// to double check with the dealer rather than being given a false
  /// positive.
  VerificationResult verify(String rawCode) {
    final code = rawCode.trim().toUpperCase();

    if (!isPlausibleCode(code)) {
      return VerificationResult(
        code: code,
        status: VerificationStatus.unknown,
        message: 'That does not look like a valid product code.',
      );
    }

    final known = _registry[code];
    if (known == null) {
      return VerificationResult(code: code, status: VerificationStatus.unknown);
    }

    return VerificationResult(
      code: code,
      status: known.genuine ? VerificationStatus.genuine : VerificationStatus.counterfeit,
      productName: known.name,
      brand: known.brand,
    );
  }
}

class _KnownProduct {
  final String name;
  final String brand;
  final bool genuine;
  const _KnownProduct({required this.name, required this.brand, required this.genuine});
}
