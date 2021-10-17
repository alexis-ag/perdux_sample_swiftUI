import Foundation

public protocol PerduxAction {
    static var executionQueue: DispatchQueue { get }
}