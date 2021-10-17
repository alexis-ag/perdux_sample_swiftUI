import Foundation

extension Optional {
    var isNotNil: Bool {
        switch self {
        case .none: return false
        case .some(_): return  true
        }
    }

    var isNil: Bool {
        switch self {
        case .none: return true
        case .some(_): return false
        }
    }
}
