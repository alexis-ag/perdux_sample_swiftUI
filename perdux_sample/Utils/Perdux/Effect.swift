import Foundation

public protocol Effect {
    func apply()
    static var executionQueue: DispatchQueue { get }
}
