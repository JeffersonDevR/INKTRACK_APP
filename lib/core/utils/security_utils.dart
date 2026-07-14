/// Security utilities for input sanitization and validation
/// Follows OWASP best practices

class SecurityUtils {
  /// Sanitizes user input to prevent injection attacks
  /// Removes or escapes potentially dangerous characters
  static String sanitizeInput(String input, {bool allowSpecialChars = false}) {
    if (input.isEmpty) return '';
    
    // Remove leading/trailing whitespace
    String sanitized = input.trim();
    
    // Escape SQL special characters if this will be used in queries
    sanitized = sanitized
        .replaceAll("'", "''")  // Escape single quotes for SQL
        .replaceAll("\"", "\\\"");  // Escape double quotes
    
    if (!allowSpecialChars) {
      // Remove potentially dangerous characters for certain fields
      sanitized = sanitized.replaceAll(RegExp(r'[<>{}|\\^`~\[\]]'), '');
    }
    
    // Limit length to prevent buffer overflow-like attacks
    if (sanitized.length > 1000) {
      sanitized = sanitized.substring(0, 1000);
    }
    
    return sanitized;
  }

  /// Sanitizes phone numbers - keeps only digits and common formatting chars
  static String sanitizePhoneNumber(String input) {
    // Keep only digits, spaces, dashes, parentheses, and +
    return input.replaceAll(RegExp(r'[^\d\s\-()+ ]'), '');
  }

  /// Sanitizes product/item names - allows letters, numbers, common punctuation
  static String sanitizeProductName(String input) {
    final sanitized = input.trim();
    // Remove very long inputs
    if (sanitized.length > 255) {
      return sanitized.substring(0, 255);
    }
    // Allow letters, numbers, spaces, and common punctuation
    return sanitized.replaceAll(RegExp(r'[<>{}|\\^`~\[\]]+'), '');
  }

  /// Sanitizes file paths to prevent directory traversal attacks
  static String sanitizeFilePath(String input) {
    var sanitized = input
        .replaceAll('\\', '/')      // Normalize backslashes
        .replaceAll(RegExp(r'\.+/'), '');  // Remove ../ sequences
    
    // Remove absolute path attempts
    if (sanitized.startsWith('/')) {
      sanitized = sanitized.substring(1);
    }
    
    return sanitized;
  }

  /// Checks if a string contains SQL injection attempts
  static bool isSuspiciousSQLInput(String input) {
    const sqlKeywords = [
      'SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE',
      'ALTER', 'EXEC', 'EXECUTE', 'UNION', '--', ';', '/*', '*/',
    ];
    
    final upperInput = input.toUpperCase();
    for (final keyword in sqlKeywords) {
      if (upperInput.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  /// Checks if a string contains XSS attempts
  static bool isSuspiciousXSSInput(String input) {
    const xssPatterns = [
      '<script',
      'javascript:',
      'onerror=',
      'onload=',
      'onclick=',
      'onmouseover=',
      'oninput=',
      'onfocus=',
      '</iframe',
      '<iframe',
    ];
    
    final lowerInput = input.toLowerCase();
    for (final pattern in xssPatterns) {
      if (lowerInput.contains(pattern)) {
        return true;
      }
    }
    return false;
  }

  /// Validates that input doesn't contain injection attempts
  static String? validateSecurityThreats(String input) {
    if (isSuspiciousSQLInput(input)) {
      return 'Input contains suspicious SQL patterns';
    }
    if (isSuspiciousXSSInput(input)) {
      return 'Input contains suspicious script patterns';
    }
    return null;
  }

  /// Generates a safe filename from user input
  static String generateSafeFilename(String originalName) {
    // Remove path separators and suspicious characters
    var safe = originalName
        .replaceAll(RegExp(r'[\/\\]'), '_')
        .replaceAll(RegExp(r'[<>:"|?*]'), '_')
        .replaceAll(RegExp(r'\.+'), '.')
        .trim();
    
    // Ensure not empty
    if (safe.isEmpty) {
      safe = 'file_${DateTime.now().millisecondsSinceEpoch}';
    }
    
    // Limit length
    if (safe.length > 255) {
      safe = safe.substring(0, 200);
    }
    
    return safe;
  }

  /// Masks sensitive data like phone numbers or partial credit card
  static String maskSensitiveData(String input, {int visibleChars = 4}) {
    if (input.length <= visibleChars) {
      return input;
    }
    
    final masked = '*' * (input.length - visibleChars);
    return masked + input.substring(input.length - visibleChars);
  }
}
