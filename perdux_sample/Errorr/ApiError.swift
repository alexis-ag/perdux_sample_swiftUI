import Foundation

struct ApiError: IAppError {
    let violation: ErrorViolation
    let sender: Mirror
    let message: String
    let callStack: [String]
    let error: Error?
    let url: String
    let responseCode: Int
    let requestType: ApiRequestType
    let headers: [HeaderKey: HeaderValue]
    let params: [ParamKey: ParamValue]

    var conciseDescription: String {
        "\(responseCode): \(violation) from \(sender); \(message)"
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
            url: String,
            responseCode: Int = 0,
            message: String = "",
            violation: ErrorViolation = .warning,
            error: Error? = nil,
            requestType: ApiRequestType,
            headers: [HeaderKey: HeaderValue] = [:],
            params: [ParamKey: ParamValue] = [:]
    ) {
        self.sender = Mirror(reflecting: sender)
        self.url = url
        self.responseCode = responseCode
        self.message = message
        self.violation = violation
        self.callStack = Thread.callStackSymbols
        self.headers = headers
        self.params = params
        self.error = error
        self.requestType = requestType
    }

    func toString() -> String {
        data.map { "\($0.key): \($0.value)" }.joined(separator: "\n");
    }

    #warning("sometimes the callstack does not contain the desired array and execution fails")
    var data: [String: String] {
        [
            "sender": "\(sender.subjectType)",
            "url": url,
            "type": "\(requestType.rawValue)",
            "headers": "\(headers)",
            "params": "\(params)",
            "responseCode": "\(responseCode)",
            "message": message,
            "violation": violation.rawValue,
            "cause": error?.localizedDescription ?? "",
            "callStack": "\n\(callStack.joined(separator: "\n"))"
        ]
    }
}
