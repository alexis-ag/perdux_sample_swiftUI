import Foundation
import CommonCrypto

extension String {
    var removingWhitespaces: String {
        components(separatedBy: .whitespaces).joined()
    }
    func replacingWhitespaces(with character: Character) -> Self {
        components(separatedBy: .whitespaces).joined(separator: String(character))
    }
}

extension String {
    func cleanHtml() -> String {
        self.replacingOccurrences(
                of: "<[^>]+>",
                with: "",
                options: .regularExpression,
                range: nil
        )
    }

    func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = NSLocale(localeIdentifier: "en_us_POSIX") as Locale

        return formatter.date(from: self)
    }

    func clean(pattern: String) -> String {
        self.replacingOccurrences(
                of: pattern,
                with: "",
                options: .regularExpression,
                range: nil
        )
    }

    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }

    func md5() -> String {
        let data = Data(utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

        data.withUnsafeBytes { buffer in
            _ = CC_MD5(buffer.baseAddress, CC_LONG(buffer.count), &hash)
        }

        return hash.map { String(format: "%02hhx", $0) }.joined()
    }

    var isNotEmpty: Bool {
        !self.isEmpty
    }
}

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }

    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

extension String {
    var fromBase64: String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    var toBase64: String {
        Data(self.utf8).base64EncodedString()
    }
}
