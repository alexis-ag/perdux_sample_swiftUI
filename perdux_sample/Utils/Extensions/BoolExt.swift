import Foundation

extension Bool {
    var inversion: Bool {
        self.not
    }

    var not: Bool {
        !self
    }

    var negative: Bool {
        !self
    }

    var positive: Bool {
        self
    }
}