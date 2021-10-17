import Foundation

public protocol PerduxEffect {
    func apply()
    static var executionQueue: DispatchQueue { get }
}
