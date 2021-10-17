import Foundation

struct CustomNSError: IAppError {
    let sender: Mirror
    let callStack: [String]
    let error: Error? = nil
    let message: String
    let violation: ErrorViolation
    let exception: NSException

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
            violation: ErrorViolation,
            exception: NSException
    ) {
        self.sender = Mirror(reflecting: sender)
        self.callStack = exception.callStackSymbols
        self.message = message
        self.violation = violation
        self.exception = exception
    }

    func toString() -> String {
        data.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
    }

    var data: [String: String] {
        [
            "sender": "\(sender.subjectType)",
            "message": "\(exception.name)",
            "violation": violation.rawValue,
            "cause": exception.reason ?? "",
            "callStack": "\n\(callStack.joined(separator: "\n"))"
        ]
    }
}
