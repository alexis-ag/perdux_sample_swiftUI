import Foundation

struct AppError: IAppError {
    let violation: ErrorViolation
    let sender: Mirror
    let message: String
    let callStack: [String]
    let error: Error?

    var conciseDescription: String {
        "\(violation) from \(sender); \(message)"
    }

    #warning("think about what data could be useful within custom description")
    var description: String {
        conciseDescription
    }

    var debugDescription: String {
        conciseDescription
    }

    init(
            sender: Any,
            message: String,
            violation: ErrorViolation = .warning,
            error: Error? = nil
    ) {
        self.sender = Mirror(reflecting: sender)
        self.message = message
        self.violation = violation
        self.callStack = Thread.callStackSymbols
        self.error = error
    }

    func toString() -> String {
        data.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
    }

    var data: [String: String] {
        [
            "sender": "\(sender.subjectType)",
            "message": message,
            "violation": violation.rawValue,
            "cause": error?.localizedDescription ?? "",
            "callStack": "\n\(callStack.joined(separator: "\n"))"
        ]
    }
}
