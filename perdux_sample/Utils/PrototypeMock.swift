import Foundation

func undefined<T>(_ message: String = "") -> T {
    fatalError("Undefined \(T.self) \(message.isNotEmpty ? ": \(message)" : "")")
}