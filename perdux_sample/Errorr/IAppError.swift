import Foundation

protocol ConciseErrorStringConvertible {
    var conciseDescription: String { get }
}

protocol IAppError: Error, ConciseErrorStringConvertible, CustomDebugStringConvertible, CustomStringConvertible {
    var violation: ErrorViolation { get }
    var message: String { get }
    var callStack: [String] { get }
    var sender: Mirror { get }
    var error: Error? { get }
    func toString() -> String
    var data: [String: String] { get }
}
