import Foundation

public protocol ReduxAction {
    static var executionQueue: DispatchQueue { get }
}